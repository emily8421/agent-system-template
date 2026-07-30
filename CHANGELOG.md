# CHANGELOG

> 本文件记录 `agent-system-template` 领域模板自身的版本演进；母模板同步不覆盖（见 `TEMPLATE-BASE.md` Version Semantics）。层归属：L2 领域自有。
> 母模板（`ai-project-template`）的版本演进不记入本文件——同步版本以 `TEMPLATE-BASE.md` 的 `Current synced template version` 为准，详细历史见母模板仓库 CHANGELOG（版本空间隔离，见 buildout 提案 §4.5 G2）。

模板版本采用三段式 `vMAJOR.MINOR.PATCH`，以根目录 `VERSION` 为单一审计入口。版本是发布边界，不是提案数量边界；提案收件箱增长不触发版本递增，只有合并到同步范围内并改变模板行为或下游同步判断的 PR 才判断 `PATCH / MINOR / MAJOR`。

## v0.4.1（2026-07-30）

领域增量收拢到 `domain-overlay/`（轨 A · B1）：让 L2 仓库根目录自带层归属——通用方法论（继承、随 sync 刷新）与 agent 领域增量（`domain-overlay/`）物理可分，AI 与人不再靠交叉查表判层。L3 下发行为不变（target 不变）。

- 物理收拢（`git mv`，保留历史）：`ai/agent-rules/*`、`ai/doc-standards/agent-*.md`、`template-docs/agent-system/**` → `domain-overlay/{rules,doc-standards,agent-system}/`；新增 `domain-overlay/README.md`（L2 入口）。
- `domain-template-sync.json`：19 条 source 改指向 `domain-overlay/`，**target 不变**（L3 落点不变）。
- D7 指针对齐：`TEMPLATE-BASE.md` scope 改 L2 视角；`layer-map.md` 重写为「L2 源 → L3 target」双路径映射表，并修正根 README 归类（L2，非 L3）；`agent-system/README.md` 与 `agent-implementation-rules.md` 保持 L3 下发视角（target 不变，天然准确）。
- `scripts/new-domain-project.{ps1,sh}`：剥离黑名单加 `domain-overlay`，避免 `git archive` 泄漏到 L3。
- 顺手修正文档一致性：根 README 版本号（v0.3.0 → v0.4.1）与目录表；`domain-derived-scenarios.md` §3/§3.3/C-002「创建脚本远期未做」滞后（v0.4.0 已落地 `new-domain-project.*`）；`ai/project-rules.md` 版本与目录清单。
- 验证：`sync-domain-template` dry-run、`check-domain-derived-sync`、`check-agent-template` 对 `_examples/single-agent-demo` 通过；`new-domain-project` 实测派生确认 `domain-overlay/` 被剥离、overlay 落到 L3 `ai/agent-rules/`。
- 附带修复 `new-domain-project.ps1` 的 PS5.1 native stderr 陷阱（`$ErrorActionPreference="Stop"` 把 git CRLF warning 当 `NativeCommandError` 中断，致 ps1 在 Windows PowerShell 5.1 实跑不可用）：新增 `Invoke-SafeNative` helper 包裹 native 调用 + `2>$null`；ps1 现可实跑（此前仅 `.sh` 可跑）。详见 `_proposals/TEMPLATE-UPGRADE-ps1-native-stderr-stop.md`。
- 已知边界（不假装全清）：L3 派生项目目录仍混层、`scripts/` 内领域脚本仍与通用脚本混——彻底清晰需 B2 / 轨 B（回流母模板 MAJOR）。详见 `_proposals/TEMPLATE-UPGRADE-domain-overlay-relocation.md`。

## v0.4.0（2026-07-30）

补齐 L2→L3 的"创建"半边：新增领域派生项目一键创建脚本，确立 L3 单源锚定 L2。

- 新增 `scripts/new-domain-project.ps1` + `.sh`：从 `agent-system-template` 整仓派生 L3 骨架，**剥离所有 L1 同步入口**（sync-template / check-derived-sync / check-template / new-project），写领域派生身份（`TEMPLATE-BASE.md` lineage = agent derived project），叠加 agent overlay，装领域版 `project-check.yml`，`git init`。
- 新增 `template-docs/agent-system/domain-derived-scenarios.md`（L2→L3 场景剧本），并修正 `README.md`「L2→L3 同步机制」一节的歧义句为"L3 单源锚定 L2"。
- 关键决策：采用"领域模板自建创建脚本"路线（非母模板 `new-project --profile`）；路线分歧记于 `_proposals/TEMPLATE-UPGRADE-agent-new-domain-project.md` §4 / C-006。
- 验证：用脚本创建本地 `my-agent` 项目，`check-domain-derived-sync` 通过、`check-agent-template` advisory 通过（仅 `agent-standard-mapping.md` 待项目侧填写）。
- 已知约束：`new-domain-project.ps1` 必须以 **UTF-8 with BOM + CRLF** 保存（Windows PowerShell 5.1 要求，否则中文乱码、here-string 解析失败）；`.gitattributes` 已加 `*.ps1 text eol=crlf`，BOM 需编辑时保持。`.sh` 未在 Git Bash 实测。
- 未落地：命令入口（`ai/commands/*` 属 L1 下发）、加入 `domain-template-sync.json` 下发清单（C-001）、CI 接入——留待真实项目增多后再评估。
- 顺手修正：`_examples/single-agent-demo/TEMPLATE-BASE.md` 与 7-29 sync pilot 现状的漂移。

## v0.3.0（2026-07-27）

Agent 领域模板从 scaffold MVP 升级为具备第二跳同步能力的领域模板。本版聚合原拟 `v0.2.0` 的治理 / 文档 / 示例批次与 `v0.3.0` 的机制层批次；此前未单独发布 `v0.2.0`。

- 落地 L2 层治理：`CHANGELOG.md` 转为领域自有版本史，`template-docs/agent-system/layer-map.md` 成为 AI 判层入口，`TEMPLATE-BASE.md` 明确领域 overlay 读取路径与版本语义。
- 补齐 agent 领域标准件：trace/replay、HITL/safety、single-agent profile 与 multi-agent stub，并更新 checklist 与 README 导航。
- 新增 `_examples/single-agent-demo/`，用最小单 agent 项目验证领域标准件到项目 docs、代码、测试、REQ-ID / TC-ID 的映射。
- 新增 L2→L3 同步机制：`domain-template-sync.json`、`scripts/sync-domain-template.*`、`scripts/check-domain-derived-sync.*`，默认不覆盖派生项目业务事实。
- 新增领域 AI 规则与文档标准 overlay：`ai/agent-rules/*`、`ai/doc-standards/agent-*.md`，并由 `check-agent-template.*` 做 advisory-first 自检。
- 验证：PowerShell / Bash sync dry-run 与 advisory check 均通过；`_examples/single-agent-demo` 5 个 unittest 通过；Markdown clean 与 JSON 解析通过。
- 暂缓：领域自检暂不接 CI；至少一个真实 agent 派生项目验证后，再评估是否把成熟条目升级为 gate。

## v0.1.0（2026-07-10）

领域模板初始版本（`agent-system-template` domain template identity）。

- 继承母模板 `ai-project-template` 方法论（base `v1.44.3`）+ inheritance Batch 2 领域骨架 MVP（`template-docs/agent-system/` 6 件：README、agent-system-checklist、docs/design/{agent-architecture, tool-permission-model, memory-and-state}、docs/research/agent-eval-plan）。
- 初始化领域身份：`TEMPLATE-BASE.md` Lineage type = domain template；`VERSION` = `v0.1.0`；C-004 版本保留（`sync-template.* --domain-template`）。
- 母模板后续同步（base `v1.44.3` → `v1.57.1`，2026-07-25）仅更新 `TEMPLATE-BASE.md` 的 `Current synced template version`，不改变领域版本。
