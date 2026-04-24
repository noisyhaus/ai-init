# ai-init

[Korean](README.ko.md)

`ai-init` is a markdown-first project memory system and Codex skill pack for reliable multi-session AI coding.

It gives coding agents a small, durable operating surface before they start changing code: project memory, change rules, current state, handoffs, specs, plans, and lifecycle skills that know when to recover context, start work, close a session, and finish a branch.

The goal is simple: stop treating chat history as the source of truth.

## How It Works

`ai-init` starts by creating a lightweight documentation scaffold inside the target project. The scaffold gives your coding agent a place to store durable context instead of rediscovering the same project facts every session.

From there, the skills provide a lifecycle:

1. Bootstrap the project with `ai-init`.
2. Recover context from markdown source-of-truth files before implementation.
3. Start work by checking Git state and choosing the right lane.
4. For feature work, write a spec and plan before code.
5. For bugfixes, reconnect context, reproduce, diagnose, fix, and verify.
6. Close sessions from real Git evidence, not memory.
7. Finish work by deciding what is safe to stage, commit, push, or merge.

The system is intentionally plain markdown. There is no database, hosted service, or private note-taking dependency in the public core.

## Installation

`ai-init` is currently source-distribution first.

Clone the repository:

```sh
git clone https://github.com/noisyhaus/ai-init.git
cd ai-init
```

Run the CLI from this checkout:

```sh
./bin/ai-init --help
```

Optionally put it on your `PATH`:

```sh
mkdir -p "$HOME/.local/bin"
ln -sf "$PWD/bin/ai-init" "$HOME/.local/bin/ai-init"
```

Install the Codex skills manually:

```sh
mkdir -p "$HOME/.codex/skills"
cp -R skills/ai-init* "$HOME/.codex/skills/"
```

See [docs/install.md](docs/install.md) for details.

## Basic Usage

Run from the project you want to initialize:

```sh
ai-init
```

For a new project:

```sh
ai-init --new-project
```

For an existing project:

```sh
ai-init --existing-project
```

Optional scaffolds:

```sh
ai-init --with-rules
ai-init --with-memory-plus
ai-init --with-local-recall
```

To print only the follow-up prompt:

```sh
ai-init --print-prompt
```

## What It Creates

The core scaffold centers on three markdown source-of-truth files:

- `docs/ai/project_memory.md` - durable project identity, architecture notes, canonical sources, and invariants.
- `docs/ai/change_playbook.md` - project-specific change rules, verification expectations, and working conventions.
- `docs/ai/current_state.md` - current objective, verified state, risks, next actions, and handoff status.

It also creates:

- `AGENTS.md`
- `README.md`
- `docs/ai/handoffs/`
- `docs/ai/tasks/`
- `docs/adr/`
- `docs/superpowers/specs/`
- `docs/superpowers/plans/`

Optional scaffolds can add:

- `docs/ai/rules/`
- `docs/ai/agent_memory.md`
- `docs/ai/user_preferences.md`
- `.ai-index/`
- `scripts/ai-index.py`

## The Basic Workflow

`ai-init` - Bootstraps the target project and prints the next prompt for Codex. It is the explicit command surface for creating starter docs instead of leaving the agent to interpret "ai-init" as plain text.

`ai-init-session-recovery` - Runs at the start of a new chat or resumed task. It reads project memory, change rules, current state, optional memory files, and relevant handoffs/specs/plans before implementation.

`ai-init-start-work` - Prepares the Git lane before a feature, UI change, bugfix, or release-prep task. It checks branch/worktree state and prevents new work from starting on an unclear base.

`ai-init-feature-addition` - Activates for new feature work. It reconnects the request to project docs, writes an invariant impact note, scopes the change, and produces spec/plan artifacts before coding.

`ai-init-bugfix` - Activates for bugfixes and regressions. It recovers context first, reproduces the issue when possible, identifies root cause, applies the smallest fix, and verifies the result.

`ai-init-pressure-test` - Produces a review prompt for another AI to challenge hidden assumptions, weak handoffs, unclear scope, and missing constraints before the next step.

`ai-init-session-close` - Ends a session from evidence. It checks Git status/diffs, separates in-scope work from pre-existing dirt or generated noise, updates current state and handoff docs, and reports remaining risk.

`ai-init-finish-work` - Wraps a completed lane. It runs session close first, then uses the resulting evidence to decide what can be staged, committed, pushed, or prepared for merge.

See [docs/skill-contracts.md](docs/skill-contracts.md) for the detailed contract of each skill.

## What's Inside

### CLI

- `bin/ai-init` - idempotent scaffold generator for project docs and planning folders.
- `prompts/` - follow-up prompts for new projects, existing projects, feature addition, session recovery, and session close.
- `templates/` - generated files written into downstream projects.

### Skills

- `skills/ai-init/`
- `skills/ai-init-session-recovery/`
- `skills/ai-init-start-work/`
- `skills/ai-init-feature-addition/`
- `skills/ai-init-bugfix/`
- `skills/ai-init-pressure-test/`
- `skills/ai-init-session-close/`
- `skills/ai-init-finish-work/`

### Docs

- [docs/install.md](docs/install.md)
- [docs/skill-contracts.md](docs/skill-contracts.md)
- [docs/superpowers-compatibility.md](docs/superpowers-compatibility.md)

## Superpowers Compatibility

Superpowers is not required.

`ai-init-feature-addition` uses a markdown-compatible spec/plan layout:

- `docs/superpowers/specs/`
- `docs/superpowers/plans/`

If a project already uses Superpowers, `ai-init` can share the same document layout. If not, the workflow still works with plain markdown files. Superpowers-specific behavior should remain an optional adapter, not a hard dependency in the public core.

## Philosophy

- Markdown is the source of truth.
- Recovery before implementation.
- Specs and plans before feature code.
- Evidence before completion claims.
- Git evidence before session close.
- Small, reversible changes over broad rewrites.
- Optional integrations should not become hidden requirements.

## Maintainer Workflow

Run verification before publishing changes:

```sh
./tests/ai-init-output-test.sh
git diff --check
rg -n "\p{Hangul}" . -g '!README.ko.md'
rg -n -i "o[b]sidian|w[i]ki|with-w[i]ki|w[i]ki-sync|w[i]ki-hook" .
```

Release tags should use semantic versioning:

```sh
git tag v0.1.0
git push origin v0.1.0
```

Suggested release note sections:

- Added
- Changed
- Fixed
- Migration

## Repository Dogfooding

This repository uses `ai-init` to manage its own development context.

- Root `AGENTS.md` and `docs/ai/*` describe how to work on `ai-init` itself.
- `templates/*` are the files generated into downstream user projects.
- `skills/*` are the distributable skill sources.
- Installed local copies under `~/.codex/skills` are runtime copies, not release source of truth.

Do not run `ai-init --force` in this repository root. Test scaffold behavior in a temporary directory or fixture project.

## Status

Early public packaging work. The current repository contains the local working implementation and Codex skills intended for source-first distribution.

## License

MIT License. See [LICENSE](LICENSE).
