# 派生项目模板同步运行记录：v1.76.0 → v1.79.1

## 基本信息

- 项目：agent-system-template（L2 领域模板仓）
- 同步日期：2026-11-16
- 同步前模板版本：v1.76.0（TEMPLATE-BASE.md，2026-11-02 同步）
- 目标模板版本：v1.79.1（母模板远端 main 实读）
- 项目 / 领域模板自身版本（`VERSION`）：v0.5.0（保持不变）
- 继承版本记录（`TEMPLATE-BASE.md`）：存在；Lineage type：domain template；当前同步到：v1.79.1
- 同步分支：`chore/sync-template-v1.79.1`（已 squash 合并，PR #28）
- 实际同步提交（非 PR merge commit）：`2c60cd0`（父提交 `2d14533` 为 bootstrap 前置提交）
- 操作入口：`/run sync-methodology`（自然语言「同步模板」）
- AI 工具 / CLI：Claude Code

## 执行命令

- dry-run：`powershell -NoProfile -File scripts/sync-template.ps1 --dry-run`（首次 EXIT=1：本地 sync-template.sh 落后远端 4 行 → 按脚本提示 bootstrap 后重跑 EXIT=0）
- commit：`powershell -NoProfile -File scripts/sync-template.ps1 --commit --domain-template`
- 是否使用版本保留标志：`--domain-template`（领域模板；与 TEMPLATE-BASE.md Lineage type 一致）
- check-derived-sync：`powershell -NoProfile -File scripts/check-derived-sync.ps1 2c60cd0`（推送前对纯同步提交校验，**推送前权威留痕**）
- 是否触发 PowerShell fallback（sync / check）：否
- post-sync-cleanup：轻量执行（见下）
- docs-system-audit（同步后审计）：轻量执行（见下）
- 项目验证建议 / 已执行验证：check-derived-sync EXIT=0；本仓无测试 / lint 入口（文档 + 脚本仓，脚本本轮已实跑验证）；无其他可运行验证入口

### 命令真实性记录

| 步骤 | 实际命令 / 动作 | 退出结果 | 是否完整执行 | 是否等价替代 | 是否生成独立报告 | 备注 |
|---|---|---|---|---|---|---|
| dry-run 预览 | `sync-template.ps1 --dry-run`（bootstrap 后重跑） | EXIT=0，27 delta | 是 | 否 | 不适用 | 首跑 EXIT=1 属脚本体检防护（bootstrap 前置），非故障 |
| commit / 同步 | `sync-template.ps1 --commit --domain-template` | EXIT=0，提交 2c60cd0 | 是 | 否 | 不适用 | 27 文件与 dry-run 一致 |
| check-derived-sync | `check-derived-sync.ps1 2c60cd0` | EXIT=0，✅ 边界检查通过 | 是 | 否 | 不适用 | 推送前权威校验，本记录即为留痕 |
| post-sync-cleanup | 只读核验（workflow / 新增文件就位 / 可迁移项扫描） | 无结构迁移项 | 轻量执行 | 否 | 否（本记录摘要） | 本轮 delta 无结构迁移，完整命令无对象可处理 |
| docs-system-audit | 只读判定（docs/00-09 为 L3 scaffold 占位） | 无回梳对象 | 轻量执行 | 否 | 否（本记录摘要） | `docs/00-09` 非本仓业务事实（project-rules §3），规范基线变化影响面在 L3 派生项目 |
| 项目验证 | check-derived-sync（同上） | EXIT=0 | 是 | 否 | 不适用 | 脚本实跑即验证（dry-run / commit / check 全链） |

## A13 完成判据矩阵

| A13 步骤 | 证据 | 状态 | 若非完成，原因 | 下一步 |
|---|---|---|---|---|
| 标准闭环计划 | 计划输出 + 用户 AskUserQuestion 确认（2026-11-16） | 完成 |  |  |
| dry-run 预览 | EXIT=0 + 27 delta 边界 grep 摘要（禁止路径 / 版本机制零越界） | 完成 |  |  |
| commit + 边界验证 | 2c60cd0 + check-derived-sync EXIT=0（推送前留痕）+ 合并后 CI project-check pass | 完成 |  |  |
| post-sync-cleanup | 只读核验：无结构迁移项；workflow 仅 project-check.yml 无需迁移 | 轻量执行 | 无可处理对象（delta 无结构变更） | 无 |
| docs-system-audit | 只读判定：docs/00-09 为 L3 scaffold 占位无回梳对象；v1.79.0 规范基线影响面在 L3 | 轻量执行 | 无回梳对象 | L3 派生项目验证时对照新基线 |
| 提案回流收口 | 决策矩阵（见「提案回流收口」节）+ 归档已执行 | 完成 |  |  |
| 同步报告留痕 | 本文件 | 完成 |  |  |
| 母仓 registry 回写 | 未执行 | 部分完成 | 跨仓维护者动作，建议模板仓目录另起会话执行（session-rules §3.4 角色声明） | 合并后于模板仓补登 point-in-time 字段 |

> 状态语义：存在 `轻量执行` / `部分完成` 项 → 本次为「同步主链完成，A13 闭环尚有剩余项（registry 回写）」。

## 同步结果

- 是否成功：是（PR #28 squash 合并为 `982a7af sync template v1.79.1 from ai-project-template (#28)`，合并后 CI project-check pass）
- 新增 / 修改的方法论文件：27 个（见「同步跨度采用清单」与 PR #28 文件清单），其中新增 4 个：`template-docs/git-beginner-handbook.md`、`template-docs/stack-adapters/{README,fastapi-python,react-typescript}.md`
- `VERSION` / `CHANGELOG.md` 是否保持项目 / 领域模板自身版本：是（v0.5.0 未动，`--domain-template` 生效）
- `TEMPLATE-BASE.md` 是否新增 / 更新继承模板版本（领域版含 `Domain standards scope`）：是，更新至 v1.79.1（2026-11-16）
- 项目专属文件是否被误改：否（README.md / ai/project-rules.md / ai/domain-rules.md / docs/00-09 / domain/ 零触及）
- 是否新增 / 刷新 `ai/doc-standards/00-09`：01 / 02 刷新（v1.79.0 各 +1 审计行），其余无变化
- 是否残留旧 `docs/_scaffold/`：否

## 同步跨度采用清单（v1.76.0 排除 → v1.79.1 包含，14 版本段）

| 版本 | 条目 | 桶 | 存量影响 | 动作 | 负责环节 | 状态 |
|---|---|---|---|---|---|---|
| v1.79.1 | CONTRIBUTING §3 步 6 + prompt 11：归档移动与索引表登记同批固定步 | ③ 行为规则 | 本次归档操作直接适用 | 本次归档按固定步执行 | 本次收口 | 已生效 |
| v1.79.0 | document-lifecycle §6.0.1 实体生命周期四问 + prompts 10/19 + doc-standards 01/02 | ② 规范基线 | 本仓 docs 为 L3 scaffold 占位无业务事实 | L3 项目化 / 评估时生效 | 下次 L3 派生验证 | 已下行 |
| v1.78.5 | session-rules §4 割接迁移自检 + env-setup §12 本地态清单 | ④ 零迁移 | 无割接任务 | — | — | 随件生效 |
| v1.78.4 | 12-sync 步 24 多提交分支 PR 显式标题 + git-guide §5.3/§5.5 | ③ 行为规则 | 本轮同步分支为双提交 | PR #28 已显式标题 | 本次步骤 8 | 已生效 |
| v1.78.3 | index.md +2 场景标注 + prompt 11 读取口径 | ④ 零迁移 | — | — | — | 随件生效 |
| v1.78.2 | git-guide §3.1 untracked 安全 add 附注 | ③ 行为规则 | 纯前瞻 | 下次提交时按显式路径暂存 | 下次任务 | 已下行 |
| v1.78.1 | prompt 11 镜像落盘清尾固定步 | ③ 行为规则 | 纯前瞻（母仓维护者任务适用） | — | 母仓会话 | 已下行 |
| v1.78.0 | 新增 git-beginner-handbook.md + 清单 +1 | ① 结构迁移 | 新文件随同步自动落地 | 确认就位（已核） | cleanup（轻量） | 已生效 |
| v1.77.3 | 预检措辞（fetch 写 .git）+ session-rules §3.1 续接分级 + remote-ci §3.D + ai-cli-setup §6 | ③ 行为规则 | 本会话补做 origin 核验时按新措辞理解 | 已应用 | 本次同步 | 已生效 |
| v1.77.2 | git-guide §3.1 合并后收尾固定序（switch main + squash HEAD 核对） | ③ 行为规则 | 本次合并收尾直接适用 | 已按固定序执行 | 本次收口 | 已生效 |
| v1.77.1 | rules-core §4 沙箱分流扩到写 .git/联网 + 12-sync 非沙箱声明 + MAINTAINERS 标注 | ④ 零迁移 | — | — | — | 随件生效 |
| v1.77.0 | 新增 stack-adapters/ 3 文件 + 清单 +1 | ① 结构迁移 | 新文件随同步自动落地 | 确认就位（已核） | cleanup（轻量） | 已生效 |
| v1.76.2 | rules-core §3 例行同步最小必读 + git-guide §5.5 结构取证步 + prompt 15 + drift 工具（模板仓专用不下行） | ③ 行为规则 | 本会话按新路由收窄读取面 | 已应用 | 本次同步 | 已生效 |
| v1.76.1 | A 阶段 origin 新鲜度核验 + index.md 同步桶拆分 | ③ 行为规则 | 本会话补做 origin 核验（0/0 pass） | 已应用 | 本次同步 | 已生效 |

桶分布：① 2 ｜ ② 1 ｜ ③ 7 ｜ ④ 4；待确认条目：0

执行反馈（3 行）：

1. 桶分类够用；①桶两处均为「新增文件随同步自动落地」，无真正存量结构迁移，归入 ①仅作记录。
2. 耗时与读取成本：CHANGELOG 跨度段 awk 一次提取（~150 行）；清单整理约 10 分钟内完成，成本低。
3. 不做清单会漏掉的项：**v1.78.4 PR 显式标题**——不做清单极可能沿用 `--fill`，导致 squash 后 HEAD 信息伪影、project-check.yml 合并后校验被静默跳过；为本次最关键采纳项。

## 同步后整理摘要

- 是否执行 `/run post-sync-cleanup`：轻量执行（只读核验，无结构迁移项）
- README / `ai/project-rules.md` / docs 分区是否需整理：本轮 delta 未触及，但收尾自查发现 **§0 继承版本指针漂移复现**（2026-11-03 pitfall #4 同型）：§0 仍指 v1.76.0 ≠ TEMPLATE-BASE v1.79.1，已在本收尾提交回写修正
- 已处理项：workflow 核验（仅 project-check.yml，无需迁移）；新增 4 文件就位确认；§0 版本指针回写（v1.76.0 → v1.79.1）
- 待确认项：无
- 建议回写 / 后续迁移任务：无

## 文档体系审计摘要

- 是否执行 `/run docs-system-audit` 同步后审计模式：轻量执行（只读判定）
- 规范基线缺口：无（v1.79.0 对 doc-standards 01/02 的 +1 行不影响本仓 scaffold 占位）
- 可接受兼容差异：`docs/00-09` 为 L3 scaffold 占位，本仓不当业务事实（project-rules §3）
- 项目事实风险：无
- 回梳计划摘要：无需回梳；影响面在 L3 派生项目（首个真实 L3 验证时对照 §6.0.1 四问）

## 项目验证建议

- 建议运行的测试 / lint / 文档检查 / 人工验收：无独立测试 / lint 入口（本仓为文档 + 脚本仓）；同步脚本全链实跑（dry-run / commit / check）即功能验证
- 已执行验证与结果：check-derived-sync EXIT=0（推送前）+ CI project-check pass（合并后）
- 未验证项与原因：无

## 遇到的问题

- Git / gh / Git Bash / PowerShell / 网络问题：无（fetch 直连成功，未触发代理 / fallback）
- `gh issue create` / `submit-proposal` 问题：不适用
- 同步脚本问题：首次 dry-run EXIT=1 为预期体检防护（脚本落后 → bootstrap `2d14533` 后通过），非故障
- Prompt / 快捷命令理解问题：本地 v1.76.0 规则与母仓 v1.79.1 存在窗口期（A 阶段 origin 新鲜度项为 v1.76.1 新增，预检时按旧版规则执行漏检，已补检 0/0 pass）——已记 `.ai/pitfalls/2026-11-16-stale-rules-precheck-gap.md`
- 文档说明不清：无
- 派生项目专属冲突：无

## 可优化点归纳

| 问题 | 是否项目专属 | 是否建议回流模板 | 建议提案 |
|---|---|---|---|
| 派生仓规则滞后窗口期：同步任务预检按旧版规则执行，可能漏掉母仓新增预检项 | 否（全派生仓通用） | 暂不（窗口期一次性成本，v1.76.1 收窄路由后下次同步读取面已是新版；再现再议） | —（见 pitfall #5） |

## 已生成的回流提案

- 无（本次同步轮未新增；历史提案 #514 / #515 已被母仓采纳并随本同步下行，已归档）

## 提案回流收口

- 扫描范围：`_governance/_proposals/` 全量 / `.ai/session-handoff.md` / `_governance/sync-records/template-sync/`（2026-11-03 v1.76.0 记录）/ 母仓 issue #514 / #515 实查
- 已确认被模板采纳或已有决议的提案：sync-route-annotations（#514，v1.76.1 + v1.76.2）、structure-migration-precheck（#515，v1.76.2）
- 已归档到 `_governance/_archive/proposals/` 的本地提案：上述 2 份（H1 归档批注 + 2026-11-16 第二批索引表，按 v1.79.1 固定步同批完成）
- 仍需保留在 `_governance/_proposals/` 的提案：agent-template-buildout（总纲，D6 / Batch 4 开放）、analysis-agent-template-architecture、README、_archive-followups.md
- 无法判断是否已处理的 issue / 提案与待确认项：无

| 本地提案 | 模板 issue / PR | 远端状态 | 关闭原因 / 处理结果 | 本地动作建议 |
|---|---|---|---|---|
| sync-route-annotations | issue #514 | closed（2026-11-03） | 已采纳（v1.76.1 落地 + v1.76.2 收口，CHANGELOG 点名） | 归档（已执行） |
| structure-migration-precheck | issue #515 | closed（2026-11-03） | 已采纳（v1.76.2 固定预检步） | 归档（已执行） |
| agent-template-buildout | —（母模板 inheritance 提案的领域侧实施总纲） | 不适用 | 主体已落地，D6 / Batch 4 开放 | 保留原位（文件头明示不归档） |
| analysis-agent-template-architecture | — | 不适用 | 分析报告（buildout 前置支撑） | 保留原位 |

## 后续动作

- 是否需要 `/run post-sync-cleanup`：不需要（本轮无结构迁移）
- 是否需要 `/run docs-system-audit`：不需要（无回梳对象）
- 是否需要按审计结果回梳 `docs/00-09` / `docs/design` / `docs/env`：不需要
- 是否需要补项目验证入口：不需要（脚本链即验证）
- 是否需要人工清理旧目录：不需要
- 是否需要同步回模板仓库：不需要（本次无新回流提案）；**母仓 registry 回写待办**——建议在模板仓目录另起会话执行（跨仓维护者动作，session-rules §3.4），补登本仓 Inherited=v1.79.1 / Last sync=2026-11-16
