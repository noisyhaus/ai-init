# Install

`ai-init` is currently source-distribution first. The repository is the canonical release artifact until a package-manager installer is added.

## Clone

```sh
git clone https://github.com/noisyhaus/ai-init.git
cd ai-init
```

## Install From This Checkout

```sh
./install.sh
```

The installer creates these local links:

- `~/.codex/skills/ai-init`
- `~/.codex/skills/ai-init-start-work`
- `~/.codex/skills/ai-init-feature-addition`
- `~/.codex/skills/ai-init-bugfix`
- `~/.codex/skills/ai-init-session-recovery`
- `~/.codex/skills/ai-init-session-close`
- `~/.codex/skills/ai-init-finish-work`
- `~/.local/bin/ai-init`

## Use In a Project

```sh
cd /path/to/target-project
```

Start Codex in that directory and type:

```text
$ai-init
```

Or call a lifecycle skill directly:

```text
$ai-init-start-work
$ai-init-feature-addition
$ai-init-bugfix
$ai-init-session-recovery
$ai-init-session-close
$ai-init-finish-work
```

The bootstrap skill calls the local `ai-init` command through `skills/ai-init/scripts/run-ai-init.sh`.

You can still run the CLI directly when needed:

```sh
ai-init
```

For explicit project modes:

```sh
ai-init --new-project
ai-init --existing-project
```

Optional scaffolds:

```sh
ai-init --with-rules
ai-init --with-memory-plus
ai-init --with-local-recall
```

## Update

From the cloned repository:

```sh
git pull --ff-only
./install.sh
```

If you already installed with `./install.sh`, the update step just refreshes the same skill and CLI symlink targets.

## Uninstall

```sh
./uninstall.sh
```

Private note-taking integrations are intentionally excluded from the public core package.
