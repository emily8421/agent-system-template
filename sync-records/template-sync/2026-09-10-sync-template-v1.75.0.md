# Template Sync Record: agent-system-template to v1.75.0

## 基本信息

- 项目：`agent-system-template`（L2 领域模板）
- 同步日期：2026-09-10
- 同步前模板版本：v1.71.0（2026-08-28 同步）
- 目标模板版本：v1.75.0（上游 2026-09-10 发布，跨 v1.72.0 / v1.72.1 / v1.72.2 / v1.73.0 / v1.74.0 / v1.75.0 六个版本）
- 项目 / 领域模板自身版本（`VERSION`）：v0.4.2（保留）
- 继承版本记录（`TEMPLATE-BASE.md`）：存在；Lineage type：domain template；当前同步到：v1.75.0
- 同步分支：`chore/sync-template-v1.75.0`
- 实际同步提交（非 PR merge commit）：`c1633e3`（bootstrap 提交：`c5db91a`）
- 操作入口：`/run sync-methodology`（自然语言「同步最新模板方法论」）
- AI 工具 / CLI：Claude Code

## 执行命令

- dry-run：`powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --dry-run`（输出重定向 `sync.log`）
- commit：`powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --commit`
- 版本保留标志：`--domain-template`（由领域版 `TEMPLATE-BASE.md` 自动启用，未显式传参）
- check-derived-sync：`powershell -ExecutionPolicy Bypass -File scripts/check-derived-sync.ps1 HEAD`
- 是否触发 PowerShell fallback（sync / check）：否（直接以 PowerShell 入口运行，无 Git Bash 探测故障）
- post-sync-cleanup：轻量执行（见下）
- docs-system-audit（同步后审计）：轻量执行（见下）
- 项目验证建议 / 已执行验证：已执行 `scripts/check-agent-template.ps1`（EXIT=0，15 条 advisory 发现，非阻断）

### 命令真实性记录

| 步骤 | 实际命令 / 动作 | 退出结果 | 是否完整执行 | 是否等价替代 | 是否生成独立报告 | 备注 |
|---|---|---|---|---|---|---|
| dry-run 预览 | `sync-template.ps1 --dry-run`（log 落盘 + grep 摘要） | EXIT=0；26 delta / 0 skip / 128 no-diff | 是 | 否 | 不适用 | 禁触路径 grep 零命中；dry-run 后无 staged 残留 |
| bootstrap | `git checkout FETCH_HEAD -- scripts/sync-template.{ps1,sh}` + commit | `c5db91a` | 是 | 否 | 不适用 | v1.72.2 改了同步脚本，预期需要 |
| commit / 同步 | `sync-template.ps1 --commit` | EXIT=0；`c1633e3` | 是 | 否 | 不适用 | 领域版本治理自动启用 |
| check-derived-sync | `check-derived-sync.ps1 HEAD` | EXIT=0；26 文件全部合规 | 是 | 否 | 不适用 | 领域 lineage 识别正确 |
| post-sync-cleanup | workflow / 治理目录 / 遗留内容审计 | 只读抽查通过 | 轻量执行 | 否 | 否 | 结果记入本记录 |
| docs-system-audit | docs/00-09 scaffold 口径核对 | 只读抽查 | 轻量执行 | 否 | 否 | 本仓 docs/00-09 为 L3 scaffold |
| 项目验证 | `check-agent-template.ps1` | EXIT=0；15 findings（advisory） | 是 | 否 | 不适用 | advisory 非门禁，未升级为 gate |

## A13 完成判据矩阵

| A13 步骤 | 证据 | 状态 | 若非完成，原因 | 下一步 |
|---|---|---|---|---|
| 标准闭环计划 | 预检表 + 计划表 + 用户确认「执行完整同步」 | 完成 | | |
| dry-run 预览 | `sync.log` + grep 摘要（26 delta，零越界） | 完成 | | |
| commit + 边界验证 | `c1633e3` + `check-derived-sync.ps1 HEAD` 通过 | 完成 | | |
| post-sync-cleanup | workflow / 治理目录 / 遗留内容只读审计，见下文摘要 | 轻量执行 | 存量 L1 治理遗留（`MAINTAINERS.md` 等）与 v1.75.0 Batch C 迁移绑定，须单独 L2 决策，不在本轮混入 | Batch C 迁移单列任务 |
| docs-system-audit | docs/00-09 为 L3 scaffold，规范基线镜像已刷新 | 轻量执行 | 本仓无 L3 项目事实，完整 PLM 审计不适用 | 待真实 L3 派生项目验证 |
| 提案回流收口 | `_proposals/` 3 文件复核 + followups §3 实证更新 | 完成 | | 决策矩阵见下 |
| 同步报告留痕 | 本文件 | 完成 | | |

> 本轮 post-sync-cleanup 与 docs-system-audit 为轻量执行：**同步主链 + 提案收口 + 报告留痕完成，A13 闭环尚有轻量项**，补完路径见「后续动作」。

## 同步结果

- 是否成功：是
- 新增 / 修改的方法论文件：26 个 delta（25 个清单内方法论 / 清单文件 + `TEMPLATE-BASE.md` + 2 个 `upstream/` changelog 参考，合计 26）；其中 `ai/doc-standards/stage-exit-baseline.md` 为**新增**（v1.73.0 准出判据基准）
- `VERSION` / `CHANGELOG.md` 是否保持项目 / 领域模板自身版本：是（v0.4.2 保留，未被触碰）
- `TEMPLATE-BASE.md` 是否新增 / 更新继承模板版本：更新为 v1.75.0（领域版，`Domain standards scope` 保留）
- 项目专属文件是否被误改：否（`check-derived-sync` 26 文件全部在 `files_all ∪ files_domain`；根 `README.md`、`ai/project-rules.md`、`ai/domain-rules.md`、`docs/00-09`、根级 `frontend/backend/docker/tests` 零触碰）
- 是否新增 / 刷新 `ai/doc-standards/`：是（`stage-exit-baseline.md` 新增；`03-prd.md`、`domain-rules.md` 刷新）
- 是否残留旧 `docs/_scaffold/`：否

### 上游 v1.72–v1.75 对本仓的要点

- v1.72.0：`rules-core` §2 沙箱 / spawn 失败分流规则（本仓规则文本已随同步更新）。
- v1.72.2：同步脚本 CHANGELOG-PLAIN 双版本结构误报修复（本轮 bootstrap 已取得新脚本；本轮 commit 无改写误报，验证生效）。
- v1.73.0：路由表章节级标注、`implementation-lifecycle-rules` §4.1 任务卡执行记录、新增 `stage-exit-baseline.md` 规范基线。
- v1.74.0：ui-knowledge / web-fullstack profile 文档增量（对本仓为纯文档）。
- v1.75.0：**三层布局模式定型**——L2 根级 `domain/` 保留名、剧本路径收敛至 `domain/scenarios.md`、`check-derived-sync` 保护清单补 `domain/*`；**存量 `agent-system-template` 按 Batch C 另行迁移**（上游 changelog 明示，本轮同步只取得机制件与新口径，不做本仓结构迁移）。

## 同步后整理摘要

- 是否执行 `/run post-sync-cleanup`：轻量执行（只读审计，未移动 / 删除任何文件）
- README / `ai/project-rules.md` / docs 分区是否需整理：`ai/project-rules.md` §0 继承版本引用已同步更新 v1.71.0 → v1.75.0；其余无需
- 已处理项：workflow 检查（`.github/workflows/project-check.yml` 已是项目版，无需迁移）；`_archive/proposals/` 均为本仓自有归档，无母仓残留误判
- 待确认项：根级 `MAINTAINERS.md` 等存量 L1 治理遗留（v1.70.0 起不下行、属历史残留）——与 Batch C 迁移一并决策，本轮保留
- 建议回写 / 后续迁移任务：Batch C 迁移（见「后续动作」）

## 文档体系审计摘要

- 是否执行 `/run docs-system-audit` 同步后审计模式：轻量执行
- 规范基线缺口：无新增（`ai/doc-standards/` 镜像已随同步刷新至 v1.75.0，共 17 件）
- 可接受兼容差异：本仓 `docs/00-09` 为 L3 scaffold 占位，非 L2 项目事实，不按新规范回梳
- 项目事实风险：无（同步未触碰项目事实文档）
- 回梳计划摘要：待首个真实 L3 agent 派生项目验证时再按新基线审计

## 项目验证建议

- 建议运行的测试 / lint / 文档检查 / 人工验收：`scripts/check-agent-template.ps1`（L2 领域自检）；如有 L3 派生项目，跑 `check-domain-derived-sync.*`
- 已执行验证与结果：`check-agent-template.ps1` EXIT=0，15 条 advisory 发现（含 `agent-eval-plan.md` overlay 缺失、`agent-standard-mapping.md` 缺失两条 WARN，均为存量 advisory 观察项，非本轮引入、非门禁）
- 未验证项与原因：L2→L3 下行同步未实测（当前无活跃 L3 派生项目同步请求）

## 遇到的问题

- Git / gh / Git Bash / PowerShell / 网络问题：仅 git CRLF warning（非失败，§5.8 口径）；网络直连正常，未配置代理
- 同步脚本问题：无
- Prompt / 快捷命令理解问题：无
- 文档说明不清：无
- 派生项目专属冲突：无

## 可优化点归纳

| 问题 | 是否项目专属 | 是否建议回流模板 | 建议提案 |
|---|---|---|---|
| Batch C 迁移（`domain-overlay/` → 根 `domain/`、剧本路径收敛）需本仓自行排期 | 是（L2 自有） | 否（上游已定机制，迁移属本仓执行） | 单列 L2 迁移任务 |
| followups §3 母模板 wrapper PS5.1 stderr 陷阱，本轮实证未命中 | 部分 | 暂不回流（证据仅覆盖 CRLF warning 类 stderr） | 保留观察，见决策矩阵 |

## 已生成的回流提案

- 本次无模板回流提案。

## 提案回流收口

- 扫描范围：`_proposals/`（3 文件）、`_proposals/_archive-followups.md`、最近 `sync-records/template-sync/` 记录
- 已确认被模板采纳或已有决议的提案：无新增（本仓提案均为 L2 自有，未开上游 issue）
- 已归档到 `_archive/proposals/` 的本地提案：无变动（8 件存量归档维持）
- 仍需保留在 `_proposals/` 的提案：`TEMPLATE-UPGRADE-agent-template-buildout.md`（总纲，含 D6 / Batch 4 开放项，明确保留原位）、`analysis-agent-template-architecture.md`（前置分析）、`_archive-followups.md`
- 无法判断是否已处理的 issue / 提案与待确认项：无

| 本地提案 | 模板 issue / PR | 远端状态 | 关闭原因 / 处理结果 | 本地动作建议 |
|---|---|---|---|---|
| buildout 总纲 | 无（未开 issue） | 不适用 | 主体已落地，D6 / Batch 4 开放 | 保留；Batch 4 评估时纳入 v1.75.0 三层布局新口径 |
| followups §3（母模板 wrapper PS5.1 stderr） | 无（条件性观察项） | 不适用 | 2026-09-10 实证：PS 5.1 下带 CRLF stderr 警告同步跑通（EXIT=0），未命中中断陷阱 | 更新评估为「本机实证未命中」；暂不回流，保留观察 |
| followups §1 / §2（new-domain-project 后置项 / overlay 彻底清晰） | 无 | 不适用 | 低优先，待 ≥2 真实 L3 项目 / Batch C | 保留 |

## 后续动作

- 是否需要 `/run post-sync-cleanup`：本轮已轻量执行；完整整理与 Batch C 迁移绑定
- 是否需要 `/run docs-system-audit`：待真实 L3 派生项目
- 是否需要按审计结果回梳 `docs/00-09` / `docs/design` / `docs/env`：否（L3 scaffold）
- 是否需要补项目验证入口：否
- 是否需要人工清理旧目录：Batch C 迁移时一并处理（`MAINTAINERS.md` 历史残留、`domain-overlay/` → `domain/`、剧本路径 `template-docs/agent-system/domain-derived-scenarios.md` → `domain/scenarios.md`）
- 是否需要同步回模板仓库：本次无回流提案
- push / PR / CI / 合并：见 PR 链接（本记录提交后创建）
