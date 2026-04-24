# Open Source Distribution Plan

Date: 2026-04-24
Status: draft
Spec: `docs/superpowers/specs/2026-04-24-open-source-distribution.md`

## Objective

Prepare `ai-init` for open-source GitHub distribution without prematurely committing to a package registry or installer channel.

## Invariant Check

- SSoT: Keep the distribution contract in README, spec, plan, and tests; release artifacts remain derivative.
- SRP: Separate repository docs, CLI implementation, templates, tests, and release automation.
- Consistency: README quick start, CLI help, generated path contract, tests, and changelog must match.
- Atomicity: Release workflow must fail closed if tests or artifact generation fail.
- Idempotency: Scaffold smoke tests must include first run and second run behavior.
- No Silent Fallback: Install, scaffold, template lookup, and release failures must be observable.

## Work Breakdown

1. Repository identity and policy
   - Choose GitHub owner/repo name.
   - Choose license.
   - Decide initial docs language strategy.
   - Initialize git if this workspace is the future repo root.

2. Public documentation skeleton
   - Rewrite README for public users.
   - Add generated-path contract.
   - Add install/run section with source install placeholder until implementation language is chosen.
   - Add CONTRIBUTING, SECURITY, CHANGELOG, and release policy.

3. CLI implementation packaging
   - Select implementation language/package manager.
   - Create the `ai-init` executable entry point.
   - Store templates in a stable source directory.
   - Print created/skipped files and next prompt.

4. Verification
   - Add smoke test that runs in a temporary directory.
   - Verify required files and directories are created.
   - Verify re-run behavior.
   - Verify failure on missing templates or unwritable target directory.

5. Release preparation
   - Add CI for tests and lint/typecheck if applicable.
   - Add release checklist.
   - Tag first source release only after tests pass.
   - Add one package registry only after the source release contract is stable.

## Initial Milestone

Milestone 0 is documentation-only:

- Update README and OSS policy docs.
- Capture generated-path contract.
- Leave install commands as implementation-specific placeholders.
- No external publish.

## Verification Plan

- For documentation-only changes: inspect links, generated paths, and consistency between README/spec/plan.
- For CLI changes later: run local smoke tests in a temp directory and verify both clean run and repeated run.
- Before public release: run full CI, inspect release artifact contents, and confirm changelog/tag alignment.

## Remaining Risks

- The implementation language is undecided, so package-channel details remain provisional.
- License choice requires owner decision.
- GitHub publishing requires external account authority.
- The current workspace is not yet a git repository.

## First Execution Task

Draft the public README and OSS policy docs while keeping all install commands marked as pending implementation-language selection.
