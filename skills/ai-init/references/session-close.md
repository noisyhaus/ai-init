
# AI Init Session Close

Close the session with evidence first, memory second.

## Workflow

1. Check git evidence first.
   - `git status --short`
   - `git diff --stat`
   - `git diff --name-only`
   - If useful: `git diff --cached --stat` and `git diff --cached --name-only`
2. If git is unavailable, say so explicitly and treat all classification as best-effort.
3. Classify changes into:
   - current session lane
   - pre-existing dirty worktree
   - generated/runtime/cache noise
   - sibling or external-path changes
4. Read actual diff content only for the current session lane.
5. Update, in this order, only when warranted:
   - `docs/ai/current_state.md`
   - `docs/ai/handoffs/YYYY-MM-DD.md`
   - `docs/ai/agent_memory.md` if present and durable lessons exist
   - `docs/ai/user_preferences.md` if present and stable preferences surfaced
   - `docs/ai/project_memory.md` only if structure/canonical sources/impact rules changed
   - `docs/ai/change_playbook.md` only if procedures or verification checklists changed
6. Keep unfinished or unverified work clearly marked as such.
7. Do not auto-commit or auto-push.

If `.ai-index/` exists, note whether it should be updated before the next session.

## Required Summary Block

End with one `Session Close Summary` block containing:
1. Recommended staging scope
2. Draft commit title
3. Risks of committing now
4. Short recovery prompt to paste into the next chat
5. Three core files to read next
