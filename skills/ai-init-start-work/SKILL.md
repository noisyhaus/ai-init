---
name: ai-init-start-work
description: Use when starting a new feature, UI change, bugfix, or release-prep task in an ai-init style project and you want Codex to handle the Git intake, dirty-worktree triage, and branch setup before handing off to the lane workflow.
---

# AI Init Start Work

Start work by fixing the Git context first, not by jumping into the lane skill.

This skill is a thin Git/workspace wrapper for ai-init projects.
It does not replace:

- `ai-init-feature-addition`
- `ai-init-bugfix`
- `ai-init-session-recovery`

It prepares the branch and workspace so those skills run in the right place.

## When to Use

Use this skill when:

- starting a new feature branch
- starting a UI-only branch
- starting a bugfix branch
- preparing a clean release-prep branch
- you do not want to manually run `git branch --show-current`, `git status --short`, `git checkout`, and branch creation every time

Do not use this skill when:

- you are only recovering context without deciding whether to continue or start new work
- you are only closing a session
- you need project bootstrap in a folder that is not a Git repo yet

For non-repo bootstrap, hand off to a future `ai-init-git-bootstrap` workflow or perform `git init -b main` first.

## Expected Input Shape

Preferred invocation pattern:

```text
$ai-init-start-work <lane> <branch-slug>
```

Examples:

```text
$ai-init-start-work feature export-csv
$ai-init-start-work ui table-polish
$ai-init-start-work fix license-dialog
$ai-init-start-work release v0.1.2
```

Interpretation:

- `<lane>` must be one of:
  - `feature`
  - `ui`
  - `fix`
  - `release`
- `<branch-slug>` becomes the branch suffix

Target branch names:

- `feature/<branch-slug>`
- `ui/<branch-slug>`
- `fix/<branch-slug>`
- `release/<branch-slug>`

If the user gives a freeform request instead of the preferred shape, infer the lane conservatively and announce the inferred branch name before creating it.

## Workflow

### 1. Inspect current Git state first

Run:

```bash
git branch --show-current
git status --short
git rev-parse --short HEAD
```

Record:

- current branch
- whether the worktree is clean or dirty
- current HEAD SHA

### 2. Decide whether this is "continue current lane" or "start new lane"

If the current branch already matches the requested lane and the work is clearly the same task, do not create a new branch automatically.

In that case:

1. say that the session appears to already be inside the target lane
2. recommend `ai-init-session-recovery`
3. stop unless the user explicitly wants a fresh branch anyway

If the current branch does not match the requested lane, continue.

### 3. Dirty-worktree triage

If `git status --short` is empty:

- continue to branch setup

If it is not empty:

- do not blindly checkout `main`
- explain that dirty residue exists
- classify the next move:
  - if the changes appear to belong to the same current lane, recommend continuing there instead of starting a new one
  - if the changes are unrelated or mixed, prefer isolation

Preferred isolation order:

1. create/use a clean worktree via `using-git-worktrees`
2. otherwise stop and tell the user the new lane should not start on top of unrelated dirty residue

Do not stash automatically.
Do not reset automatically.
Do not destroy in-progress work.

### 4. Prepare the clean base

Once the workspace is confirmed clean enough for a new lane:

```bash
git checkout main
git pull --ff-only
git checkout -b <target-branch>
git status --short
```

Requirements:

- `git pull` must use `--ff-only`
- if checkout to `main` fails because of local changes, stop and route back to dirty-worktree triage
- final `git status --short` should be clean

### 5. Read minimal project context

After the target branch exists, read:

1. `docs/ai/project_memory.md`
2. `docs/ai/change_playbook.md` if present
3. `docs/ai/current_state.md`

Do not run a full design or bugfix flow here.
Only gather enough context to hand off correctly.

### 6. Hand off to the correct lane

After branch setup:

- `feature` -> recommend or invoke `ai-init-feature-addition`
- `fix` -> recommend or invoke `ai-init-bugfix`
- `ui` -> start with a UI lane summary:
  - read `docs/features/ui-design-bible.md` if present
  - if missing, say substantial UI work should not proceed until the repo-local UI design bible is restored or defined
- `release` -> recommend using the release docs:
  - `docs/operations/windows-release.md`
  - `docs/operations/update-release.md` if present

## Output Style

Keep the output operational and short.

Use this section order:

1. Current Git state
2. Dirty-worktree decision
3. Branch action taken
4. Next owning lane
5. Next command or prompt

## Guardrails

- Never auto-stash.
- Never auto-reset.
- Never auto-merge into `main`.
- Never create a new lane branch on top of unrelated dirty residue.
- Never treat `session-recovery` as a replacement for Git intake.
- If `docs/features/ui-design-bible.md` is missing, do not silently proceed with substantial UI work as if the design contract exists.

## Minimal Examples

### Feature

Input:

```text
$ai-init-start-work feature export-csv
```

Expected action:

```bash
git branch --show-current
git status --short
git rev-parse --short HEAD
git checkout main
git pull --ff-only
git checkout -b feature/export-csv
git status --short
```

Then hand off to:

```text
$ai-init-feature-addition
```

### Bugfix

Input:

```text
$ai-init-start-work fix license-dialog
```

Expected action:

```bash
git branch --show-current
git status --short
git rev-parse --short HEAD
git checkout main
git pull --ff-only
git checkout -b fix/license-dialog
git status --short
```

Then hand off to:

```text
$ai-init-bugfix
```

### UI

Input:

```text
$ai-init-start-work ui table-polish
```

Expected action:

- same Git intake and branch setup pattern
- then check `docs/features/ui-design-bible.md`
- if missing, stop and say the UI design contract must be restored or defined before substantial UI work
