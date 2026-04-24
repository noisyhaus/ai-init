---
name: ai-init-session-close
description: Use when the user says "ai-init-session-close" or wants the ai-init session-close lane directly to checkpoint work from Git evidence.
---

# AI Init Session Close

Use this skill when the user explicitly invokes `$ai-init-session-close` or asks for the ai-init session-close lane directly.

This public skill is a thin wrapper over the shared ai-init lifecycle reference. It exists so the installed package can expose both a general entrypoint (`$ai-init`) and direct lifecycle commands.

## When to use

Use this skill when the user:
- types `ai-init-session-close`
- wants a Git-evidence-based session checkpoint
- wants current-state and handoff updates before leaving the branch

## Workflow

Follow:

- `../ai-init/references/session-close.md`
