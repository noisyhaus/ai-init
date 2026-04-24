---
name: ai-init-finish-work
description: Use when the user says "ai-init-finish-work" or wants the ai-init finish-work lane directly for stage, commit, push, or merge readiness.
---

# AI Init Finish Work

Use this skill when the user explicitly invokes `$ai-init-finish-work` or asks for the ai-init finish-work lane directly.

This public skill is a thin wrapper over the shared ai-init lifecycle reference. It exists so the installed package can expose both a general entrypoint (`$ai-init`) and direct lifecycle commands.

## When to use

Use this skill when the user:
- types `ai-init-finish-work`
- wants the end-of-lane packaging step directly
- wants stage, commit, push, or merge readiness checked from evidence

## Workflow

Follow:

- `../ai-init/references/finish-work.md`
- `../ai-init/references/session-close.md`
