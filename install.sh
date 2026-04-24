#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

SKILL_SOURCE="$REPO_ROOT/skills/ai-init"
CLI_SOURCE="$REPO_ROOT/bin/ai-init"

SKILL_TARGET="$HOME/.codex/skills/ai-init"
CLI_TARGET="$HOME/.local/bin/ai-init"

force=0

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--force] [--help]

Install ai-init for Codex by creating two symlinks:
  ~/.codex/skills/ai-init  -> <repo>/skills/ai-init
  ~/.local/bin/ai-init     -> <repo>/bin/ai-init

Options:
  --force  Replace existing paths at the install targets
  --help   Show this message
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --force)
      force=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [ ! -d "$SKILL_SOURCE" ]; then
  printf 'Missing skill source: %s\n' "$SKILL_SOURCE" >&2
  exit 1
fi

if [ ! -f "$CLI_SOURCE" ]; then
  printf 'Missing CLI source: %s\n' "$CLI_SOURCE" >&2
  exit 1
fi

mkdir -p "$(dirname "$SKILL_TARGET")" "$(dirname "$CLI_TARGET")"
chmod +x "$CLI_SOURCE" "$SKILL_SOURCE/scripts/run-ai-init.sh"

link_path() {
  local source="$1"
  local target="$2"

  if [ -L "$target" ]; then
    local current_target
    current_target="$(readlink "$target")"
    if [ "$current_target" = "$source" ]; then
      printf 'ok    %s -> %s\n' "$target" "$source"
      return
    fi
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$force" -ne 1 ]; then
      printf 'Refusing to replace existing path: %s\n' "$target" >&2
      printf 'Re-run with --force if you want this installer to replace it.\n' >&2
      exit 1
    fi
    rm -rf "$target"
    printf 'rm    %s\n' "$target"
  fi

  ln -s "$source" "$target"
  printf 'link  %s -> %s\n' "$target" "$source"
}

link_path "$SKILL_SOURCE" "$SKILL_TARGET"
link_path "$CLI_SOURCE" "$CLI_TARGET"

cat <<EOF

ai-init install complete.

Installed paths:
  Skill: $SKILL_TARGET
  CLI:   $CLI_TARGET

Next:
  1. cd /path/to/target-project
  2. Start Codex in that directory
  3. Type: \$ai-init
EOF
