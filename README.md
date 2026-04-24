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

Install the Codex skill manually:

```sh
mkdir -p "$HOME/.codex/skills"
cp -R skills/ai-init "$HOME/.codex/skills/"
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

First-time user flow:

```text
+----------------------------+
| 1. Clone noisyhaus/ai-init |
+-------------+--------------+
              |
              v
+----------------------------+
| 2. Install CLI + one skill |
|    skills/ai-init          |
+-------------+--------------+
              |
              v
+----------------------------+
| 3. cd target project       |
|    run: ai-init            |
+-------------+--------------+
              |
              v
+----------------------------+
| 4. Paste printed prompt    |
|    into Codex              |
+-------------+--------------+
              |
              v
+----------------------------+
| 5. Codex reads markdown    |
|    source-of-truth files   |
+-------------+--------------+
              |
              v
+----------------------------+
| 6. Start work with the     |
|    ai-init lifecycle       |
+----------------------------+
```

The installed Codex surface is one skill: `ai-init`.

Inside that skill, route to the matching lifecycle workflow:

- `bootstrap` - create starter docs and print the next Codex prompt.
- `session recovery` - recover context before implementation.
- `start work` - inspect Git state and prepare the right lane.
- `feature addition` - write spec and plan artifacts before coding.
- `bugfix` - reproduce, diagnose, fix, and verify a regression.
- `pressure test` - generate a cross-agent review prompt.
- `session close` - close a session from Git evidence.
- `finish work` - decide what is safe to stage, commit, push, or merge.

See [docs/skill-contracts.md](docs/skill-contracts.md) for the detailed lifecycle contracts.

## What's Inside

### CLI

- `bin/ai-init` - idempotent scaffold generator for project docs and planning folders.
- `prompts/` - follow-up prompts for new projects, existing projects, feature addition, session recovery, and session close.
- `templates/` - generated files written into downstream projects.

### Skills

- `skills/ai-init/` - the single public Codex skill.
- `skills/ai-init/references/` - lifecycle workflow references used by the skill.

### Docs

- [docs/install.md](docs/install.md)
- [docs/skill-contracts.md](docs/skill-contracts.md)
- [docs/superpowers-compatibility.md](docs/superpowers-compatibility.md)
- [USAGE.md](USAGE.md)

## Superpowers Compatibility

Superpowers is not required.

The feature-addition lifecycle uses a markdown-compatible spec/plan layout:

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

## Repository Boundaries

This repository contains the public source needed to install, inspect, test, and release `ai-init`.

- `templates/*` are the files generated into downstream user projects.
- `skills/ai-init/` is the distributable skill source.
- Root `AGENTS.md`, `docs/ai/*`, and `docs/superpowers/specs|plans/*` are local development state for this repository and are intentionally ignored.
- Installed local copies under `~/.codex/skills` are runtime copies, not release source of truth.

Do not run `ai-init --force` in this repository root. Test scaffold behavior in a temporary directory or fixture project.

## Status

Early public packaging work. The current repository contains the local working implementation and Codex skills intended for source-first distribution.

## License

MIT License. See [LICENSE](LICENSE).
