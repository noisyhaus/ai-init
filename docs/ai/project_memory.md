# Project Memory

## Project Summary
- Project name: 26_ai init
- What this project does: Provides an open-source `ai-init` bootstrap system that creates AI-agent-friendly project documentation, operating rules, and planning folders for software projects.
- Primary user/problem: Developers using Codex or similar coding agents need a repeatable way to initialize durable project context instead of relying on ephemeral chat history.
- Success criteria: A new user can discover the project on GitHub, install/run the bootstrap command, generate the expected docs in a target repository, and understand the next planning prompt without reading the implementation.

## Tech Stack
- Frontend:
- Backend:
- DB:
- Infra:
- Package manager: undecided; distribution strategy should keep the CLI package manager-specific implementation behind a small command surface.

## Core Commands
- Install:
- Dev:
- Test:
- Lint:
- Build:

## Core Structure
- Main code modules or directories:
  - `AGENTS.md`: agent operating contract for developing `ai-init` itself in this workspace.
  - `docs/ai/`: durable project context and change rules for this `ai-init` repository.
  - `skills/`: source copies of Codex skills intended for distribution.
  - `templates/`: files generated into downstream user projects by `bin/ai-init`.
  - `prompts/`: reusable follow-up prompts and prompt text emitted by the CLI.
  - `docs/superpowers/specs/`: product/design specs for this repository.
  - `docs/superpowers/plans/`: implementation plans for this repository.
- Critical code boundaries inside the repo:
  - Bootstrap command behavior should stay separate from documentation templates.
  - Distribution metadata should stay separate from runtime scaffold generation.
  - Root development docs (`AGENTS.md`, `docs/ai/*`) must not be confused with generated template docs (`templates/*`).
  - Installed local skills under `~/.codex/skills` are runtime copies; release source of truth is `skills/` in this repository.
- Important implementation constraints:
  - No implementation before distribution spec and first plan exist.
  - Keep the public command idempotent for repeated runs in an existing project.
  - Do not run `ai-init --force` in the repository root because it can overwrite development docs with generated templates.
  - Scaffold tests must run in a temporary directory or fixture project.

## System Structure
- Main operating surfaces (UI / API / services / storage / integrations / tests / docs):
  - CLI command: `ai-init`.
  - Generated docs: `AGENTS.md`, `README.md`, `docs/ai/*`, `docs/adr/`, `docs/superpowers/*`.
  - Repository docs: public README, install instructions, release notes, examples.
- Primary entry points and operator touchpoints:
  - GitHub repository.
  - Local shell command run inside a target project.
  - Follow-up prompt printed after scaffold completion.
- External systems or downstream targets:
  - GitHub releases and source repository.
  - Future package registries are allowed only after the CLI contract is stable.
- Core artifact or data flow across surfaces:
  - CLI reads bundled templates and writes project docs into the current working directory; generated markdown remains the source of truth for the initialized project.

## Canonical Sources
- Source of truth for product/operating rules: `docs/ai/project_memory.md`, feature specs under `docs/superpowers/specs/`, and plans under `docs/superpowers/plans/`.
- Source of truth for persistent data: Generated markdown files in each target repository.
- Source of truth for API/schema/contracts: The documented `ai-init` CLI flags, generated path list, and idempotency rules.
- Source of truth for distributed skills: `skills/*/SKILL.md` in this repository.
- Source of truth for generated scaffold files: `templates/*` plus `bin/ai-init` render behavior.
- Source of truth for identifiers: File paths and command names documented in specs/plans.
- Source of truth for config/env: CLI arguments and explicit environment variables documented with the command.
- Source of truth for durable knowledge or project state: Markdown docs, not chat history or recall caches.
- Generated outputs, caches, indexes, or recall layers that must not be treated as source of truth: `.omx/`, future `.ai-index/`, generated package artifacts, and local recall caches.
- Self-heal rule for cache/index miss: Re-read canonical markdown docs and regenerate derivative indexes/caches from them.

## Change Impact Rules
- If CLI flags or generated paths change, also inspect README install docs, generated template docs, tests, and release notes.
- If template content changes, also inspect scaffold verification, README examples, and next-prompt output.
- If root development docs change, do not automatically mirror the change into `templates/`; decide whether it is repo-specific or user-project behavior.
- If `skills/` change, decide whether the installed local runtime copy under `~/.codex/skills` needs a manual sync for local dogfooding.
- Common multi-surface coupling rules: Public docs, CLI help, tests, and generated output examples must describe the same command behavior.
- Common stale-doc or stale-test failure modes: README lists paths that the command no longer creates; tests assert old prompt text; release docs imply a registry that is not yet published.

## Invariants
- Must not break: A normal scaffold run should create the documented files/directories or clearly report why it cannot.
- SSoT ownership rules: Markdown templates and specs own durable rules; generated outputs are copies in target repositories, not hidden runtime state.
- SRP boundaries: CLI orchestration, template content, distribution metadata, and verification tests should remain separate responsibilities.
- Consistency constraints: README, CLI help, tests, release notes, and generated docs must stay aligned.
- Atomicity requirements: Failed scaffold runs must not leave users believing initialization succeeded; partial writes need observable reporting.
- Idempotency requirements: Re-running `ai-init` should be safe and should skip or preserve existing user-owned files unless explicit overwrite behavior is requested.
- No Silent Fallback constraints: Missing templates, write failures, unsupported flags, and package/install failures must be visible.
- Security constraints: Do not execute generated project content; avoid network calls during local scaffold unless explicitly requested.
- Performance constraints: Scaffold should complete quickly enough for interactive shell use.

## Long-lived Decisions
- Durable architecture and workflow decisions:
  - Start distribution as a GitHub-first open-source CLI with source install instructions and release artifacts before adding package-registry channels.
  - Treat package registries as distribution adapters, not the canonical source of product truth.

## Maintenance Notes
- Keep this file focused on durable project structure, canonical sources, and long-lived constraints.
- Put change procedures in `docs/ai/change_playbook.md`, not here.
- Put session status in `docs/ai/current_state.md`, not here.
