#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_HOME="$(mktemp -d)"
TMP_PROJECT="$(mktemp -d)"
INSTALL_LOG="$ROOT_DIR/tests/.tmp-install.log"
REINSTALL_LOG="$ROOT_DIR/tests/.tmp-reinstall.log"
BOOTSTRAP_LOG="$ROOT_DIR/tests/.tmp-bootstrap.log"
UNINSTALL_LOG="$ROOT_DIR/tests/.tmp-uninstall.log"
SKILL_NAMES=(
  ai-init
  ai-init-start-work
  ai-init-feature-addition
  ai-init-bugfix
  ai-init-session-recovery
  ai-init-session-close
  ai-init-finish-work
)

cleanup() {
  rm -rf "$TMP_HOME" "$TMP_PROJECT"
  rm -f "$INSTALL_LOG" "$REINSTALL_LOG" "$BOOTSTRAP_LOG" "$UNINSTALL_LOG"
}

trap cleanup EXIT

assert_contains() {
  local file="$1"
  local expected="$2"
  if ! grep -Fq "$expected" "$file"; then
    printf 'Expected to find %s in %s\n' "$(printf '%q' "$expected")" "$file" >&2
    printf '%s\n' '--- file content ---' >&2
    sed -n '1,220p' "$file" >&2
    exit 1
  fi
}

assert_symlink_target() {
  local path="$1"
  local expected="$2"

  if [ ! -L "$path" ]; then
    printf 'Expected symlink: %s\n' "$path" >&2
    exit 1
  fi

  local actual
  actual="$(readlink "$path")"
  if [ "$actual" != "$expected" ]; then
    printf 'Expected %s -> %s, got %s\n' "$path" "$expected" "$actual" >&2
    exit 1
  fi
}

mkdir -p "$TMP_HOME/.codex/skills"
ln -s "$ROOT_DIR/skills/ai-init" "$TMP_HOME/.codex/skills/ai-init-pressure-test"

HOME="$TMP_HOME" "$ROOT_DIR/install.sh" > "$INSTALL_LOG"

assert_contains "$INSTALL_LOG" 'ai-init install complete.'
assert_contains "$INSTALL_LOG" 'ai-init-pressure-test (legacy)'
assert_contains "$INSTALL_LOG" '     - $ai-init'
assert_symlink_target "$TMP_HOME/.local/bin/ai-init" "$ROOT_DIR/bin/ai-init"
for skill_name in "${SKILL_NAMES[@]}"; do
  assert_symlink_target "$TMP_HOME/.codex/skills/$skill_name" "$ROOT_DIR/skills/$skill_name"
done
test ! -e "$TMP_HOME/.codex/skills/ai-init-pressure-test"

HOME="$TMP_HOME" "$ROOT_DIR/install.sh" > "$REINSTALL_LOG"
assert_contains "$REINSTALL_LOG" 'ok    '
assert_contains "$REINSTALL_LOG" '$ai-init-feature-addition'

cd "$TMP_PROJECT"
HOME="$TMP_HOME" "$TMP_HOME/.codex/skills/ai-init/scripts/run-ai-init.sh" --new-project > "$BOOTSTRAP_LOG"

assert_contains "$BOOTSTRAP_LOG" "ai-init complete for: $(basename "$TMP_PROJECT")"
assert_contains "$BOOTSTRAP_LOG" 'Start a new project.'

test -f AGENTS.md
test -f README.md
test -f docs/ai/project_memory.md
test -f docs/ai/change_playbook.md
test -f docs/ai/current_state.md
test -d docs/superpowers/specs
test -d docs/superpowers/plans

HOME="$TMP_HOME" "$ROOT_DIR/uninstall.sh" > "$UNINSTALL_LOG"
assert_contains "$UNINSTALL_LOG" 'ai-init uninstall complete.'

test ! -e "$TMP_HOME/.local/bin/ai-init"
for skill_name in "${SKILL_NAMES[@]}"; do
  test ! -e "$TMP_HOME/.codex/skills/$skill_name"
done

printf 'ai-init install script test passed\n'
