---
name: ai-init-start-work
description: Use when the user says "ai-init-start-work" or wants the ai-init start-work lane directly before feature, bugfix, or release-prep implementation.
---

# AI Init Start Work

Use this skill when the user explicitly invokes `$ai-init-start-work` or asks for the ai-init start-work lane directly.

This public skill is a thin wrapper over the shared ai-init lifecycle reference. It exists so the installed package can expose both a general entrypoint (`$ai-init`) and direct lifecycle commands.

## When to use

Use this skill when the user:
- types `ai-init-start-work`
- asks to inspect Git state before starting implementation
- wants the ai-init start-work lane directly

## Workflow

Follow:

- `../ai-init/references/start-work.md`

If project context is stale or unknown, recover first with:

- `../ai-init/references/session-recovery.md`
