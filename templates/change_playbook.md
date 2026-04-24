# Change Playbook

This document is an operational checklist for quickly deciding what to inspect and how to verify a change.

Principles:
- Keep structural facts in `docs/ai/project_memory.md`.
- Keep only change procedures and verification routines here.
- Keep this concise. Retain only change types that recur often.

## Invariant Check
Before changing behavior, state, schema, storage, cache, sync, generated output, or fallback/failover behavior, check:
- SSoT: which canonical owner is changing? Are caches, indexes, and generated outputs still derivatives, and can misses self-heal from canonical live truth?
- SRP: which module, file, or function owns this responsibility?
- Consistency: which data, state, schema, UI, docs, tests, or generated outputs must stay aligned?
- Atomicity: what prevents partial state from being exposed?
- Idempotency: if the same operation runs twice, does it end in the same final state?
- No Silent Fallback: are failures observable? Is failover explicit, and does it preserve canonical truth ownership?
- Existing violations: record unrelated pre-existing violations without widening scope automatically.

## Field / Schema / Metadata Change
- Inspect:
  - source-of-truth storage boundaries
  - load / save / extract / serialize boundaries
  - related UI input/display fields
  - related tests
- Common misses:
  - defaults and empty states
  - backward compatibility
  - documentation updates
- Required verification:
  - relevant unit/integration tests
  - save-and-reload path

## UI / Panel Change
- Inspect:
  - route / payload shape
  - backing service / persistence
  - stale docs / screenshots / UX copy
  - frontend/static tests
- Common misses:
  - hidden but still wired state
  - removed fields still present in server/persistence paths
- Required verification:
  - focused UI/static tests
  - localhost smoke if operator-facing flow changed

## Sync / Integration Change
- Inspect:
  - local source artifact
  - sync adapter / service layer
  - external linkage fields
  - retry / error handling
- Common misses:
  - manual login / auth assumptions
  - stale cached IDs / remote references
- Required verification:
  - focused regression tests
  - real smoke when the bug is tied to a live external path

## Output / Rendering Change
- Inspect:
  - local output artifact
  - downstream render/save path
  - normalization / formatting layer
  - snapshot or payload tests
- Common misses:
  - format drift after round-trip
  - preview and saved output diverge
- Required verification:
  - focused output tests
  - one real round-trip or smoke when feasible

## Docs / Verification Expectations
- Always separate:
  - facts confirmed from docs
  - facts confirmed from the live workspace
  - assumptions
- Before claiming completion, report:
  - changed files
  - tests actually run
  - not verified items explicitly marked
- At session close:
  - inspect git evidence first
  - then update `current_state.md` and handoff docs
