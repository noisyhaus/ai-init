# Open Source Distribution Spec

Date: 2026-04-24
Status: draft

## Goal

Distribute `ai-init` as an open-source GitHub project that developers can install, inspect, and run as a local bootstrap command for AI-agent-ready project docs.

## Current Context

The repository currently contains only the generated ai-init documentation scaffold. There is no git repository initialized in this workspace yet, and no package layout, executable source, tests, license, release workflow, or public README content beyond the starter template.

## Invariant Impact

- SSoT: GitHub source plus markdown specs own the product contract. Package registries, release archives, and local installs are derivative distribution outputs.
- SRP: CLI runtime owns scaffold execution; templates own generated docs; release metadata owns installation and versioning.
- Consistency: README, CLI help, generated paths, tests, release notes, and package metadata must describe the same behavior.
- Atomicity: Install and scaffold commands must report failures clearly and must not claim success after partial initialization.
- Idempotency: Re-running `ai-init` in the same project must be safe; existing files are preserved unless an explicit overwrite mode exists.
- No Silent Fallback: Missing templates, write errors, unsupported package channels, and unavailable executables must be visible to the user.

## Brainstorming Scope

### Goal

Make the first public release trustworthy before making it widely convenient. The first version should prove that users can clone or install the command, run it in a project, and understand what was created.

### Scope

- Public GitHub repository setup.
- Clear README with value proposition, install/run instructions, generated file list, examples, and safety/idempotency notes.
- OSS basics: license, changelog, contributing guide, code of conduct if accepting broad community contributions.
- CLI package structure with a stable `ai-init` command.
- Release process with version tags and checks.
- Smoke tests that run the command in a temporary directory and verify generated paths.
- Initial distribution channel that does not overcommit to package ecosystems before the implementation language is stable.

### Non-Scope

- Marketplace-style plugin ecosystem.
- Hosted service, account system, telemetry, or remote sync.
- Multiple package registries on day one.
- Backward compatibility promise beyond the documented first public CLI contract.
- Auto-updating generated docs in existing projects.

### Success Criteria

- A user can discover the project from GitHub and understand its purpose in under one minute.
- A user can run one documented command path and get a successful scaffold in a clean directory.
- The repository explains what files are created and how re-runs behave.
- CI verifies the scaffold path list and printed follow-up prompt.
- A release tag maps to a reproducible source state and changelog entry.

### Constraints

- The project is currently pre-implementation.
- No package manager or implementation language has been selected.
- Distribution should not require users to trust opaque installers before they can inspect the source.
- The command writes files into user repositories, so safety, idempotency, and observable failures are product requirements.

## Recommended Distribution Strategy

Use a three-phase release path.

### Phase 1: GitHub-First Source Release

Ship a minimal public repository with:

- `README.md`: what it is, who it is for, quick start, generated paths, idempotency behavior, examples.
- `LICENSE`: permissive default recommendation is MIT or Apache-2.0; choose one before first public push.
- `CHANGELOG.md`: keep release notes human-readable.
- `CONTRIBUTING.md`: explain local dev, tests, issue/PR expectations.
- `SECURITY.md`: tell users how to report command/template security issues.
- CLI source and templates.
- Tests that run `ai-init` in a temporary directory.

For install, start with a transparent source-based path:

```bash
git clone https://github.com/<owner>/ai-init.git
cd ai-init
<project-specific install command>
ai-init
```

This avoids prematurely choosing npm, PyPI, Homebrew, or curl installers before the implementation shape is settled.

### Phase 2: Single Primary Package Channel

After the CLI structure is stable, choose one package registry that matches the implementation language:

- Node CLI: npm package with `bin` mapping to `ai-init`.
- Python CLI: PyPI package with console script entry point.
- Rust/Go single binary: GitHub Releases first, then Homebrew tap only if there is real demand.

Do not publish to multiple package ecosystems at once. Each channel adds docs, CI, versioning, and support obligations.

### Phase 3: Convenience Installers

Add optional convenience only after registry installs and smoke tests are reliable:

- GitHub release binaries or archives.
- Homebrew formula/tap.
- `curl | sh` installer only if it is short, auditable, version-pinned, and documented as optional.

## Core Design Choices

- Public contract first: define the command behavior, generated paths, overwrite policy, and failure behavior before optimizing packaging.
- GitHub is the canonical distribution surface: registries mirror release artifacts but do not own product truth.
- Keep templates in-repo: users can inspect exactly what will be generated.
- Keep command output explicit: print created/skipped files and the next prompt.
- Prefer one stable install path at launch: broad distribution before tests and versioning will create support debt.

## Trade-Offs

- GitHub-first is less convenient than package managers, but it is more transparent and safer for a file-writing bootstrap tool.
- A single registry slows reach across ecosystems, but reduces release complexity and inconsistent installation docs.
- Explicit idempotency rules add implementation work, but they are necessary because the command modifies user-owned repositories.
- Deferring telemetry avoids privacy concerns and simplifies OSS trust, but product usage feedback must come from issues and discussions.

## Validity Conditions

Required state:

- A real git repository with public-ready history.
- Chosen project name and GitHub owner.
- License decision.
- Implementation language and package manager decision before registry publishing.
- Versioning policy, at minimum SemVer-like tags after first public release.
- Tests that verify generated files and idempotent re-runs.

Permissions:

- GitHub repository creation/publishing authority.
- Package registry account/token only when entering Phase 2.

Identifiers:

- GitHub repo: `<owner>/ai-init`.
- CLI command: `ai-init`.
- Generated path contract documented in README and tests.

Storage:

- Templates live in source control.
- Generated docs live in target repositories.
- Release artifacts are derivative outputs from tagged source.

Events and async control:

- Release workflow should run tests before publishing artifacts.
- Failed publish steps must stop release rather than silently skipping a channel.

Feasibility classification:

- Impossible without user decision: license, GitHub owner/repo, implementation language if package registry publishing is requested.
- Merely inconvenient: lack of registry support on first release; source install can ship first.

## Open Questions

- Which implementation language should own the CLI?
- Should the first public package target Korean users first, English users first, or bilingual docs from day one?
- Should generated docs default to Korean, English, or language selection via flag?
- Which license does the owner want?
- Will the repo include the existing local `ai-init` implementation or a clean reimplementation?

## First Execution Task

Create the public repository skeleton docs: production README outline, license decision note, CONTRIBUTING, SECURITY, CHANGELOG, and a documented generated-path contract. Do not publish externally until the CLI source and smoke tests exist.
