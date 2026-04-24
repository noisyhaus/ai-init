#!/usr/bin/env bash
set -euo pipefail

if [ -n "${AI_INIT_BIN:-}" ] && [ -x "${AI_INIT_BIN}" ]; then
  exec "${AI_INIT_BIN}" "$@"
fi

if [ -x "$HOME/.local/bin/ai-init" ]; then
  exec "$HOME/.local/bin/ai-init" "$@"
fi

if command -v ai-init >/dev/null 2>&1; then
  exec "$(command -v ai-init)" "$@"
fi

printf 'ai-init executable not found. Expected one of:\n' >&2
printf '  1. $AI_INIT_BIN\n  2. %s\n  3. ai-init on PATH\n' "$HOME/.local/bin/ai-init" >&2
exit 127
