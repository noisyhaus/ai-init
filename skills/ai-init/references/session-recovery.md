
# AI Init Session Recovery

Recover context before implementation.

## Read Order

Always read these in order:
1. `docs/ai/project_memory.md`
2. `docs/ai/change_playbook.md` if present
3. `docs/ai/current_state.md`
4. `docs/ai/agent_memory.md` if present
5. `docs/ai/user_preferences.md` if present
6. Most recent relevant handoff/spec/plan only if needed

If `.ai-index/` exists, use it only to narrow which handoff/spec/plan files matter. The markdown docs remain the source of truth and must still be read directly.

## Workflow

1. Recover the current objective, next actions, open risks, and 2-3 feature keywords from docs.
2. Inspect the live workspace narrowly enough to confirm what still matches reality.
3. Separate doc-confirmed facts from live-workspace facts.
4. Mark every inference as inference. Do not silently upgrade guesses into facts.
5. Stop after recovery. Do not implement yet unless the user asks to continue beyond recovery.

Prioritize structure, canonical sources, and change-impact rules from `project_memory.md`, plus only the directly relevant checklist items from `change_playbook.md`.

## Required Output

Use exactly this section order:
1. Current objective
2. Confirmed from docs
3. Confirmed from live workspace
4. Unknown or risky points
5. Next smallest steps
6. Verification plan
