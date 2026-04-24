
# AI Init Finish Work

Finish work by closing the session with evidence first, then deciding commit/push/merge.

This skill is a thin end-of-lane wrapper for ai-init projects.
It does not replace:

- `session close workflow`
- `git-work-commit`

It uses the session-close output as the decision point for what should happen next.

## When to Use

Use this skill when:

- you believe the current lane is ready to wrap up
- you want Codex to gather Git evidence, update `docs/ai/*` state, and then decide whether commit/push is safe
- you want help deciding whether the branch is ready for merge into `main`
- you do not want to manually run `git status`, `git diff`, and commit commands every time

Do not use this skill when:

- you are still actively implementing
- you have not yet verified the current lane
- you only want context recovery
- the repo is not a Git repository yet

## Expected Outcome

By the end of this skill, Codex should reach one of these states:

1. **stop before commit**
   - because the session-close summary shows unresolved risk
2. **local commit only**
   - because push or merge is unsafe or unavailable
3. **commit + push**
   - because the branch is cleanly publishable
4. **commit + push + conditional merge**
   - only when project policy explicitly allows it and the merge gate is passed

## Workflow

### 1. Capture current Git state

Run:

```bash
git branch --show-current
git status --short
git rev-parse --short HEAD
git remote -v
```

Record:

- current branch
- whether the worktree is clean or dirty
- current HEAD SHA
- whether `origin` exists

### 2. Run `session close workflow` first

Do not skip session close.

Use it to produce:

- current session lane classification
- recommended staging scope
- recommended commit title draft
- risks of committing now
- next recovery prompt

Do not commit before this summary exists.

### 3. Read the `Session Close Summary` block and classify the finish state

Interpret the summary conservatively.

If `Risks of committing now` is non-empty in a way that blocks safe publication, stop before commit.

Classify the branch into one of:

- docs-only or low-risk
- normal code change
- high-risk or release-sensitive

High-risk examples:

- packaging/build files
- runtime config/path files
- DB schema or persistence shape changes
- Selenium/automation changes
- UI changes still missing required visual validation

### 4. Stage only the recommended scope

Never default to broad `git add .`.

Use the recommended staging scope from session close first.

Before committing, verify:

```bash
git diff --cached --stat
git diff --cached
```

If the staged scope contains unrelated work, unstage and fix the scope before continuing.

### 5. Commit using repo rules

Commit only if:

- staged scope is intentional
- session-close risk is acceptable
- verification evidence for the lane already exists

Use repository commit rules first.

If the repo requires a structured format such as Lore trailers, follow it.

### 6. Decide whether push is safe

Push by default only when all are true:

- `origin` exists
- current branch is not `main` / `master`
- the commit scope is intentional
- no unresolved publication risk remains

If any are false, stop at local commit and report why.

Recommended push commands:

```bash
git push
```

or, if the branch has no upstream yet:

```bash
git push -u origin <current-branch>
```

### 7. Decide whether merge into `main` is allowed

Do not auto-merge by default just because commit + push succeeded.

Only merge when project policy explicitly allows it and the merge gate is passed.

Default merge gate:

- current branch is not `main`
- worktree is clean after commit
- lane purpose is single-scope
- verification for the touched area is complete
- `Risks of committing now` is effectively empty for merge purposes

Automatic merge should remain **more strict** than automatic push.

#### Default allowed merge cases

- docs-only changes
- very narrow low-risk changes with clear verification

#### Default blocked merge cases

- Windows-sensitive changes not yet validated on Windows
- packaging/build/runtime path changes
- DB or persistence changes
- Selenium/automation changes
- UI changes missing required visual verification
- mixed-purpose branches

If merge is allowed:

```bash
git checkout main
git pull --ff-only
git merge --no-ff <finished-branch>
git push origin main
```

If merge is blocked, say so explicitly and stop at commit + push.

## Output Style

Keep the output operational and short.

Use this section order:

1. Current Git state
2. Session-close conclusion
3. Commit decision
4. Push decision
5. Merge decision
6. Next command or next blocker

## Guardrails

- Never skip `session close workflow`.
- Never auto-stash.
- Never auto-reset.
- Never commit broad unrelated scope by default.
- Never push `main` / `master` unless merge/publication intent is explicit and safe.
- Never auto-merge high-risk or Windows-sensitive changes without the required validation.
- Never treat "tests passed on macOS" as enough for Windows-sensitive merge decisions.

## Minimal Examples

### Docs-only branch

Input:

```text
$finish work workflow
```

Expected outcome:

- run `session close workflow`
- stage only the recommended docs scope
- commit
- push current branch
- if project policy allows and the work is docs-only, merge into `main`

### Code branch with Windows-sensitive changes

Input:

```text
$finish work workflow
```

Expected outcome:

- run `session close workflow`
- stage only the recommended code scope
- commit
- push current branch
- stop before merge and explicitly list the missing Windows validation
