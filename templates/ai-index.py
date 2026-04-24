#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import re
import sqlite3
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DB_PATH = ROOT / ".ai-index" / "db.sqlite"

INDEX_PATTERNS: tuple[str, ...] = (
    "docs/START_HERE.md",
    "docs/ai/project_memory.md",
    "docs/ai/change_playbook.md",
    "docs/ai/current_state.md",
    "docs/ai/agent_memory.md",
    "docs/ai/user_preferences.md",
    "docs/ai/handoffs/*.md",
    "docs/superpowers/specs/*.md",
    "docs/superpowers/plans/*.md",
    "docs/adr/*.md",
)

SCHEMA = """
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS indexed_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rel_path TEXT NOT NULL UNIQUE,
    doc_kind TEXT NOT NULL,
    sha256 TEXT NOT NULL,
    mtime_ns INTEGER NOT NULL,
    indexed_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS indexed_sections (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_id INTEGER NOT NULL,
    section_order INTEGER NOT NULL,
    heading TEXT NOT NULL,
    heading_path TEXT NOT NULL,
    heading_level INTEGER NOT NULL,
    start_line INTEGER NOT NULL,
    end_line INTEGER NOT NULL,
    body TEXT NOT NULL,
    FOREIGN KEY(file_id) REFERENCES indexed_files(id) ON DELETE CASCADE,
    UNIQUE(file_id, section_order)
);

CREATE VIRTUAL TABLE IF NOT EXISTS indexed_sections_fts USING fts5(
    heading,
    heading_path,
    body,
    content='indexed_sections',
    content_rowid='id',
    tokenize='unicode61 remove_diacritics 2'
);

CREATE TRIGGER IF NOT EXISTS indexed_sections_ai AFTER INSERT ON indexed_sections BEGIN
    INSERT INTO indexed_sections_fts(rowid, heading, heading_path, body)
    VALUES (new.id, new.heading, new.heading_path, new.body);
END;

CREATE TRIGGER IF NOT EXISTS indexed_sections_ad AFTER DELETE ON indexed_sections BEGIN
    INSERT INTO indexed_sections_fts(indexed_sections_fts, rowid, heading, heading_path, body)
    VALUES ('delete', old.id, old.heading, old.heading_path, old.body);
END;

CREATE TRIGGER IF NOT EXISTS indexed_sections_au AFTER UPDATE ON indexed_sections BEGIN
    INSERT INTO indexed_sections_fts(indexed_sections_fts, rowid, heading, heading_path, body)
    VALUES ('delete', old.id, old.heading, old.heading_path, old.body);
    INSERT INTO indexed_sections_fts(rowid, heading, heading_path, body)
    VALUES (new.id, new.heading, new.heading_path, new.body);
END;
"""

HEADING_RE = re.compile(r"^(#{1,6})[ \t]+(.+?)\s*$")
FENCE_RE = re.compile(r"^([`~]{3,})(.*)$")


def parse_args(argv=None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build and query the local docs recall index.")
    parser.add_argument("--root", default=".", help="Repo root containing docs/. Default: current directory")
    parser.add_argument("--db", default=str(DEFAULT_DB_PATH), help="SQLite DB path. Default: .ai-index/db.sqlite")

    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("rebuild", help="Rebuild the docs index from scratch")
    subparsers.add_parser("update", help="Refresh only changed indexed docs")

    search_parser = subparsers.add_parser("search", help="Search indexed docs")
    search_parser.add_argument("query", help="FTS query string")
    search_parser.add_argument("--limit", type=int, default=5, help="Maximum number of hits to return")
    return parser.parse_args(argv)


def discover_index_targets(root: Path = ROOT) -> list[Path]:
    seen: set[Path] = set()
    targets: list[Path] = []
    for pattern in INDEX_PATTERNS:
        for path in sorted(root.glob(pattern)):
            if path.is_file() and path not in seen:
                seen.add(path)
                targets.append(path)
    return sorted(targets, key=lambda path: str(path.relative_to(root)))


def split_markdown_sections(text: str, rel_path: str) -> list[dict[str, Any]]:
    lines = text.splitlines()
    sections: list[dict[str, Any]] = []
    heading_stack: list[tuple[int, str]] = []
    in_fence = False
    fence_char = ""
    fence_length = 0
    current = {
        "heading": "preamble",
        "heading_path": "preamble",
        "heading_level": 0,
        "start_line": 1,
        "body_lines": [],
    }

    def flush(end_line: int) -> None:
        body = "\n".join(current["body_lines"]).strip()
        has_body_lines = bool(current["body_lines"])
        if not body and current["heading"] == "preamble" and not has_body_lines:
            return
        sections.append(
            {
                "rel_path": rel_path,
                "heading": current["heading"],
                "heading_path": current["heading_path"],
                "heading_level": current["heading_level"],
                "start_line": current["start_line"],
                "end_line": end_line,
                "body": body,
            }
        )

    for line_number, line in enumerate(lines, start=1):
        stripped = line.lstrip()
        fence_match = FENCE_RE.match(stripped)
        if fence_match:
            fence_token = fence_match.group(1)
            if not in_fence:
                in_fence = True
                fence_char = fence_token[0]
                fence_length = len(fence_token)
            elif fence_token[0] == fence_char and len(fence_token) >= fence_length:
                in_fence = False

        if not in_fence:
            heading_match = HEADING_RE.match(line)
            if heading_match:
                flush(line_number - 1)
                level = len(heading_match.group(1))
                heading = heading_match.group(2).strip()
                while heading_stack and heading_stack[-1][0] >= level:
                    heading_stack.pop()
                heading_stack.append((level, heading))
                current = {
                    "heading": heading,
                    "heading_path": " > ".join(item[1] for item in heading_stack),
                    "heading_level": level,
                    "start_line": line_number,
                    "body_lines": [],
                }
                continue

        current["body_lines"].append(line)

    flush(len(lines))
    return sections


def rebuild_index(root: Path = ROOT, db_path: Path = DEFAULT_DB_PATH) -> dict[str, int]:
    if db_path.exists():
        db_path.unlink()
    return update_index(root, db_path)


def update_index(root: Path = ROOT, db_path: Path = DEFAULT_DB_PATH) -> dict[str, int]:
    db_path.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(db_path) as connection:
        connection.row_factory = sqlite3.Row
        connection.execute("PRAGMA foreign_keys = ON")
        connection.executescript(SCHEMA)

        indexed_at = datetime.now(timezone.utc).isoformat()
        targets = discover_index_targets(root)
        target_map = {str(path.relative_to(root)): path for path in targets}
        existing_rows = {
            row["rel_path"]: row
            for row in connection.execute("SELECT id, rel_path, sha256, mtime_ns FROM indexed_files")
        }

        deleted_files = 0
        for rel_path, row in existing_rows.items():
            if rel_path not in target_map:
                connection.execute("DELETE FROM indexed_files WHERE id = ?", (row["id"],))
                deleted_files += 1

        updated_files = 0
        skipped_files = 0

        for rel_path, path in target_map.items():
            text = path.read_text(encoding="utf-8")
            sha256 = hashlib.sha256(text.encode("utf-8")).hexdigest()
            mtime_ns = path.stat().st_mtime_ns
            current_sections = split_markdown_sections(text, rel_path)
            existing = existing_rows.get(rel_path)

            if existing and existing["sha256"] == sha256 and int(existing["mtime_ns"]) == int(mtime_ns):
                skipped_files += 1
                continue

            if existing:
                file_id = int(existing["id"])
                connection.execute(
                    "UPDATE indexed_files SET doc_kind = ?, sha256 = ?, mtime_ns = ?, indexed_at = ? WHERE id = ?",
                    (classify_doc_kind(rel_path), sha256, mtime_ns, indexed_at, file_id),
                )
                connection.execute("DELETE FROM indexed_sections WHERE file_id = ?", (file_id,))
            else:
                cursor = connection.execute(
                    "INSERT INTO indexed_files (rel_path, doc_kind, sha256, mtime_ns, indexed_at) VALUES (?, ?, ?, ?, ?)",
                    (rel_path, classify_doc_kind(rel_path), sha256, mtime_ns, indexed_at),
                )
                file_id = int(cursor.lastrowid)

            for section_order, section in enumerate(current_sections, start=1):
                connection.execute(
                    """
                    INSERT INTO indexed_sections (
                        file_id, section_order, heading, heading_path, heading_level, start_line, end_line, body
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    (
                        file_id,
                        section_order,
                        section["heading"],
                        section["heading_path"],
                        section["heading_level"],
                        section["start_line"],
                        section["end_line"],
                        section["body"],
                    ),
                )
            updated_files += 1

        file_count = int(connection.execute("SELECT COUNT(*) FROM indexed_files").fetchone()[0])
        section_total = int(connection.execute("SELECT COUNT(*) FROM indexed_sections").fetchone()[0])
        return {
            "file_count": file_count,
            "section_count": section_total,
            "updated_files": updated_files,
            "deleted_files": deleted_files,
            "skipped_files": skipped_files,
        }


def search_index(db_path: Path = DEFAULT_DB_PATH, query: str = "", limit: int = 5) -> list[dict[str, Any]]:
    if not query.strip():
        return []
    with sqlite3.connect(db_path) as connection:
        connection.row_factory = sqlite3.Row
        connection.execute("PRAGMA foreign_keys = ON")
        rows = connection.execute(
            """
            SELECT
                f.rel_path,
                f.doc_kind,
                s.heading_path,
                s.start_line,
                s.end_line,
                snippet(indexed_sections_fts, 2, '[', ']', ' ... ', 12) AS snippet,
                bm25(indexed_sections_fts) AS score
            FROM indexed_sections_fts
            JOIN indexed_sections AS s ON s.id = indexed_sections_fts.rowid
            JOIN indexed_files AS f ON f.id = s.file_id
            WHERE indexed_sections_fts MATCH ?
            ORDER BY score, f.rel_path, s.section_order
            LIMIT ?
            """,
            (build_match_query(query), limit),
        ).fetchall()
    return [dict(row) for row in rows]


def classify_doc_kind(rel_path: str) -> str:
    if rel_path == "docs/START_HERE.md":
        return "start_here"
    if rel_path == "docs/ai/project_memory.md":
        return "project_memory"
    if rel_path == "docs/ai/change_playbook.md":
        return "change_playbook"
    if rel_path == "docs/ai/current_state.md":
        return "current_state"
    if rel_path == "docs/ai/agent_memory.md":
        return "agent_memory"
    if rel_path == "docs/ai/user_preferences.md":
        return "user_preferences"
    if rel_path.startswith("docs/ai/handoffs/"):
        return "handoff"
    if rel_path.startswith("docs/superpowers/specs/"):
        return "spec"
    if rel_path.startswith("docs/superpowers/plans/"):
        return "plan"
    if rel_path.startswith("docs/adr/"):
        return "adr"
    return "other"


def build_match_query(query: str) -> str:
    tokens = [token.strip() for token in re.split(r"\s+", query) if token.strip()]
    if not tokens:
        return ""
    escaped_tokens = [token.replace('"', '""') for token in tokens]
    return " AND ".join(f'"{token}"' for token in escaped_tokens)


def main(argv=None) -> int:
    args = parse_args(argv)
    root = Path(args.root).resolve()
    db_path = Path(args.db).resolve()

    if args.command == "rebuild":
        print(json.dumps(rebuild_index(root, db_path), ensure_ascii=False, indent=2))
        return 0
    if args.command == "update":
        print(json.dumps(update_index(root, db_path), ensure_ascii=False, indent=2))
        return 0
    if args.command == "search":
        payload = {"results": search_index(db_path, args.query, limit=args.limit)}
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return 0
    raise ValueError(f"unsupported_command:{args.command}")


if __name__ == "__main__":
    raise SystemExit(main())
