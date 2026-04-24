#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

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

cd "$TMP_DIR"
"$ROOT_DIR/bin/ai-init" --new-project --with-rules > ai-init.log

assert_contains AGENTS.md '## Core Engineering Invariants'
assert_contains AGENTS.md 'SSoT: every durable truth has one canonical owner.'
assert_contains AGENTS.md 'on miss, prefer self-heal from canonical live truth.'
assert_contains AGENTS.md 'SRP: each module, file, and function should have one clear responsibility.'
assert_contains AGENTS.md 'Consistency: keep related data, state, schema, UI, docs, tests, and generated outputs aligned.'
assert_contains AGENTS.md 'Atomicity: state-changing work must fully succeed or roll back; do not expose known partial states.'
assert_contains AGENTS.md 'Idempotency: repeated execution of the same intended operation must produce the same final state.'
assert_contains AGENTS.md 'No Silent Fallback: do not hide primary-path failures with fallback, legacy, or shadow paths.'

assert_contains docs/ai/project_memory.md 'Source of truth for identifiers:'
assert_contains docs/ai/project_memory.md 'Generated outputs, caches, indexes, or recall layers that must not be treated as source of truth:'
assert_contains docs/ai/project_memory.md 'Self-heal rule for cache/index miss:'
assert_contains docs/ai/project_memory.md 'No Silent Fallback constraints:'

assert_contains docs/ai/change_playbook.md '## Invariant Check'
assert_contains docs/ai/change_playbook.md 'canonical live truth?'
assert_contains docs/ai/change_playbook.md 'Existing violations: record unrelated pre-existing violations without widening scope automatically.'

assert_contains docs/ai/rules/testing.md '# Testing Rules'

"$ROOT_DIR/bin/ai-init" --print-prompt --new-project > new-prompt.txt
"$ROOT_DIR/bin/ai-init" --print-prompt --existing-project > existing-prompt.txt

assert_contains new-prompt.txt 'Core Engineering Invariants (SSoT/SRP/Consistency/Atomicity/Idempotency/No Silent Fallback)'
assert_contains existing-prompt.txt 'Core Engineering Invariants (SSoT/SRP/Consistency/Atomicity/Idempotency/No Silent Fallback)'

printf 'ai-init generated-output invariant test passed\n'
