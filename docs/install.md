# Install

`ai-init` is currently source-distribution first. The repository is the canonical release artifact until a package-manager installer is added.

## Clone

```sh
git clone https://github.com/noisyhaus/ai-init.git
cd ai-init
```

## Run From This Checkout

```sh
./bin/ai-init --help
```

Initialize a target project from inside that project:

```sh
/path/to/ai-init/bin/ai-init
```

## Add the CLI to PATH

```sh
mkdir -p "$HOME/.local/bin"
ln -sf "$PWD/bin/ai-init" "$HOME/.local/bin/ai-init"
```

Then run:

```sh
ai-init --help
```

## Install Codex Skills

Copy all public `ai-init` skills:

```sh
mkdir -p "$HOME/.codex/skills"
cp -R skills/ai-init* "$HOME/.codex/skills/"
```

Or copy only the core lifecycle set:

```sh
mkdir -p "$HOME/.codex/skills"
cp -R skills/ai-init "$HOME/.codex/skills/"
cp -R skills/ai-init-session-recovery "$HOME/.codex/skills/"
cp -R skills/ai-init-start-work "$HOME/.codex/skills/"
cp -R skills/ai-init-feature-addition "$HOME/.codex/skills/"
cp -R skills/ai-init-session-close "$HOME/.codex/skills/"
cp -R skills/ai-init-finish-work "$HOME/.codex/skills/"
```

Optional skills:

```sh
cp -R skills/ai-init-bugfix "$HOME/.codex/skills/"
cp -R skills/ai-init-pressure-test "$HOME/.codex/skills/"
```

## Use In a Project

```sh
cd /path/to/target-project
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
cp -R skills/ai-init* "$HOME/.codex/skills/"
```

If you symlinked `bin/ai-init` into `~/.local/bin`, the CLI updates with the repository checkout.

## Uninstall

Remove the CLI symlink if you created one:

```sh
rm -f "$HOME/.local/bin/ai-init"
```

Remove installed skills:

```sh
rm -rf "$HOME/.codex/skills/ai-init"*
```

Private note-taking integrations are intentionally excluded from the public core package.
