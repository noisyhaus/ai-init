---
name: ai-init-bugfix
description: Use when the user says "ai-init-bugfix" or wants the ai-init bugfix lane directly for reproduce-diagnose-fix-verify work.
---

# AI Init Bugfix

Use this skill when the user explicitly invokes `$ai-init-bugfix` or asks for the ai-init bugfix lane directly.

This public skill is a thin wrapper over the shared ai-init lifecycle reference. It exists so the installed package can expose both a general entrypoint (`$ai-init`) and direct lifecycle commands.

## When to use

Use this skill when the user:
- types `ai-init-bugfix`
- asks to run the ai-init bugfix lane directly
- wants reproduce -> diagnose -> fix -> verify discipline

## Workflow

Follow:

- `../ai-init/references/bugfix.md`

If project context is stale or missing, recover first with:

- `../ai-init/references/session-recovery.md`
