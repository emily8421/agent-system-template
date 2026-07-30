#!/usr/bin/env bash
# new-domain-project.sh — 从 agent-system-template（L2）派生 agent 领域派生项目（L3）。
#
# 单源锚定 L2：从 L2 整仓派生通用方法论 + agent overlay，写领域派生身份，
# 剥离所有 L1 同步入口（sync-template / check-derived-sync / check-template / new-project），
# 叠加 agent overlay，装领域 check workflow，git init。L3 只从 L2 同步，不直连 L1。
#
# 用法:
#   bash scripts/new-domain-project.sh <项目名> [--source <agent-system-template>] [--account <login>] [--visibility public|private] [--no-remote]
#     <项目名>           新项目目录名（相对当前目录或绝对路径），默认也是 GitHub 仓库名
#     --source <dir>     领域模板源目录（默认 = 脚本所在仓库根；需确保 git 干净 / 最新）
#     --account <login>  建仓库的 GitHub 账号（默认取当前 gh 登录账号）
#     --visibility <v>   private（默认）或 public
#     --no-remote        只本地，不建 GitHub 仓库、不推送
# 依赖: git（本地派生）；建远端需 gh（目标账号已登录）。
# 配套: template-docs/agent-system/domain-derived-scenarios.md §3（创建流程）。
set -euo pipefail

# MSYS PATH 自举守卫（详见 new-project.sh 同名守卫注释）
if [[ -z "${MSYS_PATH_GUARD:-}" ]] && ! command -v dirname >/dev/null 2>&1; then
  for _guard_dir in /usr/bin /mingw64/bin /mingw32/bin; do
    [[ -d "$_guard_dir" ]] || continue
    case ":${PATH:-}:" in
      *":$_guard_dir:"*) ;;
      *) PATH="$_guard_dir:$PATH" ;;
    esac
  done
  export PATH MSYS_PATH_GUARD=1
fi

NAME=""
SOURCE=""
ACCOUNT=""
VISIBILITY="private"
NO_REMOTE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source) SOURCE="${2:?--source 需要值}"; shift 2;;
    --account) ACCOUNT="${2:?--account 需要值}"; shift 2;;
    --visibility) VISIBILITY="${2:?--visibility 需要值}"; shift 2;;
    --no-remote) NO_REMOTE=1; shift;;
    -h|--help) sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
    -*) echo "未知选项: $1" >&2; exit 1;;
    *) if [[ -n "$NAME" ]]; then echo "多余的位置参数: $1" >&2; exit 1; fi; NAME="$1"; shift;;
  esac
done

[[ -n "$NAME" ]] || { echo "用法: bash scripts/new-domain-project.sh <项目名> [--source ..] [--account ..] [--visibility public|private] [--no-remote]" >&2; exit 1; }
case "$VISIBILITY" in private|public) ;; *) echo "--visibility 仅支持 private 或 public: $VISIBILITY" >&2; exit 1;; esac

TARGET="$NAME"; [[ "$TARGET" = /* ]] || TARGET="$PWD/$TARGET"
[[ ! -e "$TARGET" ]] || { echo "目标已存在: $TARGET" >&2; exit 1; }
BASE="$(basename "$TARGET")"
mkdir -p "$(dirname "$TARGET")"

if [[ -z "$SOURCE" ]]; then
  SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
else
  SOURCE="$(cd "$SOURCE" && pwd)"
fi
for probe in VERSION domain-template-sync.json; do
  [[ -f "$SOURCE/$probe" ]] || { echo "Source 不是 agent-system-template 领域模板（缺 $probe）: $SOURCE" >&2; exit 1; }
done

DOMAIN_VERSION="$(tr -d '[:space:]' < "$SOURCE/VERSION")"
BASE_VERSION="$(grep -E 'Current synced template version' "$SOURCE/TEMPLATE-BASE.md" 2>/dev/null | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
BASE_VERSION="${BASE_VERSION:-unknown}"
REMOTE="$(git -C "$SOURCE" config --get remote.origin.url 2>/dev/null || true)"
REPO_LABEL="$(printf '%s' "$REMOTE" | sed -nE 's#.*github\.com[/:]([^/]+/[^/]+?)(\.git)?$#github.com/\1#p')"
REPO_LABEL="${REPO_LABEL:-github.com/<owner>/agent-system-template}"
TODAY="$(date +%Y-%m-%d)"

echo "==> 从 agent-system-template（L2）派生 agent 项目"
echo "source: $SOURCE ($DOMAIN_VERSION; base via L2: $BASE_VERSION)"
echo "target: $TARGET"
echo ""

# 1) git archive L2 整仓 -> Target（拿通用方法论 + agent overlay 源）
mkdir -p "$TARGET"
git -C "$SOURCE" archive --format=tar HEAD | tar -x -C "$TARGET"

rm_target() { [[ -e "$TARGET/$1" ]] && rm -rf "$TARGET/$1" || true; }

# 2) 清理 L2 维护件 + 剥离所有 L1 同步入口（L3 单源锚定 L2，不挂 L1）
echo "==> 剥离 L2 维护件与 L1 同步入口"
rm_target "_examples"
rm_target "_archive"
rm_target "sync-records"
rm_target "upstream"
for s in \
  scripts/sync-template.ps1 scripts/sync-template.sh \
  scripts/check-template.ps1 scripts/check-template.sh \
  scripts/check-derived-sync.ps1 scripts/check-derived-sync.sh \
  scripts/new-project.sh \
  scripts/sync-all-derived.sh \
  scripts/new-domain-project.ps1 scripts/new-domain-project.sh; do
  rm_target "$s"
done
mkdir -p "$TARGET/.github/workflows"
find "$TARGET/.github/workflows" -maxdepth 1 -name '*.yml' -delete 2>/dev/null || true
rm_target "_proposals"
mkdir -p "$TARGET/_proposals"

# 3) 写领域派生身份文件
echo "==> 写领域派生身份文件"
printf 'v0.1.0\n' > "$TARGET/VERSION"

cat > "$TARGET/CHANGELOG.md" <<EOF
# CHANGELOG

本文件记录本 agent 项目自身版本历史；继承的领域模板版本见 TEMPLATE-BASE.md。

## v0.1.0（$TODAY）

- 初始化 agent 项目，基于 agent-system-template $DOMAIN_VERSION（母模板 $BASE_VERSION 经 L2 传递）派生。
EOF

cat > "$TARGET/CHANGELOG-PLAIN.md" <<EOF
# CHANGELOG-PLAIN

本文件用大白话记录本 agent 项目自身每个版本改善了什么；继承的母模板版本见 TEMPLATE-BASE.md。

## v0.1.0（$TODAY）

初始化 agent 项目，基于 agent-system-template $DOMAIN_VERSION 创建。后续这里只记本项目自己的演进，不记母模板 / 领域模板自身的版本历史。
EOF

cat > "$TARGET/TEMPLATE-BASE.md" <<EOF
# Template Base

> Records the upstream lineage for this agent-derived project (L3). Single-source anchored to agent-system-template (L2); L1 base methodology is delivered through L2. Do not sync ai-project-template (L1) directly.

- Lineage type: agent derived project (L3)
- Domain template repository: $REPO_LABEL
- Domain template version: $DOMAIN_VERSION
- Inherited base template version (via L2): $BASE_VERSION
- Domain standards scope: agent-system（架构 / 工具权限 / memory-state / trace-replay / HITL-safety / agent-eval）
- Project version file: VERSION
- Project version at creation: v0.1.0

## Version Semantics

- VERSION is owned by this agent project and records the project version.
- CHANGELOG.md and CHANGELOG-PLAIN.md are owned by this project; domain sync does not overwrite them.
- TEMPLATE-BASE.md records the inherited agent-system-template version and (via L2) the ai-project-template base version, for sync audit.
- L3 syncs ONLY from agent-system-template (L2); it must NOT sync ai-project-template (L1) directly.
- Domain sync commits keep the message format: sync agent domain template <L2-version> from agent-system-template.
EOF

cat > "$TARGET/README.md" <<EOF
# $BASE

> 本项目由 agent-system-template（L2 领域模板）派生，单源锚定 L2。请在初始化阶段把本文件改写为项目说明。

## 项目简介

（用 2-3 句话说明本 agent 项目要解决的问题、目标用户与当前阶段范围。）

## 当前阶段

- 当前阶段：Phase1（待确认）
- 形态：single-agent（默认；出现明确多 agent 信号时再评估 multi-agent profile）
- 阶段目标：（待填）
- 非目标：（待填）

## 它能做什么

- （列出当前已确认要实现的核心 agent 能力——本项目自己的能力，不照搬领域标准件。）

## 快速开始

1. 初填 ai/project-rules.md（项目身份、Phase、技术栈、运行环境、形态裁剪）。
2. 按 template-docs/agent-system/profiles/single-agent.md 选型；按 docs/design/agent-*.md 填 agent 设计。
3. agent 相关任务额外读 ai/agent-rules/ 与 ai/doc-standards/agent-*.md。
4. 创建 / 同步领域标准件见 template-docs/agent-system/domain-derived-scenarios.md。

## 模板关系

- 通用方法论 + agent 标准件均来自 agent-system-template（L2）；母模板方法论经 L2 传递，本项目不直连母模板。
- 项目自有版本在 VERSION；继承的领域模板 / 母模板版本在 TEMPLATE-BASE.md。
- 领域同步入口：scripts/sync-domain-template.*；领域自检：scripts/check-domain-derived-sync.* + scripts/check-agent-template.*。
EOF

cat > "$TARGET/ai/project-rules.md" <<EOF
# 项目专属规则

> 本文件记录本 agent 派生项目（L3）自身约束。由 agent-system-template 派生时重置为占位；请按【撰写提要】填写。

## 0. 项目标识

- 项目名称：$BASE（待确认）
- 仓库角色：领域派生项目（L3），单源锚定 agent-system-template（L2）。
- 继承领域模板版本：见 TEMPLATE-BASE.md。
- 分层权威入口：TEMPLATE-BASE.md 与 template-docs/agent-system/layer-map.md。

## 1. Phase 边界

（撰写提要：Phase1 允许 / 禁止事项、Phase2 预告。当前阶段待确认。）

## 2. 技术栈约束

（撰写提要：agent runtime、模型供应商、memory backend、是否持久化 / 对外接口。模板不绑定具体 runtime。）

## 3. 项目形态与文档裁剪

（撰写提要：是否持久化、是否对外接口、演示形态、是否启用 frontend。）

## 4. 版本管理

- 根 VERSION 记录本项目自身版本，从 v0.1.0 起步。
- 继承的领域模板 / 母模板版本见 TEMPLATE-BASE.md。
EOF

cat > "$TARGET/_proposals/README.md" <<'EOF'
# 提案起草区

本目录用于在本 agent 项目内临时起草可回流到 agent-system-template（L2 领域模板）的优化提案。

当开发过程中发现 agent 领域标准件、同步清单、自检或文档骨架的可通用改进时，在此新增：

```text
TEMPLATE-UPGRADE-<slug>.md
```

提案成熟后，回到 agent-system-template 仓库开 issue 或 PR 提交。跨领域通用经验由 L2 提炼后再回流母模板。
EOF

# 4) 叠加 agent overlay（下发 docs/design/agent-*.md 等项目态文件；非 git root，复制不提交）
echo "==> 叠加 agent overlay（sync-domain-template）"
bash "$TARGET/scripts/sync-domain-template.sh" --source "$SOURCE" --target "$TARGET" --commit

# 5) 装领域版 project-check.yml（boundary check 仅在领域 sync commit 时 clone L2 校验）
mkdir -p "$TARGET/.github/workflows"
cat > "$TARGET/.github/workflows/project-check.yml" <<'EOF'
name: Project Check

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  project-check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Check whitespace
        shell: bash
        run: |
          if [[ "${{ github.event_name }}" == "pull_request" ]]; then
            git diff --check "${{ github.event.pull_request.base.sha }}" "${{ github.event.pull_request.head.sha }}"
          elif [[ "${{ github.event.before }}" =~ ^0+$ ]]; then
            git diff-tree --check --no-commit-id --root -r "${{ github.sha }}"
          else
            git diff --check "${{ github.event.before }}" "${{ github.sha }}"
          fi

      - name: Check project version consistency
        shell: bash
        run: |
          version="$(tr -d '\r\n[:space:]' < VERSION)"
          if [[ ! "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "VERSION must use vMAJOR.MINOR.PATCH, got: ${version:-<empty>}" >&2
            exit 1
          fi
          first="$(grep -E '^## v[0-9]+\.[0-9]+\.[0-9]+（' CHANGELOG.md | head -n 1 | sed -E 's/^## (v[0-9]+\.[0-9]+\.[0-9]+).*/\1/')"
          if [[ -z "$first" ]]; then
            echo "CHANGELOG.md must start with a ## vMAJOR.MINOR.PATCH（...） heading" >&2
            exit 1
          fi
          if [[ "$first" != "$version" ]]; then
            echo "CHANGELOG latest $first does not match VERSION $version" >&2
            exit 1
          fi

      - name: Check domain sync boundary
        shell: bash
        run: |
          subject="$(git log -1 --format=%s)"
          if [[ "$subject" =~ ^sync[[:space:]]agent[[:space:]]domain[[:space:]]template[[:space:]]v[0-9]+\.[0-9]+\.[0-9]+[[:space:]]from[[:space:]]agent-system-template ]]; then
            repo="$(grep -E '^- Domain template repository:' TEMPLATE-BASE.md | head -1 | sed -E 's/.*github\.com[\/:]([^\/"]+\/[^\/"]+).*/\1/')"
            if [[ -z "$repo" || "$repo" == *"<owner>"* ]]; then
              echo "skip: domain template repository not set in TEMPLATE-BASE.md"
            else
              git clone --depth 1 "https://github.com/$repo.git" /tmp/l2
              bash scripts/check-domain-derived-sync.sh --source /tmp/l2 --target . --advisory
            fi
          else
            echo "Not a domain sync commit; skip boundary check."
          fi
EOF

# 6) git init + 首提交
DEFAULT_GIT_NAME="${GIT_AUTHOR_NAME:-Codex Local Init}"
DEFAULT_GIT_EMAIL="${GIT_AUTHOR_EMAIL:-codex-local-init@example.invalid}"

cd "$TARGET"
git init -b main >/dev/null 2>&1 || { git init >/dev/null 2>&1; git symbolic-ref HEAD refs/heads/main 2>/dev/null || true; }
git add -A
if git config user.name >/dev/null 2>&1 && git config user.email >/dev/null 2>&1; then
  git commit -q -m "init: $BASE (derived from agent-system-template)"
else
  echo "==> 未检测到 Git 身份，使用临时本地提交身份完成初始化"
  git -c user.name="$DEFAULT_GIT_NAME" -c user.email="$DEFAULT_GIT_EMAIL" \
    commit -q -m "init: $BASE (derived from agent-system-template)"
fi

if [[ "$NO_REMOTE" -eq 1 ]]; then
  echo "==> 跳过远端建库与推送（--no-remote）"
else
  if [[ -z "$ACCOUNT" ]]; then
    ACCOUNT="$(gh api user --jq .login 2>/dev/null || true)"
  fi
  if [[ -z "$ACCOUNT" ]]; then
    echo "未获取到 GitHub 账号。已本地完成初始化；建远端请先 gh auth login 或传 --account。" >&2
  else
    ACTIVE="$(gh api user --jq .login 2>/dev/null || true)"
    if [[ -n "$ACTIVE" && "$ACTIVE" != "$ACCOUNT" ]]; then
      echo "==> 切换 gh 活跃账号: $ACTIVE -> $ACCOUNT"
      gh auth switch -u "$ACCOUNT" 2>/dev/null || true
    fi
    gh repo create "$ACCOUNT/$BASE" "--$VISIBILITY" --source=. --remote=origin --push \
      --description "Agent project derived from agent-system-template"
  fi
fi

echo
if [[ "$NO_REMOTE" -eq 1 || -z "${ACCOUNT:-}" ]]; then
  echo "==> 完成（本地-only）：$TARGET"
else
  echo "==> 完成：$ACCOUNT/$BASE"
fi
echo "后续："
echo "  cd \"$TARGET\""
echo "  初填 ai/project-rules.md 与 docs/design/agent-*.md；按 template-docs/agent-system/domain-derived-scenarios.md §5 走自检："
echo "    bash scripts/check-domain-derived-sync.sh --source <agent-system-template> --target . --advisory"
echo "    bash scripts/check-agent-template.sh --target ."
