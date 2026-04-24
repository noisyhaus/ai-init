# ai-init

[English](README.md)

`ai-init`은 여러 세션에 걸친 AI 코딩을 안정적으로 만들기 위한 markdown-first 프로젝트 메모리 시스템이자 Codex skill pack입니다.

코딩 에이전트가 코드를 바꾸기 전에 작고 오래 유지되는 작업 표면을 갖게 합니다. 프로젝트 메모리, 변경 규칙, 현재 상태, handoff, spec, plan, 그리고 세션 복구, 작업 시작, 세션 종료, 브랜치 마무리를 다루는 lifecycle skill을 제공합니다.

목표는 단순합니다. 채팅 기록을 source of truth로 취급하지 않는 것입니다.

## 작동 방식

`ai-init`은 대상 프로젝트 안에 가벼운 문서 scaffold를 만드는 것부터 시작합니다. 이 scaffold는 코딩 에이전트가 매 세션마다 같은 프로젝트 정보를 다시 추측하지 않고, 오래 유지되는 context를 저장할 수 있는 공간을 제공합니다.

그 다음 skill들이 다음 lifecycle을 제공합니다.

1. `ai-init`으로 프로젝트를 bootstrap합니다.
2. 구현 전에 markdown source-of-truth 파일에서 context를 복구합니다.
3. Git 상태를 확인하고 올바른 작업 lane을 선택해 작업을 시작합니다.
4. 기능 작업은 코드 작성 전에 spec과 plan을 만듭니다.
5. bugfix는 context 복구, 재현, 진단, 수정, 검증 순서로 진행합니다.
6. 세션 종료는 기억이 아니라 실제 Git evidence를 기준으로 합니다.
7. 작업 마무리는 무엇을 stage, commit, push, merge할 수 있는지 판단합니다.

public core는 의도적으로 plain markdown만 사용합니다. database, hosted service, private note-taking dependency가 없습니다.

## 설치

현재 `ai-init`은 source distribution을 우선합니다.

repository를 clone합니다.

```sh
git clone https://github.com/noisyhaus/ai-init.git
cd ai-init
```

checkout에서 CLI를 실행합니다.

```sh
./bin/ai-init --help
```

필요하면 `PATH`에 추가합니다.

```sh
mkdir -p "$HOME/.local/bin"
ln -sf "$PWD/bin/ai-init" "$HOME/.local/bin/ai-init"
```

Codex skill을 수동 설치합니다.

```sh
mkdir -p "$HOME/.codex/skills"
cp -R skills/ai-init* "$HOME/.codex/skills/"
```

자세한 내용은 [docs/install.md](docs/install.md)를 보세요.

## 기본 사용법

초기화하려는 프로젝트에서 실행합니다.

```sh
ai-init
```

새 프로젝트라면:

```sh
ai-init --new-project
```

기존 프로젝트라면:

```sh
ai-init --existing-project
```

선택 scaffold:

```sh
ai-init --with-rules
ai-init --with-memory-plus
ai-init --with-local-recall
```

후속 prompt만 출력하려면:

```sh
ai-init --print-prompt
```

## 생성되는 파일

core scaffold는 세 개의 markdown source-of-truth 파일을 중심으로 구성됩니다.

- `docs/ai/project_memory.md` - 프로젝트 정체성, architecture note, canonical source, invariant를 저장합니다.
- `docs/ai/change_playbook.md` - 프로젝트별 변경 규칙, 검증 기대치, 작업 convention을 저장합니다.
- `docs/ai/current_state.md` - 현재 목표, 검증된 상태, risk, 다음 action, handoff 상태를 저장합니다.

그 외에 다음을 생성합니다.

- `AGENTS.md`
- `README.md`
- `docs/ai/handoffs/`
- `docs/ai/tasks/`
- `docs/adr/`
- `docs/superpowers/specs/`
- `docs/superpowers/plans/`

선택 scaffold는 다음을 추가할 수 있습니다.

- `docs/ai/rules/`
- `docs/ai/agent_memory.md`
- `docs/ai/user_preferences.md`
- `.ai-index/`
- `scripts/ai-index.py`

## 기본 Workflow

`ai-init` - 대상 프로젝트를 bootstrap하고 Codex에 전달할 다음 prompt를 출력합니다. agent가 "ai-init"을 일반 텍스트로 해석하게 두지 않고, starter docs를 만드는 명시적 command surface 역할을 합니다.

`ai-init-session-recovery` - 새 채팅이나 재개된 작업의 시작 시 실행합니다. 구현 전에 project memory, change rules, current state, 선택 memory file, 관련 handoff/spec/plan을 읽습니다.

`ai-init-start-work` - feature, UI change, bugfix, release-prep 작업 전에 Git lane을 준비합니다. branch/worktree 상태를 확인하고 불명확한 base에서 새 작업을 시작하지 않게 합니다.

`ai-init-feature-addition` - 새 기능 작업에 사용합니다. 요청을 프로젝트 문서와 다시 연결하고, invariant impact note를 작성하고, scope를 정한 뒤 coding 전에 spec/plan artifact를 만듭니다.

`ai-init-bugfix` - bugfix와 regression에 사용합니다. context를 먼저 복구하고, 가능하면 문제를 재현하고, root cause를 찾고, 가장 작은 수정으로 해결한 뒤 검증합니다.

`ai-init-pressure-test` - 다른 AI가 hidden assumption, 약한 handoff, 불명확한 scope, 빠진 constraint를 challenge할 수 있는 review prompt를 만듭니다.

`ai-init-session-close` - evidence를 기준으로 세션을 종료합니다. Git status/diff를 확인하고, in-scope 작업과 기존 dirty state 또는 generated noise를 분리하며, current state와 handoff docs를 업데이트하고 남은 risk를 보고합니다.

`ai-init-finish-work` - 완료된 lane을 마무리합니다. 먼저 session close를 실행하고, 그 evidence를 바탕으로 무엇을 stage, commit, push, merge 준비할 수 있는지 결정합니다.

각 skill의 자세한 contract는 [docs/skill-contracts.md](docs/skill-contracts.md)를 보세요.

## 구성

### CLI

- `bin/ai-init` - 프로젝트 문서와 planning folder를 생성하는 idempotent scaffold generator입니다.
- `prompts/` - 새 프로젝트, 기존 프로젝트, feature addition, session recovery, session close용 follow-up prompt입니다.
- `templates/` - downstream 프로젝트에 생성되는 file template입니다.

### Skills

- `skills/ai-init/`
- `skills/ai-init-session-recovery/`
- `skills/ai-init-start-work/`
- `skills/ai-init-feature-addition/`
- `skills/ai-init-bugfix/`
- `skills/ai-init-pressure-test/`
- `skills/ai-init-session-close/`
- `skills/ai-init-finish-work/`

### Docs

- [docs/install.md](docs/install.md)
- [docs/skill-contracts.md](docs/skill-contracts.md)
- [docs/superpowers-compatibility.md](docs/superpowers-compatibility.md)

## Superpowers Compatibility

Superpowers는 필수가 아닙니다.

`ai-init-feature-addition`은 markdown-compatible spec/plan layout을 사용합니다.

- `docs/superpowers/specs/`
- `docs/superpowers/plans/`

프로젝트가 이미 Superpowers를 사용한다면 `ai-init`은 같은 문서 layout을 공유할 수 있습니다. 사용하지 않는 프로젝트에서도 workflow는 plain markdown file만으로 동작합니다. Superpowers-specific behavior는 public core의 hard dependency가 아니라 optional adapter로 남아야 합니다.

## 철학

- Markdown이 source of truth입니다.
- 구현 전에 context를 복구합니다.
- 기능 코드는 spec과 plan 이후에 작성합니다.
- 완료 claim보다 evidence를 우선합니다.
- 세션 종료는 Git evidence를 기준으로 합니다.
- 넓은 rewrite보다 작고 되돌리기 쉬운 변경을 선호합니다.
- optional integration이 숨겨진 requirement가 되면 안 됩니다.

## Maintainer Workflow

변경사항을 publish하기 전에 검증을 실행합니다.

```sh
./tests/ai-init-output-test.sh
git diff --check
rg -n "\p{Hangul}" . -g '!README.ko.md'
rg -n -i "o[b]sidian|w[i]ki|with-w[i]ki|w[i]ki-sync|w[i]ki-hook" .
```

release tag는 semantic versioning을 사용합니다.

```sh
git tag v0.1.0
git push origin v0.1.0
```

추천 release note section:

- Added
- Changed
- Fixed
- Migration

## Repository Dogfooding

이 repository는 `ai-init`으로 자기 자신의 개발 context를 관리합니다.

- root `AGENTS.md`와 `docs/ai/*`는 `ai-init` 자체를 어떻게 작업할지 설명합니다.
- `templates/*`는 downstream user project에 생성되는 file입니다.
- `skills/*`는 배포 가능한 skill source입니다.
- `~/.codex/skills` 아래 설치된 local copy는 runtime copy이며 release source of truth가 아닙니다.

이 repository root에서 `ai-init --force`를 실행하지 마세요. scaffold behavior는 temporary directory나 fixture project에서 테스트하세요.

## Status

초기 public packaging 단계입니다. 현재 repository에는 source-first distribution을 위한 local working implementation과 Codex skill이 들어 있습니다.

## License

MIT License입니다. 자세한 내용은 [LICENSE](LICENSE)를 보세요.
