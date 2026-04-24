---
name: ai-init
description: Use when the user says "ai-init", asks to bootstrap a project, recover ai-init project context, start feature or bugfix work, pressure-test a plan, close a session, or finish a branch using the ai-init lifecycle.
---

# AI Init

Use this skill as the single public Codex entrypoint for the `ai-init` project lifecycle.

The first problem this skill solves: when a user types `ai-init` in chat, Codex may treat it as a natural-language prompt instead of executing the local bootstrap command. This skill removes that ambiguity.

The broader purpose: keep multi-session AI coding grounded in durable markdown context instead of chat history. This single skill owns bootstrap, context recovery, work intake, feature planning, bugfix discipline, pressure testing, session close, and branch finish workflows.

## When to use

Use this skill when the user:
- types `ai-init`
- asks to bootstrap or initialize a project/workspace
- wants starter docs created with the local `ai-init` command
- wants the follow-up prompt that `ai-init` prints
- wants `ai-init --print-prompt`, `--with-rules`, `--with-memory-plus`, or `--with-local-recall`
- asks to recover context in an ai-init project
- starts feature, UI, bugfix, or release-prep work
- asks for feature planning, bugfix flow, pressure testing, session close, or finish-work handling

Do not split public behavior across sibling `ai-init-*` skills. Lifecycle workflows live as references inside this skill.

## Route the request

Choose the smallest matching workflow:

- Bootstrap or initialize docs -> follow **Bootstrap Command** below and `references/usage.md`.
- Recover context at the start of a new chat or resumed task -> read `references/session-recovery.md`.
- Start a new feature/UI/fix/release lane -> read `references/start-work.md`.
- Add a feature -> read `references/feature-addition.md`.
- Fix a bug or regression -> read `references/bugfix.md`.
- Pressure-test a stage with another AI -> read `references/pressure-test.md`.
- Close the current session -> read `references/session-close.md`.
- Finish a lane for commit/push/merge readiness -> read `references/finish-work.md`.

Treat lifecycle names as routes inside this `ai-init` skill, not as separate installable skills.

## Bootstrap Command

Prefer the bundled helper script:

```bash
~/.codex/skills/ai-init/scripts/run-ai-init.sh [args...]
```

This helper resolves the executable in this order:
1. `$AI_INIT_BIN` if set
2. `~/.local/bin/ai-init`
3. `ai-init` from `PATH`

## Bootstrap Workflow

1. Confirm the target working directory.
2. Run the helper script with any user-requested flags.
   - default: no flags
   - prompt only: `--print-prompt`
   - stronger scaffold: `--with-rules`, `--with-memory-plus`, `--with-local-recall`
3. Read the output instead of paraphrasing from memory.
4. Verify that expected files/directories now exist when the command was not `--print-prompt` only.
5. Report:
   - command executed
   - files/directories created or skipped
   - printed follow-up prompt
   - any verification result
6. If scaffolding succeeded, recommend the next prompt exactly as emitted by `ai-init`.

## Bootstrap Verification

After a normal scaffold run, verify at least these paths:
- `AGENTS.md`
- `README.md`
- `docs/ai/project_memory.md`
- `docs/ai/change_playbook.md`
- `docs/ai/current_state.md`
- `docs/ai/handoffs/`
- `docs/ai/tasks/`
- `docs/adr/`
- `docs/superpowers/specs/`
- `docs/superpowers/plans/`

If the command used `--print-prompt`, verify only that the command exited successfully and returned prompt text.

## Output style

Keep the answer compact and concrete:
- what command ran
- what happened
- verification evidence
- the next prompt to paste

## References

Use only the reference needed for the current route:

- `references/usage.md`
- `references/session-recovery.md`
- `references/start-work.md`
- `references/feature-addition.md`
- `references/bugfix.md`
- `references/pressure-test.md`
- `references/session-close.md`
- `references/finish-work.md`
