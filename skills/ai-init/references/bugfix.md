
# AI Init Bugfix

Use this skill for the bugfix lane in an ai-init project.

This skill is an orchestrator. Reuse matching local skills for recovery, debugging, TDD, and verification when they are installed; otherwise follow the built-in discipline below.

## Required Background / Optional Helpers

Read and follow `session recovery workflow` as the context recovery surface.

- `session recovery workflow`

The following helper skills are optional. Use them when available, but do not require them for public portability:

- `systematic-debugging`
- `test-driven-development`
- `verification-before-completion`
- `brainstorming`

Use brainstorming-style clarification only through the escalation rule below.

## When to Use

Use this skill when:

- the expected behavior already exists in docs, tests, or stable shipped behavior
- the issue is a regression, broken flow, defect, or integration failure
- the goal is to restore an existing contract, not define a new one

Do not use this skill when:

- the work defines new expected behavior
- the request intentionally changes user-visible behavior
- the issue is clearly a feature addition rather than a contract restore

For those cases, use `feature addition workflow` instead.

## Contract Priority

When deciding whether something is a bugfix, use this contract precedence:

1. source-of-truth ai-init docs
2. regression tests
3. confirmed shipped behavior
4. operator recollection

If the highest-trust sources conflict, classify the case as an expectation gap instead of a plain bugfix.

## Workflow

### 1. Recovery

Reconnect project context by reading, in order:

1. `docs/ai/project_memory.md`
2. `docs/ai/change_playbook.md` if present
3. `docs/ai/current_state.md`
4. latest relevant file under `docs/ai/handoffs/`
5. relevant spec/plan only if needed

Recovery output must separate:

- doc-confirmed facts
- live-workspace facts
- unknown or risky points

If recovery cannot identify a trustworthy contract source, stop before fix work and classify the case as an expectation gap.

### 2. Triage

Classify the issue as one of:

- true bug
- expectation gap
- feature-in-disguise
- environment issue

Dispatch by classification:

- true bug -> continue in bugfix flow
- expectation gap -> if an existing contract can be named without new design, continue in bugfix flow; otherwise escalate through the brainstorming rule
- feature-in-disguise -> hand off to `feature addition workflow` immediately
- environment issue -> document the blocker, recommend environment remediation, and re-triage only after the environment is stable

Use fast-path only when all are true:

- expected behavior is already clear
- a failing symptom and bounded repro path are already captured
- fix scope and change-impact surfaces stay within one tight module boundary
- the change restores an existing contract without redefining behavior

Fast-path never skips recovery or verification.

### 3. Fix

Use the local `systematic-debugging` skill if available. Otherwise use this default fixing discipline:

- reproduce first
- identify root cause before proposing a fix
- keep the fix minimal and lane-scoped

Use the local `test-driven-development` skill if available. Otherwise add or update automated regression coverage when feasible.

Automation is feasible when:

- a deterministic test, script, or harness can cover the regression
- it runs in the existing verification environment without disproportionate setup
- the effort remains reasonable relative to the fix scope

If automation is not practical, require the strongest fallback available:

1. executable repro script
2. deterministic diagnostic harness
3. minimal manual repro checklist

Record why automated coverage was not feasible.

If the fix grows beyond the triaged boundary, stop and re-triage before continuing.

### 4. Verify

Use the local `verification-before-completion` skill if available. Otherwise verify with the checklist below.

Verification is complete only when all are true:

- the original symptom no longer reproduces on the same path
- relevant regression checks pass with no new unexplained failures
- change-impact surfaces for touched files have been checked
- any unverified surface is explicitly listed with the reason it was not verified

## Brainstorming Escalation Rule

Brainstorming-style clarification is not part of the default bugfix path.

Escalate only when:

- expected behavior is unclear or contradictory
- the fix requires deliberate behavior change
- trusted sources describe conflicting contracts
- repeated failed hypotheses indicate the issue is not a local defect

Do not escalate only because multiple layers are involved.

If clarification preserves the same existing contract, return to bugfix and continue from Fix.

If the work becomes new behavior design, hand off to `feature addition workflow`.

## Lane Hand-Off Protocol

When switching from bugfix lane to feature lane, or invoking brainstorming for clarification, record:

1. original symptom
2. triage classification
3. contract status: clear, conflicting, or missing
4. any partial hypothesis or partial fix already attempted
5. the next owning skill

If a feature session discovers a separate bug, do not silently inline a bugfix into the feature flow. Open a separate bugfix session or record the defect explicitly as out-of-scope.

## Session Scope Rule

One bugfix session addresses one bug.

If multiple bugs are reported together, triage them separately and do not batch unrelated fixes into one bugfix flow.

## Output Style

Keep bugfix output compact and operational:

1. Current objective
2. Confirmed from docs
3. Confirmed from live workspace
4. Reproduction and evidence
5. Triage result
6. Root cause or blocker
7. Fix plan or hand-off decision
8. Verification plan

## Anti-Patterns

- duplicating recovery logic across feature and bugfix skills
- turning `bugfix workflow` into a skill that inlines full debugging, TDD, and verification manuals
- sending every bug through brainstorming
- silently switching lanes mid-session
- skipping context reconnect because the bug looks small
- claiming a fix without replaying the original symptom path
