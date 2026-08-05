# 领域模板提案区

> 层归属：L2 领域自有（不在 `template-sync.json`，母模板同步不覆盖）。本目录由 `agent-system-template` 领域模板维护。
> 约定来源：buildout 提案 §4.5 G4（上行回流分层路由）+ `template-docs/domain-templates.md` §4（两级回流）。

本目录是 `agent-system-template` 领域模板的**提案收件箱**。提案为**草案 · 待维护者确认**，非既成事实；不得写入业务需求、客户敏感数据或无法提交到仓库的隐私事实。

## 提案两组（按去向）

| 组 | 来源 | 去向 | 机制 |
|---|---|---|---|
| **A · 领域级（本仓库落地）** | ① 领域模板自身主动修改；② 领域派生项目往领域模板回流（issue） | 停在 L2，由领域模板实现 | 领域收件箱：本地文件 + 派生 issue 本地镜像；① 与 ② 视作**一组** |
| **B · 待上行跨领域（回流母模板）** | A 组中沉淀后判定跨领域通用的经验 | 上行 L1，回流母模板 | **原来的方式**：先存本地提案，再 `submit-proposal` 回流母模板 issue 仓 |

路由规则：**领域专属停在 L2；只有跨领域通用才上行 L1**（见 `template-docs/domain-templates.md` §4 两级回流）。

## 机制（镜像母模板）

- 母模板 `ai-project-template` 的 `_proposals/` 已是完整提案收件箱（GitHub issue 收件、`_remote-issues/` 本地镜像硬门禁、`template-proposal-summary` 汇总）。
- 本领域模板**镜像同一机制**：派生项目往领域模板回流，用 `submit-proposal` / `submit-feedback` 指向**本仓库**（与回流母模板同命令、不同目标仓）；远端 issue 正文先镜像到 `_proposals/_remote-issues/` 再分析（硬门禁，不得直接基于未落盘正文做去重 / 冲突 / 分批分析）。
- 当前以本地文件提案为主；issue 收件与镜像机制按需启用（真实 agent 项目增多、回流频率上升后）。

## 命名与结构

```text
TEMPLATE-UPGRADE-<slug>.md        # 提案主体：背景、目标、非目标、架构、分批、验收、待确认项
TEMPLATE-UPGRADE-<slug>-patch.md  # 可选：具体 old→new 修改建议
analysis-<slug>.md                # 可选：前置分析 / 评估报告
```

提案头部建议声明 `状态`、`目标版本`、`Release impact`、`Release strategy`、`仓库角色`，让版本判断前置化（与母模板 `_proposals/README.md` 口径一致）。

## 归档

提案合并并下行同步（或在本仓库落地）后，移动到 `_archive/proposals/`（已启用；归档标准与索引见 `_archive/proposals/README.md`），避免作为待办重复执行。回流母模板的提案在母模板 PR 合并（或母模板已等价落地 + issue 关闭）后归档。归档不删原内容，在每个提案 H1 下补归档批注（落地证据 + 残留待办指引）；活跃待办转 `_proposals/_archive-followups.md`，避免被归档埋没。
