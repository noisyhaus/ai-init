# Project Agent Protocol

## Scope Rule
- Keep this file short, strict, and operational.
- Put only non-discoverable project protocol here.
- Do not duplicate README, obvious stack details, or directory listings.
- Put long-lived project facts in `docs/ai/project_memory.md`.
- Put change procedures and verification checklists in `docs/ai/change_playbook.md`.
- Put current session status in `docs/ai/current_state.md`.
- Put repeated corrections and durable working lessons in `docs/ai/agent_memory.md` when it exists.
- Put stable user preferences in `docs/ai/user_preferences.md` when it exists.
- Add detailed domain rules under `docs/ai/rules/` only when repetition justifies them.

## Startup Order
- Read `docs/ai/project_memory.md`
- Read `docs/ai/change_playbook.md` if it exists
- Read `docs/ai/current_state.md`
- Read `docs/ai/agent_memory.md` if it exists
- Read `docs/ai/user_preferences.md` if it exists
- If `.ai-index/` exists, use local recall only to narrow what to read next.
- Read only task-relevant rule/spec/plan/handoff docs.

## Working Style
- Do not assume unclear requirements. State assumptions explicitly.
- If multiple interpretations exist, do not choose silently. Surface the branch or ask.
- Prefer the simplest implementation that fully solves the request.
- Do not add speculative abstractions, flexibility, configurability, or future-proofing that was not requested.
- Keep changes surgical. Every changed line must trace directly to the task.
- Do not refactor, reformat, rename, or “improve” unrelated surrounding code.
- Remove only the unused code, imports, or variables created by your own change.
- If the solution feels overbuilt, simplify it before finishing.
- For non-trivial tasks, define brief success criteria and verify against them before claiming completion.

## Core Engineering Invariants
- SSoT: every durable truth has one canonical owner. Do not create parallel truth, shadow state, or legacy truth paths.
- Treat caches, indexes, generated files, and recall layers as rebuildable derivatives, not source of truth; on miss, prefer self-heal from canonical live truth.
- SRP: each module, file, and function should have one clear responsibility.
- Consistency: keep related data, state, schema, UI, docs, tests, and generated outputs aligned.
- Atomicity: state-changing work must fully succeed or roll back; do not expose known partial states.
- Idempotency: repeated execution of the same intended operation must produce the same final state.
- No Silent Fallback: do not hide primary-path failures with fallback, legacy, or shadow paths. Explicit observable failover is allowed only if canonical truth ownership does not change.
- Treat detailed project rules as derivations of these invariants.

## Workflow Routing
- New feature or behavior change: run a brainstorming-style scope pass, write or update a design draft under `docs/superpowers/specs/`, then write a plan under `docs/superpowers/plans/`.
- Bugfix or regression: use a systematic debugging loop: reproduce, identify root cause, make the minimal fix, and run a regression check.
- Cleanup or refactor: first lock behavior with tests or other concrete regression checks, then make the smallest possible change.
- Before claiming completion: run verification and report the evidence.
- Large finished changes: request code review when a local review workflow is available.

## Guardrails
- Do not make broad refactors unless required by the task.
- Do not silently resolve ambiguity that affects behavior, scope, or data shape.
- Do not add code for hypothetical future needs.
- Do not claim completion without verification evidence.
- During recovery, separate facts confirmed from docs from facts confirmed from the live workspace.
- If `.ai-index/` exists, treat it as a recall cache only. Markdown docs remain the source of truth.
- Keep this file short. Put detailed, repeating domain rules in `docs/ai/rules/`.

## Optional Rule Routing
- Frontend/UI work: `docs/ai/rules/web-frontend.md`, `docs/ai/rules/ui-ux.md`
- Backend/API work: `docs/ai/rules/backend-api.md`
- Automation/script work: `docs/ai/rules/automation.md`
- Testing work: `docs/ai/rules/testing.md`

## State Updates
- At session close, collect git evidence first (`git status --short`, `git diff --stat`, `git diff --name-only`) before updating docs
- Update `docs/ai/current_state.md` at end of each session
- Save session notes to `docs/ai/handoffs/YYYY-MM-DD.md` when useful
- If durable structure/canonical-source rules changed, update `docs/ai/project_memory.md`
- If change procedures or verification checklists evolved, update `docs/ai/change_playbook.md`
- Flush durable lessons into `docs/ai/agent_memory.md` and stable preferences into `docs/ai/user_preferences.md` when they exist
- Record major decisions in `docs/adr/`
