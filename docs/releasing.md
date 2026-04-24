# Releasing

`ai-init` uses source-first distribution from GitHub.

## Versioning

Use semantic versioning:

- `v0.1.0` for the first public release.
- `v0.2.0` for new skills, new generated files, or workflow behavior changes.
- `v0.2.1` for docs, tests, and compatibility fixes.
- `v1.0.0` when the public CLI and skill contracts are stable.

## Pre-Release Checklist

Run:

```sh
./tests/install-script-test.sh
./tests/ai-init-output-test.sh
git diff --check
rg -n "\p{Hangul}" .
rg -n -i "o[b]sidian|w[i]ki|with-w[i]ki|w[i]ki-sync|w[i]ki-hook" .
```

Confirm:

- `./install.sh` installs both public targets and `./uninstall.sh` removes them safely.
- README installation instructions still work.
- `docs/install.md` matches the current install script, CLI, and skill layout.
- `docs/skill-contracts.md` describes the public `ai-init` skill and its lifecycle routes.
- `docs/superpowers-compatibility.md` still describes optional compatibility only.
- Root `AGENTS.md`, `docs/ai/*`, and `docs/superpowers/specs|plans/*` are not tracked.
- Scaffold behavior was tested in a temporary directory, not the repository root.

## Tag

```sh
git tag v0.1.0
git push origin v0.1.0
```

## Release Notes

Use these sections:

```md
## Added

## Changed

## Fixed

## Migration
```

## Update Policy

Core skills should avoid hard dependencies on optional external skill packs. If an integration becomes useful, add it as an adapter or optional extension instead of changing the public core contract.
