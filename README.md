![ai-init](assets/ai-init.jpg)

# ai-init

[한국어](README.ko.md)

`ai-init` is a markdown-first operating layer for Codex projects.

It gives your coding agent a durable project memory, a repeatable work lifecycle, and direct Codex skills for the moments that usually break down across long AI-assisted development sessions: starting work, adding features, fixing bugs, recovering context, closing a session, and finishing a branch.

The goal is simple: stop treating chat history as the source of truth.

## Why It Exists

`ai-init` was created for the ordinary friction that appears after a few serious AI coding sessions:

- The agent forgets project decisions because the important context lived only in chat.
- Every new session starts with repeated explanation instead of useful work.
- Feature requests jump straight to code before scope, risks, and verification are clear.
- Bugfixes are attempted from guesses instead of a reproduced symptom.
- Session handoffs say "done" without enough Git evidence for the next agent to trust.
- Local project rules, user preferences, and current state drift across scattered notes.

`ai-init` turns those fragile habits into a small project-local onboarding system. The agent gets a predictable set of markdown files to read, update, and hand off through.

## Philosophy

`ai-init` is built around a few strict preferences:

- **Markdown over memory** - project docs are the source of truth, not the current chat window.
- **Recovery before action** - the agent should rebuild context before changing code.
- **Spec and plan before feature code** - new behavior needs a written target before implementation.
- **Reproduce before fixing** - bugfixes start from evidence, not guesses.
- **Git evidence before session close** - handoffs and commits should come from the real diff.
- **Small reversible changes** - prefer narrow, reviewable steps over broad rewrites.
- **Optional integrations stay optional** - the public core works without Obsidian, hosted services, or private tooling.

## Skill Map

Installing this repository exposes the following Codex skills:

| Skill | Purpose |
| --- | --- |
| `$ai-init` | Bootstrap a project with durable AI working docs and print the next Codex prompt. |
| `$ai-init-session-recovery` | Rebuild current context from markdown docs and live workspace evidence before implementation. |
| `$ai-init-start-work` | Inspect Git state and prepare the correct branch/lane before starting work. |
| `$ai-init-feature-addition` | Turn a feature request into a spec and implementation plan before code. |
| `$ai-init-bugfix` | Reproduce, diagnose, fix, and verify broken existing behavior. |
| `$ai-init-session-close` | Close a session from Git evidence and write a usable next-session handoff. |
| `$ai-init-finish-work` | Decide what is safe to stage, commit, push, or merge after work is verified. |

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

Or invoke a lifecycle skill directly:

```text
$ai-init-start-work
$ai-init-feature-addition
$ai-init-bugfix
$ai-init-session-recovery
$ai-init-session-close
$ai-init-finish-work
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

This creates local install links for:

- `~/.codex/skills/ai-init`
- `~/.codex/skills/ai-init-start-work`
- `~/.codex/skills/ai-init-feature-addition`
- `~/.codex/skills/ai-init-bugfix`
- `~/.codex/skills/ai-init-session-recovery`
- `~/.codex/skills/ai-init-session-close`
- `~/.codex/skills/ai-init-finish-work`
- `~/.local/bin/ai-init`

See [docs/install.md](docs/install.md) for details.

## Basic Usage

Start Codex in the project you want to initialize, then use the entrypoint that matches the moment:

```text
$ai-init
```

The installed bootstrap skill calls the local `ai-init` command for you. The skill is the Codex entrypoint; the command is the fixed scaffold generator.

Direct lifecycle skills are installed alongside it:

- `$ai-init-start-work`
- `$ai-init-feature-addition`
- `$ai-init-bugfix`
- `$ai-init-session-recovery`
- `$ai-init-session-close`
- `$ai-init-finish-work`

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

## Generated `AGENTS.md`

When `$ai-init` runs in a target project, it writes a compact `AGENTS.md` from [templates/AGENTS.md](templates/AGENTS.md). That file is the project-level operating contract for Codex.

The generated file tells the agent to:

- Keep `AGENTS.md` short and operational instead of using it as a second README.
- Read `docs/ai/project_memory.md`, `docs/ai/change_playbook.md`, and `docs/ai/current_state.md` at startup.
- Treat markdown docs as the source of truth and optional recall/index files as rebuildable helpers.
- Avoid broad refactors, speculative abstractions, silent ambiguity resolution, and unrelated cleanup.
- Route feature work through a spec and plan, bugfixes through reproduce-diagnose-fix-verify, and refactors through regression protection first.
- Verify before claiming completion and report concrete evidence.
- At session close, inspect Git state first, update `docs/ai/current_state.md`, and write handoff notes when useful.

In practice, the generated `AGENTS.md` makes a blank or existing repository behave like an onboarded Codex workspace: the agent knows what to read first, where durable memory belongs, how to start work, and how to close the loop.

## The Basic Workflow

First-time project flow:

```text
+--------------------------------+
| 1. Create a new project folder |
|    or open an existing project |
+---------------+----------------+
                |
                v
+--------------------------------+
| 2. Start Codex in that folder  |
|    Run: $ai-init               |
+---------------+----------------+
                |
                v
+--------------------------------+
| 3. ai-init writes onboarding   |
|    docs and AGENTS.md          |
+---------------+----------------+
                |
                v
+--------------------------------+
| 4. Recover session context     |
|    Run: $ai-init-session-      |
|    recovery                    |
+---------------+----------------+
                |
                v
+--------------------------------+
| 5. Do one work lane            |
|    Feature: $ai-init-feature-  |
|    addition                    |
|    Bugfix:  $ai-init-bugfix    |
+---------------+----------------+
                |
                v
+--------------------------------+
| 6. Close the session           |
|    Run: $ai-init-session-close |
+---------------+----------------+
                |
                v
+--------------------------------+
| 7. Finish branch when ready    |
|    Run: $ai-init-finish-work   |
+---------------+----------------+
                |
                v
        +----------------+
        | Next session?  |
        +-------+--------+
                |
                v
     Repeat steps 4 -> 6
```

Use `$ai-init` once per project to create the onboarding scaffold. After that, the normal daily loop is recovery, one focused work lane, then session close. Run `$ai-init-finish-work` when the branch is actually ready to stage, commit, push, or merge.

Installed public commands:

- `$ai-init` - create starter docs and print the next Codex prompt.
- `$ai-init-session-recovery` - recover context before implementation.
- `$ai-init-start-work` - inspect Git state and prepare the right lane.
- `$ai-init-feature-addition` - write spec and plan artifacts before coding.
- `$ai-init-bugfix` - reproduce, diagnose, fix, and verify a regression.
- `$ai-init-session-close` - close a session from Git evidence.
- `$ai-init-finish-work` - decide what is safe to stage, commit, push, or merge.

See [docs/skill-contracts.md](docs/skill-contracts.md) for the detailed lifecycle contracts.

## What's Inside

### CLI

- `bin/ai-init` - idempotent scaffold generator for project docs and planning folders.
- `install.sh` - installs the public skill and local CLI with stable symlinks.
- `uninstall.sh` - removes those public install targets without deleting the repo checkout.
- `prompts/` - follow-up prompts for new projects, existing projects, feature addition, session recovery, and session close.
- `templates/` - generated files written into downstream projects.

### Skills

- `skills/ai-init/` - bootstrap skill and shared lifecycle references.
- `skills/ai-init-*/` - direct public lifecycle skills that wrap the shared references.

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
- `skills/ai-init/` and `skills/ai-init-*/` are the distributable skill sources.
- Root `AGENTS.md`, `docs/ai/*`, and `docs/superpowers/specs|plans/*` are local development state for this repository and are intentionally ignored.
- Installed local copies under `~/.codex/skills` are runtime copies, not release source of truth.

Do not run `ai-init --force` in this repository root. Test scaffold behavior in a temporary directory or fixture project.

## Status

This repository is the public source package for `ai-init`. Clone it, install from it, update it with `git pull`, and reinstall if you move the checkout.

## License

MIT License. See [LICENSE](LICENSE).
