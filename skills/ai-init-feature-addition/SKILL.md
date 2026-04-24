---
name: ai-init-feature-addition
description: Use when the user says "ai-init-feature-addition" or wants the ai-init feature-addition lane directly for spec-first, plan-first feature work.
---

# AI Init Feature Addition

Use this skill when the user explicitly invokes `$ai-init-feature-addition` or asks for the ai-init feature-addition lane directly.

This public skill is a thin wrapper over the shared ai-init lifecycle reference. It exists so the installed package can expose both a general entrypoint (`$ai-init`) and direct lifecycle commands.

## When to use

Use this skill when the user:
- types `ai-init-feature-addition`
- asks to add a new feature or UI lane under ai-init
- wants spec and plan artifacts before implementation

## Workflow

Follow:

- `../ai-init/references/feature-addition.md`

If project context is stale or missing, recover first with:

- `../ai-init/references/session-recovery.md`
