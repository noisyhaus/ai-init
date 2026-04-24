# Superpowers Compatibility

`ai-init` treats Superpowers as an optional markdown layout, not as a required runtime dependency.

## Contract

The feature-addition workflow writes or expects:

- `docs/superpowers/specs/`
- `docs/superpowers/plans/`

The minimum contract is a markdown spec and plan with clear objective, scope, acceptance criteria, risks, and verification notes.

## Update Policy

If Superpowers changes its internal commands or runtime behavior, `ai-init` should continue to work as long as the markdown document layout remains available.

Future Superpowers-specific integration should be implemented as an adapter or optional extension rather than a hard dependency in the core skill.
