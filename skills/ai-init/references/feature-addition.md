
# AI Init Feature Addition

Do not jump straight into code.

## Workflow

1. Reconnect the request to existing context:
   - `docs/ai/project_memory.md`
   - `docs/ai/change_playbook.md`
   - `docs/ai/current_state.md`
   - relevant spec/plan docs
2. Summarize how the feature touches current structure, source-of-truth files, and verification rules.
3. Add an `Invariant Impact` note before design choices:
   - SSoT: which canonical truth owner changes, which caches/indexes/generated outputs remain derivative, and whether misses self-heal from canonical live truth
   - SRP: which module/file/function owns the new responsibility
   - Consistency: which data, state, schema, UI, docs, tests, or generated outputs must stay aligned
   - Atomicity: what prevents partial state from being exposed
   - Idempotency: what repeated execution should do
   - No Silent Fallback: which failures must be observable, and whether any failover is explicit without changing canonical truth ownership
4. Run a brainstorming-style scoping pass:
   - goal
   - scope
   - non-scope
   - success criteria
   - constraints
5. Propose the core design choices and trade-offs before implementation.
6. Review design quality:
   - is the structure clean
   - is the scope appropriate
   - is the feature actually implementable
7. Review the feature's validity conditions:
   - what required state, permissions, identifiers, storage, events, and async control must exist
   - whether the current design actually provides them
   - if something is missing, classify it as impossible vs. merely inconvenient
8. Pressure-test the design yourself before saving it:
   - missing requirements
   - scope bloat
   - risky design choices
   - test, rollback, or operational risks
   - simpler alternatives
9. Save the design result under `docs/superpowers/specs/`.
10. Write the implementation plan under `docs/superpowers/plans/`.
    - If a local planning skill such as `writing-plans` or `plan` is installed, use it.
    - Otherwise include objective, scope, work breakdown, touched files, verification, risks, rollback notes, and the first task.
11. Finish by proposing only the first execution task.

## Guardrails

- No implementation before the spec and plan exist.
- Reuse existing docs instead of inventing a parallel source-of-truth layer.
- Every spec and plan must assess SSoT, SRP, Consistency, Atomicity, Idempotency, and No Silent Fallback before implementation.
- Apply these checks to new or changed surfaces. Record unrelated pre-existing violations without automatically widening scope.
- Keep invariant text short in AGENTS-style outputs; put detailed checks in project docs, specs, plans, or workflow gates.
- Keep the first execution task small, concrete, and testable.
- Treat missing prerequisite state or authority as a feasibility blocker when it makes the feature impossible, not just inconvenient.
