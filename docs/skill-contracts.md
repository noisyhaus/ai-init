# Skill Contract

This document describes the public `ai-init` Codex skill set and the shared lifecycle contracts it exposes.

## Core Lifecycle

### `ai-init`: bootstrap

Runs the scaffold generator and verifies created files.

Use it when the user asks to initialize a project, bootstrap starter docs, print the follow-up prompt, or run flags such as `--with-rules`, `--with-memory-plus`, or `--with-local-recall`.

Contract:

- Execute the installed local `ai-init` command through the bundled helper script when the user invokes `$ai-init` in Codex.
- Read command output instead of paraphrasing from memory.
- Verify expected files/directories after normal scaffold runs.
- Recommend the exact next prompt emitted by the command.

### `ai-init` or `ai-init-session-recovery`: session recovery

Restores working context before implementation.

Use it when resuming work in a new chat, recovering after context loss, or asking for the current objective, risks, and next steps.

Contract:

- Read `docs/ai/project_memory.md`.
- Read `docs/ai/change_playbook.md` when present.
- Read `docs/ai/current_state.md`.
- Read optional durable memory files when present.
- Inspect the live workspace narrowly enough to confirm reality.
- Separate doc-confirmed facts from live-workspace facts.
- Stop after recovery unless the user asks to continue.

### `ai-init` or `ai-init-start-work`: start work

Prepares a safe Git lane before feature, UI, bugfix, or release-prep work.

Contract:

- Inspect the current branch and dirty worktree.
- Classify pre-existing changes before starting new work.
- Create or switch branches only when safe.
- Hand off to the appropriate lane workflow after Git context is clear.

### `ai-init` or `ai-init-feature-addition`: feature addition

Creates a spec-first and plan-first path for new feature work.

Contract:

- Reconnect the request to project docs and relevant specs/plans.
- Write an `Invariant Impact` note covering SSoT, SRP, Consistency, Atomicity, Idempotency, and No Silent Fallback.
- Clarify goal, scope, non-scope, success criteria, constraints, and risks.
- Save a design artifact under `docs/superpowers/specs/`.
- Save an implementation plan under `docs/superpowers/plans/`.
- Propose the first execution task without jumping straight to code.

### `ai-init` or `ai-init-session-close`: session close

Closes a work session from Git evidence.

Contract:

- Run `git status --short`, `git diff --stat`, and `git diff --name-only`.
- Classify current-lane work, pre-existing dirt, generated/runtime/cache noise, and external-path changes.
- Read actual diffs only for in-scope files.
- Update `docs/ai/current_state.md` and handoff docs when warranted.
- Flush only durable lessons/preferences into optional memory files.
- Report recommended staging scope, draft commit title, risks, recovery prompt, and core files for the next session.

### `ai-init` or `ai-init-finish-work`: finish work

Wraps a completed lane by running session close first and then preparing Git decisions.

Contract:

- Use session-close output as the decision point.
- Decide what is safe to stage.
- Prepare commit/push/merge guidance from evidence.
- Do not commit or push unless the user explicitly requests it.

## Optional Lanes

### `ai-init` or `ai-init-bugfix`: bugfix

Runs the bugfix lane for existing broken behavior.

Contract:

- Recover context first.
- Reproduce or define a concrete failure signal.
- Identify root cause before editing.
- Make the smallest fix.
- Run a regression check.
- Keep unrelated cleanup out of scope.

## Optional Extensions

The sibling lifecycle skills are thin wrappers over `skills/ai-init/references/`. Shared references are the source of truth for lifecycle behavior.

Local recall is a cache only. Markdown docs remain the source of truth.

Private note-taking integrations are outside the public core workflow.
