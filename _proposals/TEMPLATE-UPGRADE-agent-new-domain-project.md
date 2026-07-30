# TEMPLATE-UPGRADE: agent 领域派生项目一键创建脚本（new-domain-project）

> 来源：模板维护者（agent-system-template）。本提案为 **A 组·领域级（本仓库落地）**，不上行母模板（见 `_proposals/README.md`）。
> 状态：**已落地（v0.4.0，2026-07-30）** —— `scripts/new-domain-project.ps1` + `.sh` 与 `template-docs/agent-system/domain-derived-scenarios.md` 经本地 `my-agent` 项目验证通过（`check-domain-derived-sync` 通过、`check-agent-template` advisory 通过）。C-003 版本已递增 v0.4.0、C-004 CI 已做进脚本、C-005 demo 漂移已修、C-006 路线确认为领域自建。**仍待办**：C-001（加入下发清单）、命令入口（L1 边界）、CI 接入。
> 目标版本：领域模板 `v0.4.0`（MINOR，已发布）
> Release impact：minor —— 新增领域创建脚本，不改母模板主同步路径，**不进** `domain-template-sync.json` 下发清单
> Release strategy：薄脚本先行 + 第 1 个真实项目验证打磨；命令入口 / 下发清单 / CI 后置
> 仓库角色：**领域模板（L2）** —— 相对母模板为下游，相对 agent 派生项目为上游
> 衔接：属 `TEMPLATE-UPGRADE-agent-template-buildout.md` **Batch 4「创建」子项**的具体化与路线修正；对齐 `analysis-agent-template-architecture.md` §5 D4「先验证再固化」

## 1. 背景

- `TEMPLATE-UPGRADE-agent-template-buildout.md` §7 Batch 4 把 `new-project --profile agent-system` 列为**远期**，前置条件为"至少一个真实 agent 项目试用后再评估"；§3 明确不在该提案阶段实现。
- 当前 L2 的 L2→L3 能力**只有"同步"半边**（`sync-domain-template.*` + `check-domain-derived-sync.*` + `check-agent-template.*`），**缺"创建 / 派生"半边**：没有从 `agent-system-template` 一键生成 L3 骨架 + 领域身份 + overlay 的入口。
- `template-docs/agent-system/domain-derived-scenarios.md`（已落地）固化了过渡期**手动**组合流程 §3.2（6 步）。
- **新出现的真实需求**：维护者预期**连续创建多个同类 agent 项目**。重复手动走 §3.2 成本高、易错（身份写错、CI 指向 L1、lineage 错乱）。手搓经验不可复用。
- 唯一样本 `_examples/single-agent-demo` 是手搓产物，且自身不规范（无 `VERSION`/`CHANGELOG`、`TEMPLATE-BASE` 与实际 sync 状态漂移），不足以作为创建脚本的稳定基准。

## 2. 目标

1. 落地**薄创建脚本** `scripts/new-domain-project.ps1` + `.sh`，把 `domain-derived-scenarios.md` §3.2 的低风险部分固化为可执行流程。
2. 让"L3 单源锚定 L2"的创建动作**一键执行**（保留必要人工确认点作为安全阀）。
3. 用**第 1 个真实 agent 项目**验证并打磨脚本，使其可复用到后续项目。

## 3. 非目标

- **不做命令入口** `ai/commands/new-domain-project.md`：`ai/commands/*` 是母模板（L1）下发件，本仓不能加（会被 sync 覆盖）。命令入口归属需单独提案（回流母模板 or 设 L2 自治入口）。
- **不做 `new-project --profile agent-system`**：仍属母模板 Batch 4 路线；本提案走**领域自建**路线（见 §4 决策）。
- **不把脚本与说明书加入 `domain-template-sync.json` 下发清单**（C-001，等验证后定）。
- 不改母模板 `scripts/new-project.sh`、不改任何 L1 文件、不绑定 runtime。
- 不在本提案把脚本接入 CI。
- 不在本提案自动生成 `TEMPLATE-BASE.md` 的母模板侧逻辑（L3 身份由本脚本写入，母模板 `sync-template.*` 不感知 agent lineage）。

## 4. 关键决策：领域自建脚本 vs 母模板 `--profile`（路线分歧，需维护者拍板）

`buildout` Batch 4 原拟**母模板** `new-project --profile agent-system`。本提案改走**领域模板自建 `new-domain-project.*`**。理由：

1. 母模板 `new-project.sh` 硬编码 L1 远端、写 `ordinary derived project` 身份、装 L1 边界 `project-check.yml`，**无法承载领域身份 / overlay**（详见 `domain-derived-scenarios.md` §3.1）。
2. 母模板加 `--profile` 会让 L1 **感知各领域 overlay 清单**，违反"母模板不承载具体领域内容"边界（`domain-templates.md` §3）。
3. 领域自建可**立即在本仓落地**，不依赖母模板跨仓 PR，不污染母模板主路径。

**风险**：与将来母模板 `--profile` 可能形成**两套创建入口**。

**缓解**：本提案在 `domain-derived-scenarios.md` §11 与本节明确"**领域自建为正路线**"；待多领域模板出现、创建模式成熟后，再把通用部分回流母模板收敛为 `--profile`（届时本仓脚本可退役或作为 `--profile` 的领域侧实现）。此路线修正是对 `buildout` Batch 4 的具体化，**需维护者确认**（见 C-006）。

## 5. 设计：脚本做什么 / 不做什么

**做**（固化 `domain-derived-scenarios.md` §3.2 低风险部分）：

1. 从 L2（`agent-system-template`）`git clone --depth 1` 或 `git archive` 到目标目录（**不用** `new-project.sh`）。
2. 写**领域派生版身份文件**：`VERSION=v0.1.0`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md`、`TEMPLATE-BASE.md`（`Lineage type: agent derived project (L3)`，记 L2 版本 + 经 L2 继承的 L1 版本 + Domain standards scope）、根 `README.md` 占位。
3. 调用现有 `sync-domain-template.*` 叠加 agent overlay（**复用，不重写**；`-DryRun` 后 `-Commit`）。
4. 注入**领域版** `.github/workflows/project-check.yml`（参照 `new-project.sh` `write_derived_project_workflow` 改造：普通 PR 跑 `git diff --check`；提交信息匹配 `^sync agent domain template v… from agent-system-template` 时跑 `scripts/check-domain-derived-sync.sh`）。
5. `git init` + 首提交；可选 `gh repo create`（`--no-remote` 可跳过）。
6. 末尾提示跑 `check-domain-derived-sync.*` + `check-agent-template.*`。

**双实现**：`.ps1` + `.sh`（避免母模板 `new-project.sh` 只有 `.sh` 的 Windows 痛点；与 `sync-domain-template.*` 双实现对齐）。

**人工确认点（安全阀，非缺陷）**：overlay `-Commit` 前 DryRun 给用户看；建远端确认账号。

**不做**：命令入口、`--profile`、下发清单、CI、过度抽象的参数体系。

## 6. 落地步骤

1. 本提案经维护者确认（含 §4 路线、C-001~C-006）。
2. 写 `scripts/new-domain-project.ps1` + `.sh`（薄脚本）。
3. 用脚本建**第 1 个真实 agent 项目**，边建边修（验证）。
4. 第 2 个及以后项目稳定一键。
5. 后续评估：C-001 下发、命令入口、CI、是否回流母模板。

## 7. 验收标准

- 脚本能从 L2 一键生成 L3 骨架 + 正确领域身份 + overlay + 领域 check workflow。
- 生成的 L3 `TEMPLATE-BASE.md` lineage = `agent derived project`，单源锚定 L2，**无 L1 同步入口残留**（不挂 `sync-template.*`/`check-derived-sync.*`）。
- `check-domain-derived-sync.*` + `check-agent-template.*` 在生成项目上通过（或 advisory 项已知并记录）。
- 第 1 个真实项目跑通；脚本能复用到第 2 个项目。
- 不改 L1、不污染母模板主路径、不绑定 runtime。

## 8. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| C-001 | 脚本与 `domain-derived-scenarios.md` 是否加入 `domain-template-sync.json` 下发清单 | **先不下发**；等第 1 个真实项目验证后再评估，按 `overwrite-domain-owned` 下发 | 过早下发会把未验证结构固化到每个 L3 | 立即下发 | 不阻塞脚本落地；影响 L3 创建时是否自动拿到说明书 |
| C-002 | 脚本形态是否就此固化 | 第 1 个项目跑通后再定；保持薄、可调 | 对齐 `analysis` D4「先验证再固化」 | 一次定死 | 不阻塞；决定第 2 个起是否稳定 |
| C-003 | 版本号 `v0.4.0` MINOR 是否递增 | 脚本合入 `scripts/` 即递增 MINOR（新增下游采用面能力） | `project-rules §2.8`：合并到 L2 同步范围并改变下游行为才递增；脚本虽不进下发清单，但属下游采用面能力 | 不递增（视为内部工具） | 影响 `VERSION`/`CHANGELOG`；不阻塞脚本 |
| C-004 | 领域版 `project-check.yml` 这次做进脚本还是先手动 | **做进脚本**（参照 `new-project.sh` 改造，标"验证中"） | 不做则生成项目 CI 指向错误，违背单源锚定 | 先手动配 | 不阻塞；影响生成项目 CI 正确性 |
| C-005 | 是否顺手规范 `_examples/single-agent-demo`（补 `VERSION`/`CHANGELOG`、修 `TEMPLATE-BASE` 漂移）作为脚本的第 0 个验证样本 | 建议做，低成本且消除现存漂移 | demo 当前不规范，作为基准有误导风险 | 不动 demo | 不阻塞脚本；改善样本可信度 |
| C-006 | §4 路线：领域自建 vs 母模板 `--profile` | **领域自建为正路线**；通用部分待多领域成熟后回流母模板收敛 | 母模板无法承载领域身份；自建可立即落地 | 等母模板 `--profile` | 需维护者拍板；影响是否与母模板 Batch 4 对齐声明 |

## 9. 与既有提案衔接

- 属 `TEMPLATE-UPGRADE-agent-template-buildout.md` **Batch 4「创建」子项**的具体化与路线修正（自建而非 `--profile`）。落地后需回写 `buildout` §7 Batch 4 状态与 `template-docs/domain-templates.md` §7 状态表。
- 对齐 `analysis-agent-template-architecture.md` §5 D4「先验证再固化」：本提案 = 薄脚本 + 第 1 个真实项目验证。
- 不改母模板；创建脚本的**跨领域通用模式**（领域模板一键派生 L3）成熟后，再由本仓 `submit-proposal` 回流母模板 inheritance Batch 4。
