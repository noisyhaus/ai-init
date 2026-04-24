---
name: ai-init
description: Use when the user says "ai-init", asks to bootstrap a project, initialize starter docs, or wants Codex to run the local ai-init scaffold command instead of interpreting it as plain chat text.
---

# AI Init

Use this skill to make `ai-init` explicit inside Codex.

The problem this skill solves: when a user types `ai-init` in chat, Codex may treat it as a natural-language prompt instead of executing the local bootstrap command. This skill removes that ambiguity.

## When to use

Use this skill when the user:
- types `ai-init`
- asks to bootstrap or initialize a project/workspace
- wants starter docs created with the local `ai-init` command
- wants the follow-up prompt that `ai-init` prints
- wants `ai-init --print-prompt`, `--with-rules`, `--with-memory-plus`, or `--with-local-recall`

Do not use this skill for product planning, feature design, or implementation work after bootstrapping. After the scaffold is created, hand off to the normal project workflow.

## Command to run

Prefer the bundled helper script:

```bash
~/.codex/skills/ai-init/scripts/run-ai-init.sh [args...]
```

This helper resolves the executable in this order:
1. `$AI_INIT_BIN` if set
2. `~/.local/bin/ai-init`
3. `ai-init` from `PATH`

## Workflow

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

## Verification

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

## Reference

If you need option details or expected outputs, read `references/usage.md`.
