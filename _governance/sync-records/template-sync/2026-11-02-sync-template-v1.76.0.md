# Template Sync Record: agent-system-template to v1.76.0

## 基本信息

- 项目：`agent-system-template`（L2 领域模板）
- 同步日期：2026-11-02
- 同步前模板版本：v1.75.0（2026-09-10 同步）
- 目标模板版本：v1.76.0（上游 2026-11-01 发布，跨 v1.75.2 / v1.75.4 / v1.75.5 / v1.75.6 / v1.75.7 / v1.75.8 / v1.76.0 七个版本）
- 项目 / 领域模板自身版本（`VERSION`）：v0.5.0（保留）
- 继承版本记录（`TEMPLATE-BASE.md`）：存在；Lineage type：domain template；当前同步到：v1.76.0
- 同步分支：`chore/sync-template-v1.76.0`
- 实际同步提交（squash 合并后 main）：`b3f014f`（PR #26；分支内同步提交 `116f0ee`，bootstrap 提交 `1d757dc`）
- 操作入口：`/run sync-methodology`（自然语言「同步模板」）
- AI 工具 / CLI：Claude Code

## 执行命令

- dry-run：`powershell -NoProfile -File scripts/sync-template.ps1 --dry-run`（输出重定向 `.tmp/sync-dry-run-v1.76.0.log`）
- commit：`powershell -NoProfile -File scripts/sync-template.ps1 --commit`
- 版本保留标志：`--domain-template`（由领域版 `TEMPLATE-BASE.md` 自动启用，未显式传参）
- check-derived-sync：`powershell -NoProfile -File scripts/check-derived-sync.ps1 116f0ee`（对纯同步提交校验；squash 合并后 main `b3f014f` 由 project-check CI 复验通过）
- 是否触发 PowerShell fallback：否
- post-sync-cleanup：轻量执行（见下）
- docs-system-audit（同步后审计）：轻量执行（见下）
- 项目验证：本仓无运行型测试入口变更；验证以 check-derived-sync + project-check CI 为准

### 命令真实性记录

| 步骤 | 实际命令 / 动作 | 退出结果 | 是否完整执行 | 是否等价替代 | 备注 |
|---|---|---|---|---|---|
| 预检 A/B 两阶段 | git status / VERSION / TEMPLATE-BASE / 脚本存在性探测 | 全 pass | 是 | 否 | 本地 main「ahead 4」为过时跟踪引用，push 时 up-to-date |
| 首次 dry-run | `--dry-run`（本地 v1.75.0 脚本） | EXIT=1 | 是 | 否 | 预期路径：脚本落后于远端，按提示 bootstrap |
| bootstrap | `git checkout FETCH_HEAD -- scripts/sync-template.sh` + commit | `1d757dc`（1 处差异） | 是 | 否 | |
| dry-run（重跑） | `--dry-run` | EXIT=0；33 delta | 是 | 否 | 禁触路径 grep 零命中；领域版本机制确认 |
| commit / 同步 | `--commit` | EXIT=0；`116f0ee` | 是 | 否 | |
| check-derived-sync | `check-derived-sync.ps1 116f0ee` | EXIT=0 ✅ | 是 | 否 | |
| push + PR + CI | `git push` / `gh pr create` / `gh pr checks` | PR #26；project-check pass | 是 | 否 | squash 合并 `b3f014f`，subject 含 ` (#26)` 容忍后缀 |
| post-sync-cleanup | 根目录 + workflow 只读审计 | 3 项发现（见下） | 轻量执行 | 否 | 未移动 / 删除任何文件 |
| docs-system-audit | docs/00-09 scaffold 口径核对 | 无规范基线缺口 | 轻量执行 | 否 | 本仓 docs/00-09 为 L3 scaffold |

## A13 完成判据矩阵

| A13 步骤 | 证据 | 状态 | 若非完成，原因 | 下一步 |
|---|---|---|---|---|
| 标准闭环计划 | 预检表 + 闭环计划 + 用户确认（C-1/C-2） | 完成 | | |
| dry-run 预览 | dry-run log + grep 摘要（33 delta，零越界） | 完成 | | |
| commit + 边界验证 | `116f0ee` + check-derived-sync EXIT=0 + PR #26 CI pass | 完成 | | |
| post-sync-cleanup | 根目录 / workflow 只读审计，摘要见下 | 轻量执行 | 3 项遗留处置待用户确认 | 见「同步后整理摘要」 |
| docs-system-audit | docs/00-09 为 L3 scaffold，口径核对通过 | 轻量执行 | 本仓无 L3 项目事实，完整 PLM 审计不适用 | 待真实 L3 派生项目验证 |
| 提案回流收口 | issue #463 CLOSED + 母模板 v1.75.2 采纳实证 + 归档完成 | 完成 | | 决策矩阵见下 |
| 同步报告留痕 | 本文件 | 完成 | | |

> 本轮 post-sync-cleanup 与 docs-system-audit 为轻量执行：**同步主链 + 提案收口 + 报告留痕完成，A13 闭环尚有轻量项**（3 项遗留处置待确认）。

## 同步结果

- 是否成功：是
- 新增 / 修改的方法论文件：33 个 delta（31 个清单内方法论文件 + `TEMPLATE-BASE.md` + 2 个 `upstream/` changelog 参考）；其中 `ai/review-guide.md` 为**新增**（v1.76.0 评审总纲）
- `VERSION` / `CHANGELOG.md` / `CHANGELOG-PLAIN.md` 是否保持领域模板自身版本：是（v0.5.0 保留，未被触碰）
- `TEMPLATE-BASE.md` 是否更新继承模板版本：更新为 v1.76.0（领域版，`Domain standards scope` 保留）
- 项目专属文件是否被误改：否（33 文件全部在 `files_all ∪ files_domain`；根 `README.md`、`ai/project-rules.md`、`ai/domain-rules.md`、`docs/00-09`、`domain/*`、`project/*` 零触碰）
- 是否新增 / 刷新 `ai/doc-standards/`：是（`08-dev-plan.md`、`project-rules.md` 规范基线刷新）
- 是否残留旧 `docs/_scaffold/`：否
- workflow：`.github/workflows/project-check.yml` 已是派生版，无需迁移

### 上游 v1.75.2–v1.76.0 对本仓的要点

- v1.75.2：**本仓回流提案采纳落地**（issue #463 容器审计项，详见提案回流收口节）。
- v1.75.4：Sprint 完成包版本回写挂钩（implementation-lifecycle §7.1 补 CHANGELOG / VERSION 回写）。
- v1.75.5：**同步 PR 边界新规**——同步 PR 只含同步提交，收尾件拆到合并后执行（本轮首次按此执行）。
- v1.75.6：治理机制解耦 Phase 1（capability-packages 机制登记表 + 域间交接契约 + 新机制准入四问）。
- v1.75.7：12-sync-template A13 矩阵补母仓 registry 回写项；prompt 11 补提案先期状态核实。
- v1.75.8：SOP 类文档 56 处 `-ExecutionPolicy Bypass` → `-NoProfile`（无 bypass 优先，被拦再降级）——本轮实操已实证其必要性（见「遇到的问题」）。
- v1.76.0（MINOR）：新增 `ai/review-guide.md` 评审总纲（E1-E6 触发矩阵）+ document-lifecycle §13 图表评审清单 + 各 prompt 评审轻挂钩。

## 同步后整理摘要（轻量执行）

- 是否执行 `/run post-sync-cleanup`：轻量执行（只读审计）
- 审计发现（3 项，均为未跟踪 / 本地遗留，不影响同步边界）：
  1. 根级 `_examples/single-agent-demo/`：Batch C（PR #25）已将 demo 迁至 `_governance/_examples/` 与 `project/`，本目录为**未跟踪本地遗留**（剩余内容均为 gitignored 产物：`__pycache__` 等）。AI 建议：本地删除。
  2. 根级 `ai-records/token-hotspots/`：2 个 2026-07-27 旧观察记录（gitignored）。母模板 v1.67.0 容器口径后入库位为 `_governance/ai-records/`，本地观察位为 `.ai/token-hotspots/`。AI 建议：确认已被 SUMMARY 覆盖后删除；未覆盖则移入 `.ai/token-hotspots/` 保留。
  3. 根级 `.agents/`：空目录，AI CLI 工具运行残留；不在 `ai/global-rules.md` §5 点目录准入清单。AI 建议：本地删除。
- 处置状态：**待用户确认后执行**（本记录先留痕，不擅自删除）
- `ai/project-rules.md` / README 是否需整理：`ai/project-rules.md` §0 继承版本引用待人工核对（同步不动该文件，v1.75.0 → v1.76.0 引用更新属项目件自维护）

## 文档体系审计摘要（轻量执行）

- 是否执行 `/run docs-system-audit` 同步后审计模式：轻量执行
- 规范基线缺口：无新增（`ai/doc-standards/` 已随同步刷新至 v1.76.0）
- 可接受兼容差异：本仓 `docs/00-09` 为 L3 scaffold 占位，非 L2 项目事实，不按新规范回梳
- 项目事实风险：无（同步未触碰项目事实文档）
- 新增机制消化提醒：`ai/review-guide.md` 评审触发矩阵对 L2 维护任务的适用点（同步后审计、Phase 收口）已在本轮收尾流程中体现；L3 侧适用待真实派生项目

## 项目验证建议

- 已执行验证：check-derived-sync EXIT=0；PR #26 project-check pass（含合并后边界校验）
- 未验证项与原因：L2→L3 下行同步未实测（当前无活跃 L3 派生项目）；`new-domain-project.*` 端到端实跑仍待首个真实 L3（承接 v1.75.0 记录遗留）

## 遇到的问题

- **权限管控拦截 `-ExecutionPolicy Bypass`**：按本地 v1.75.0 版 SOP 示例命令首次重跑 dry-run 被 Claude Code 权限分类器拦截（Safety Bypass Flag）；改用 `powershell -NoProfile -File ...` 后通过。与 v1.75.8 上游新 SOP（无 bypass 优先）口径一致，属环境 × 旧文档组合坑，已随本同步消除；未同步到 v1.75.8 的派生仓仍会在 SOP 中看到 Bypass 示例。已记本地 pitfall 观察。
- 本地 main「ahead 4」假象：过时跟踪引用，push 时 `Everything up-to-date`，非真实未推送。
- 首次 dry-run EXIT=1：本地 `scripts/sync-template.sh` 落后（v1.75.0 → v1.76.0 间上游改过脚本），脚本按设计停止并提示 bootstrap；bootstrap 后重跑通过。预期路径，非缺陷。
- 网络 / 代理：直连正常，未配置代理。

## 可优化点归纳

| 问题 | 是否项目专属 | 是否建议回流模板 | 建议提案 |
|---|---|---|---|
| SOP 示例命令 bypass 坑（已由 v1.75.8 上游修复） | 否 | 否（已修复，本条为实证留档） | 已记 pitfall |
| 根目录遗留审计三项（`_examples` / `ai-records` / `.agents`） | 是（本仓本地遗留） | 否 | 本记录待确认项，用户确认后处置 |
| 无其他新增可回流点 | — | — | 本次无模板回流提案 |

## 已生成的回流提案

- 本次无模板回流提案。

## 提案回流收口

- 扫描范围：`_governance/_proposals/`（4 项）、`_governance/_archive/proposals/`（9 项）、最近 `sync-records/template-sync/` 记录
- 归档执行：`TEMPLATE-UPGRADE-post-sync-cleanup-container-audit.md` → 已移动至 `_governance/_archive/proposals/`（采纳实证：母模板 v1.75.2，issue #463 2026-09-16 CLOSED；本仓 v1.76.0 同步已取得对应版本）；`_archive/proposals/README.md` 已补登记行
- 仍保留 `_governance/_proposals/`：`TEMPLATE-UPGRADE-agent-template-buildout.md`（总纲，D6 / Batch 4 开放项，明示保留原位）、`analysis-agent-template-architecture.md`（前置分析）、`_archive-followups.md`、`README.md`

### 提案决策矩阵

| 本地提案 | 模板 issue / PR | 远端状态 | 关闭原因 / 处理结果 | 本地动作建议 |
|---|---|---|---|---|
| post-sync-cleanup-container-audit | issue #463 | CLOSED（2026-09-16） | 母模板 v1.75.2 聚合 PATCH 采纳落地，本次同步已取得 | **已归档** |
| agent-template-buildout（总纲） | 无（未开 issue） | 不适用 | 主体已落地；D6（CI 接入）/ Batch 4（profile 回流 SOP）开放，Batch 4 需按 v1.75.0 三层布局新口径评估 | 保留原位 |
| analysis-agent-template-architecture | 无 | 不适用 | buildout 前置分析，随总纲保留 | 保留 |
| _archive-followups | 无 | 不适用 | 活跃尾巴登记位（命令入口 / CI 接入，待 ≥2 真实 L3） | 保留 |

## 后续动作

- 遗留处置（3 项，待确认）：见「同步后整理摘要」
- 是否需要 `/run docs-system-audit` 完整模式：否（待真实 L3）
- 是否需要同步回模板仓库：本次无回流提案
- push / PR / CI / 合并：PR #26 已合并（squash `b3f014f`）；本收尾记录以合并后 main 直接提交（v1.75.5 边界新规允许的合并后后续提交）
