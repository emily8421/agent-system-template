<#
new-domain-project.ps1 - 从 agent-system-template（L2）派生 agent 领域派生项目（L3）。

单源锚定 L2：从 L2 整仓派生通用方法论 + agent overlay，写领域派生身份，
剥离所有 L1 同步入口（sync-template / check-derived-sync / check-template / new-project），
叠加 agent overlay，装领域 check workflow，git init。L3 只从 L2 同步，不直连 L1。

用法:
  powershell -ExecutionPolicy Bypass -File scripts/new-domain-project.ps1 <项目名> [-Source <agent-system-template>] [-Account <login>] [-Visibility private|public] [-NoRemote]
    <项目名>        新项目目录名（相对当前目录或绝对路径），默认也是 GitHub 仓库名
    -Source         领域模板源目录（默认 = 脚本所在仓库根；需确保 git 干净 / 最新）
    -Account        建仓库的 GitHub 账号（默认取当前 gh 登录账号）
    -Visibility     private（默认）或 public
    -NoRemote       只本地，不建 GitHub 仓库、不推送

依赖: git（本地派生）；建远端需 gh（目标账号已登录）。Windows PowerShell 5.1 兼容。
配套: template-docs/agent-system/domain-derived-scenarios.md §3（创建流程）。
#>
param(
  [Parameter(Position = 0)]
  [string]$Name = "",
  [string]$Source = "",
  [string]$Account = "",
  [ValidateSet("private", "public")]
  [string]$Visibility = "private",
  [switch]$NoRemote
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Name)) {
  Write-Error "用法: powershell -ExecutionPolicy Bypass -File scripts/new-domain-project.ps1 <项目名> [-Source ..] [-Account ..] [-Visibility private|public] [-NoRemote]"
  exit 1
}

# 目标路径
$Target = $Name
if (-not [System.IO.Path]::IsPathRooted($Target)) { $Target = Join-Path (Get-Location) $Target }
$Target = [System.IO.Path]::GetFullPath($Target).TrimEnd('\', '/')
if (Test-Path -LiteralPath $Target) { Write-Error "目标已存在: $Target"; exit 1 }
$Base = [System.IO.Path]::GetFileName($Target)
$null = New-Item -ItemType Directory -Path (Split-Path -Parent $Target) -Force

# 源（默认脚本所在仓根）
if ([string]::IsNullOrWhiteSpace($Source)) {
  $Source = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
  $Source = (Resolve-Path $Source).Path
}
foreach ($probe in @("VERSION", "domain-template-sync.json")) {
  if (-not (Test-Path -LiteralPath (Join-Path $Source $probe))) {
    Write-Error "Source 不是 agent-system-template 领域模板（缺 $probe）: $Source"
    exit 1
  }
}

# 读领域版本与经 L2 继承的母模板版本
$DomainVersion = (Get-Content -Raw -Encoding UTF8 (Join-Path $Source "VERSION")).Trim()
$BaseVersion = "unknown"
$templateBase = Join-Path $Source "TEMPLATE-BASE.md"
if (Test-Path -LiteralPath $templateBase) {
  foreach ($line in (Get-Content -Encoding UTF8 $templateBase)) {
    if ($line -match 'Current synced template version') {
      $m = [regex]::Match($line, 'v[0-9]+\.[0-9]+\.[0-9]+')
      if ($m.Success) { $BaseVersion = $m.Value }
    }
  }
}

# 解析 Source 的 GitHub owner/repo（写进 TEMPLATE-BASE，供 CI clone）
$RepoLabel = ""
$remoteUrl = & git -C $Source config --get remote.origin.url 2>$null
if ($remoteUrl) {
  $m = [regex]::Match($remoteUrl, 'github\.com[/:]([^/]+/[^/]+?)(\.git)?$')
  if ($m.Success) { $RepoLabel = "github.com/" + $m.Groups[1].Value }
}
if (-not $RepoLabel) { $RepoLabel = "github.com/<owner>/agent-system-template" }

$Today = Get-Date -Format "yyyy-MM-dd"
$utf8 = New-Object System.Text.UTF8Encoding($false)

Write-Host "==> 从 agent-system-template（L2）派生 agent 项目"
Write-Host "source: $Source ($DomainVersion; base via L2: $BaseVersion)"
Write-Host "target: $Target"
Write-Host ""

# 1) git archive L2 整仓 -> Target（拿通用方法论 + agent overlay 源）
$null = New-Item -ItemType Directory -Path $Target -Force
$zip = Join-Path ([System.IO.Path]::GetTempPath()) ("l2-archive-" + [guid]::NewGuid().ToString("N") + ".zip")
& git -C $Source archive --format=zip -o $zip HEAD
if ($LASTEXITCODE -ne 0) { Remove-Item $zip -Force -ErrorAction SilentlyContinue; Write-Error "git archive 失败"; exit 1 }
Expand-Archive -LiteralPath $zip -DestinationPath $Target -Force
Remove-Item $zip -Force

function Remove-TargetPath($rel) {
  $p = Join-Path $Target $rel
  if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force }
}
function Write-File($rel, $content) {
  $p = Join-Path $Target $rel
  $parent = Split-Path -Parent $p
  if ($parent -and -not (Test-Path $parent)) { $null = New-Item -ItemType Directory -Path $parent -Force }
  [System.IO.File]::WriteAllText($p, $content, $utf8)
}

# 2) 清理 L2 维护件 + 剥离所有 L1 同步入口（L3 单源锚定 L2，不挂 L1）
Write-Host "==> 剥离 L2 维护件与 L1 同步入口"
Remove-TargetPath "_examples"
Remove-TargetPath "_archive"
Remove-TargetPath "sync-records"
Remove-TargetPath "upstream"
Remove-TargetPath "domain-overlay"
$scriptsToDrop = @(
  "scripts/sync-template.ps1", "scripts/sync-template.sh",
  "scripts/check-template.ps1", "scripts/check-template.sh",
  "scripts/check-derived-sync.ps1", "scripts/check-derived-sync.sh",
  "scripts/new-project.sh",
  "scripts/sync-all-derived.sh",
  "scripts/new-domain-project.ps1", "scripts/new-domain-project.sh"
)
foreach ($s in $scriptsToDrop) { Remove-TargetPath $s }
Get-ChildItem -LiteralPath (Join-Path $Target ".github/workflows") -Filter *.yml -ErrorAction SilentlyContinue |
  Remove-Item -Force -ErrorAction SilentlyContinue
Remove-TargetPath "_proposals"
$null = New-Item -ItemType Directory -Path (Join-Path $Target "_proposals") -Force

# 3) 写领域派生身份文件
Write-Host "==> 写领域派生身份文件"
Write-File "VERSION" "v0.1.0`n"

Write-File "CHANGELOG.md" @"
# CHANGELOG

本文件记录本 agent 项目自身版本历史；继承的领域模板版本见 TEMPLATE-BASE.md。

## v0.1.0（$Today）

- 初始化 agent 项目，基于 agent-system-template $DomainVersion（母模板 $BaseVersion 经 L2 传递）派生。
"@

Write-File "CHANGELOG-PLAIN.md" @"
# CHANGELOG-PLAIN

本文件用大白话记录本 agent 项目自身每个版本改善了什么；继承的母模板版本见 TEMPLATE-BASE.md。

## v0.1.0（$Today）

初始化 agent 项目，基于 agent-system-template $DomainVersion 创建。后续这里只记本项目自己的演进，不记母模板 / 领域模板自身的版本历史。
"@

Write-File "TEMPLATE-BASE.md" @"
# Template Base

> Records the upstream lineage for this agent-derived project (L3). Single-source anchored to agent-system-template (L2); L1 base methodology is delivered through L2. Do not sync ai-project-template (L1) directly.

- Lineage type: agent derived project (L3)
- Domain template repository: $RepoLabel
- Domain template version: $DomainVersion
- Inherited base template version (via L2): $BaseVersion
- Domain standards scope: agent-system（架构 / 工具权限 / memory-state / trace-replay / HITL-safety / agent-eval）
- Project version file: VERSION
- Project version at creation: v0.1.0

## Version Semantics

- VERSION is owned by this agent project and records the project version.
- CHANGELOG.md and CHANGELOG-PLAIN.md are owned by this project; domain sync does not overwrite them.
- TEMPLATE-BASE.md records the inherited agent-system-template version and (via L2) the ai-project-template base version, for sync audit.
- L3 syncs ONLY from agent-system-template (L2); it must NOT sync ai-project-template (L1) directly.
- Domain sync commits keep the message format: sync agent domain template <L2-version> from agent-system-template.
"@

Write-File "README.md" @"
# $Base

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
"@

# ai/project-rules.md 重置为 L3 占位（覆盖 L2 自用版）
Write-File "ai/project-rules.md" @"
# 项目专属规则

> 本文件记录本 agent 派生项目（L3）自身约束。由 agent-system-template 派生时重置为占位；请按【撰写提要】填写。

## 0. 项目标识

- 项目名称：$Base（待确认）
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
"@

Write-File "_proposals/README.md" @'
# 提案起草区

本目录用于在本 agent 项目内临时起草可回流到 agent-system-template（L2 领域模板）的优化提案。

当开发过程中发现 agent 领域标准件、同步清单、自检或文档骨架的可通用改进时，在此新增：

```text
TEMPLATE-UPGRADE-<slug>.md
```

提案成熟后，回到 agent-system-template 仓库开 issue 或 PR 提交。跨领域通用经验由 L2 提炼后再回流母模板。
'@

# 4) 装领域版 project-check.yml（boundary check 仅在领域 sync commit 时 clone L2 校验）
$null = New-Item -ItemType Directory -Path (Join-Path $Target ".github/workflows") -Force
Write-File ".github/workflows/project-check.yml" @'
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
'@

# 6) git init + 首提交
Push-Location $Target
try {
  & git init -b main *> $null
  if ($LASTEXITCODE -ne 0) { & git init *> $null; & git symbolic-ref HEAD refs/heads/main 2>$null }
  & git add -A
  $msg = "init: $Base (derived from agent-system-template)"
  $hasId = ((& git config user.name) -and (& git config user.email))
  if ($hasId) {
    & git commit -q -m $msg
  } else {
    Write-Host "==> 未检测到 Git 身份，使用临时本地提交身份完成初始化"
    & git -c user.name="Codex Local Init" -c user.email="codex-local-init@example.invalid" commit -q -m $msg
  }

  # 5) 叠加 agent overlay（target 已是干净 git root；sync 复制 overlay 并产生 'sync agent domain template' commit）
  $syncScript = Join-Path $Target "scripts/sync-domain-template.ps1"
  Write-Host "==> 叠加 agent overlay（sync-domain-template）"
  & powershell -ExecutionPolicy Bypass -File $syncScript -Source $Source -Target $Target -Commit
  if ($LASTEXITCODE -ne 0) { Write-Error "sync-domain-template 失败"; exit 1 }

  if ($NoRemote) {
    Write-Host "==> 跳过远端建库与推送（-NoRemote）"
  } else {
    if ([string]::IsNullOrWhiteSpace($Account)) {
      $Account = (& gh api user --jq .login 2>$null)
    }
    if ([string]::IsNullOrWhiteSpace($Account)) {
      Write-Warning "未获取到 GitHub 账号。已本地完成初始化；建远端请先 gh auth login 或传 -Account。"
    } else {
      $active = & gh api user --jq .login 2>$null
      if ($active -and $active -ne $Account) {
        Write-Host "==> 切换 gh 活跃账号: $active -> $Account"
        & gh auth switch -u $Account 2>$null
      }
      & gh repo create "$Account/$Base" "--$Visibility" --source=. --remote=origin --push `
        --description "Agent project derived from agent-system-template"
    }
  }
} finally {
  Pop-Location
}

Write-Host ""
if ($NoRemote -or [string]::IsNullOrWhiteSpace($Account)) {
  Write-Host "==> 完成（本地-only）：$Target"
} else {
  Write-Host "==> 完成：$Account/$Base"
}
Write-Host "后续："
Write-Host "  cd `"$Target`""
Write-Host "  初填 ai/project-rules.md 与 docs/design/agent-*.md；按 template-docs/agent-system/domain-derived-scenarios.md §5 走自检："
Write-Host "    powershell -ExecutionPolicy Bypass -File scripts\check-domain-derived-sync.ps1 -Source <agent-system-template> -Target . -Advisory"
Write-Host "    powershell -ExecutionPolicy Bypass -File scripts\check-agent-template.ps1 -Target ."
