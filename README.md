# ai-init

[Korean](README.ko.md)

`ai-init` is a markdown-first bootstrap system for Codex projects.

It packages three things together:

- one installable Codex skill: `ai-init`
- one local scaffold command: `ai-init`
- one durable project-memory layout for multi-session AI coding

The goal is simple: stop treating chat history as the source of truth.

## Quick Start

```sh
git clone https://github.com/noisyhaus/ai-init.git
cd ai-init
./install.sh
```

Then open Codex in the project you want to initialize and run:

```text
$ai-init
```

## How It Works

`ai-init` starts by creating a lightweight documentation scaffold inside the target project. That scaffold gives your coding agent a durable working surface instead of forcing it to rediscover the same project facts every session.

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

Install the public package from this checkout:

```sh
./install.sh
```

This creates two local install links:

- `~/.codex/skills/ai-init` -> `<repo>/skills/ai-init`
- `~/.local/bin/ai-init` -> `<repo>/bin/ai-init`

See [docs/install.md](docs/install.md) for details.

## Basic Usage

Start Codex in the project you want to initialize, then use the skill entrypoint:

```text
$ai-init
```

The installed skill calls the local `ai-init` command for you. The skill is the Codex entrypoint; the command is the fixed scaffold generator.

You can still run the CLI directly when needed:

```sh
ai-init
```

For a new project:

```sh
ai-init --new-project
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
| 2. Run: ./install.sh       |
+-------------+--------------+
              |
              v
+----------------------------+
| 3. cd target project       |
|    start Codex             |
+-------------+--------------+
              |
              v
+----------------------------+
| 4. Type: $ai-init          |
+-------------+--------------+
              |
              v
+----------------------------+
| 5. Skill runs local        |
|    ai-init scaffold        |
+-------------+--------------+
              |
              v
+----------------------------+
| 6. Codex follows printed   |
|    prompt + lifecycle      |
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
- `install.sh` - installs the public skill and local CLI with stable symlinks.
- `uninstall.sh` - removes those public install targets without deleting the repo checkout.
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
./tests/install-script-test.sh
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

This repository is the public source package for `ai-init`. Clone it, install from it, update it with `git pull`, and reinstall if you move the checkout.

## License

MIT License. See [LICENSE](LICENSE).
