#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

CLI_SOURCE="$REPO_ROOT/bin/ai-init"
CLI_TARGET="$HOME/.local/bin/ai-init"
SKILL_ROOT="$REPO_ROOT/skills"
SKILL_TARGET_ROOT="$HOME/.codex/skills"
SKILL_NAMES=(
  ai-init
  ai-init-start-work
  ai-init-feature-addition
  ai-init-bugfix
  ai-init-session-recovery
  ai-init-session-close
  ai-init-finish-work
)
LEGACY_SKILL_NAMES=(
  ai-init-pressure-test
)

force=0

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--force] [--help]

Install ai-init for Codex by creating public skill and CLI symlinks:
  ~/.codex/skills/ai-init                   -> <repo>/skills/ai-init
  ~/.codex/skills/ai-init-start-work        -> <repo>/skills/ai-init-start-work
  ~/.codex/skills/ai-init-feature-addition  -> <repo>/skills/ai-init-feature-addition
  ~/.codex/skills/ai-init-bugfix            -> <repo>/skills/ai-init-bugfix
  ~/.codex/skills/ai-init-session-recovery  -> <repo>/skills/ai-init-session-recovery
  ~/.codex/skills/ai-init-session-close     -> <repo>/skills/ai-init-session-close
  ~/.codex/skills/ai-init-finish-work       -> <repo>/skills/ai-init-finish-work
  ~/.local/bin/ai-init                      -> <repo>/bin/ai-init

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

if [ ! -f "$CLI_SOURCE" ]; then
  printf 'Missing CLI source: %s\n' "$CLI_SOURCE" >&2
  exit 1
fi

for skill_name in "${SKILL_NAMES[@]}"; do
  if [ ! -d "$SKILL_ROOT/$skill_name" ]; then
    printf 'Missing skill source: %s\n' "$SKILL_ROOT/$skill_name" >&2
    exit 1
  fi
done

mkdir -p "$SKILL_TARGET_ROOT" "$(dirname "$CLI_TARGET")"
chmod +x "$CLI_SOURCE" "$SKILL_ROOT/ai-init/scripts/run-ai-init.sh"

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

remove_legacy_symlink() {
  local target="$1"

  if [ -L "$target" ]; then
    rm "$target"
    printf 'rm    %s (legacy)\n' "$target"
  fi
}

for skill_name in "${SKILL_NAMES[@]}"; do
  link_path "$SKILL_ROOT/$skill_name" "$SKILL_TARGET_ROOT/$skill_name"
done

for skill_name in "${LEGACY_SKILL_NAMES[@]}"; do
  remove_legacy_symlink "$SKILL_TARGET_ROOT/$skill_name"
done

link_path "$CLI_SOURCE" "$CLI_TARGET"

cat <<EOF

ai-init install complete.

Installed paths:
  Skills:
$(for skill_name in "${SKILL_NAMES[@]}"; do printf '    %s/%s\n' "$SKILL_TARGET_ROOT" "$skill_name"; done)
  CLI:
    $CLI_TARGET

Next:
  1. cd /path/to/target-project
  2. Start Codex in that directory
  3. Type one of:
     - \$ai-init
     - \$ai-init-start-work
     - \$ai-init-feature-addition
     - \$ai-init-bugfix
     - \$ai-init-session-recovery
     - \$ai-init-session-close
     - \$ai-init-finish-work
EOF
