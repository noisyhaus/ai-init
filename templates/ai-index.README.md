# Local Recall Cache

This directory stores the local SQLite FTS cache for `__PROJECT_NAME__`.

## Purpose
- Speed up session recovery across accumulated docs
- Narrow relevant handoffs, specs, plans, and ADRs before reading them
- Keep markdown as the source of truth

## Important Rules
- This cache is disposable and rebuildable
- Do not treat the database as canonical project state
- If docs and cache disagree, trust the markdown docs

## Commands
```bash
python scripts/ai-index.py rebuild
python scripts/ai-index.py search "Current objective"
python scripts/ai-index.py update
```

## Indexed Docs
- `docs/START_HERE.md`
- `docs/ai/project_memory.md`
- `docs/ai/change_playbook.md`
- `docs/ai/current_state.md`
- `docs/ai/agent_memory.md`
- `docs/ai/user_preferences.md`
- `docs/ai/handoffs/*.md`
- `docs/superpowers/specs/*.md`
- `docs/superpowers/plans/*.md`
- `docs/adr/*.md`
