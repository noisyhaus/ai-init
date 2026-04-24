#!/usr/bin/env bash
set -euo pipefail

CLI_TARGET="$HOME/.local/bin/ai-init"
SKILL_TARGET_ROOT="$HOME/.codex/skills"
SKILL_NAMES=(
  ai-init
  ai-init-start-work
  ai-init-feature-addition
  ai-init-bugfix
  ai-init-session-recovery
  ai-init-session-close
  ai-init-finish-work
  ai-init-pressure-test
)

usage() {
  cat <<'USAGE'
Usage: ./uninstall.sh [--help]

Remove the public ai-init install targets if they are symlinks:
  ~/.codex/skills/ai-init*
  ~/.local/bin/ai-init
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
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

remove_symlink() {
  local target="$1"

  if [ -L "$target" ]; then
    rm "$target"
    printf 'rm    %s\n' "$target"
    return
  fi

  if [ -e "$target" ]; then
    printf 'skip  %s (not a symlink; leaving it in place)\n' "$target"
    return
  fi

  printf 'skip  %s (not installed)\n' "$target"
}

for skill_name in "${SKILL_NAMES[@]}"; do
  remove_symlink "$SKILL_TARGET_ROOT/$skill_name"
done

remove_symlink "$CLI_TARGET"

cat <<EOF

ai-init uninstall complete.
EOF
