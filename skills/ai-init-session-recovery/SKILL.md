---
name: ai-init-session-recovery
description: Use when the user says "ai-init-session-recovery" or wants the ai-init recovery lane directly to rebuild project context from markdown and workspace evidence.
---

# AI Init Session Recovery

Use this skill when the user explicitly invokes `$ai-init-session-recovery` or asks for the ai-init recovery lane directly.

This public skill is a thin wrapper over the shared ai-init lifecycle reference. It exists so the installed package can expose both a general entrypoint (`$ai-init`) and direct lifecycle commands.

## When to use

Use this skill when the user:
- types `ai-init-session-recovery`
- resumes work in a new chat
- wants current objective, confirmed state, risks, and next steps rebuilt from project docs

## Workflow

Follow:

- `../ai-init/references/session-recovery.md`
