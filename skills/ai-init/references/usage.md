# ai-init skill reference

Primary executable:
- `~/.local/bin/ai-init`

Common commands:
- `run-ai-init.sh`
- `run-ai-init.sh --print-prompt`
- `run-ai-init.sh --with-rules`
- `run-ai-init.sh --with-memory-plus`
- `run-ai-init.sh --with-local-recall`
- `run-ai-init.sh --existing-project`
- `run-ai-init.sh --new-project`

Expected default scaffold:
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

Recommended handoff behavior:
- quote the emitted follow-up prompt exactly when useful
- distinguish actual command output from your own interpretation
- if the scaffold already exists, report skip lines rather than pretending files were rewritten
