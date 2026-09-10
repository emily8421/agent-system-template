# CHANGELOG

> 本文件记录 `agent-system-template` 领域模板自身的版本演进；母模板同步不覆盖（见 `TEMPLATE-BASE.md` Version Semantics）。层归属：L2 领域自有。
> 母模板（`ai-project-template`）的版本演进不记入本文件——同步版本以 `TEMPLATE-BASE.md` 的 `Current synced template version` 为准，详细历史见母模板仓库 CHANGELOG（版本空间隔离，见 buildout 提案 §4.5 G2）。

模板版本采用三段式 `vMAJOR.MINOR.PATCH`，以根目录 `VERSION` 为单一审计入口。版本是发布边界，不是提案数量边界；提案收件箱增长不触发版本递增，只有合并到同步范围内并改变模板行为或下游同步判断的 PR 才判断 `PATCH / MINOR / MAJOR`。

## v0.5.0（2026-09-11）

**Batch C：对齐母模板 v1.75.0 三层布局**（结构性 MINOR；上游 changelog 明示「存量 agent-system-template 按 Batch C 另行迁移」，本版执行）。领域增量从 `domain-overlay/` 迁移到根级唯一领域目录 `domain/`（布局规范见母模板 `template-docs/profiles/domain-templates.md` §5.1），并完成领域规则机制对齐与母仓残留清理。决策：规则件完整对齐（方案 A）/ 版本 v0.5.0 / 残留一并清理（D1/D2/D3，2026-09-11 用户裁决）。

- **目录重排**（`git mv`，保留历史）：`domain-overlay/agent-system/domain-derived-scenarios.md` → `domain/scenarios.md`（剧本路径收敛）；`agent-system-checklist.md` → `domain/scaffold/`；`agent-system/docs/**` → `domain/scaffold/docs/**`（L3 项目文档骨架）；`agent-system/profiles/` 与 `doc-standards/agent-*.md` → `domain/standards/`；`domain-overlay/README.md` + `agent-system/README.md` 合并为 `domain/README.md`；`layer-map.md` → `domain/layer-map.md`（重写为同路径覆盖口径）。`domain-overlay/` 目录废除。
- **领域规则机制对齐（语义变化）**：原 `domain-overlay/rules/{agent-implementation-rules,tool-safety-rules}.md` 合并为 `ai/domain-rules.md` 种子（按 `ai/doc-standards/domain-rules.md` 基线 §0-§4；规则内容全量保留进 §2/§3）。L3 不再接收 `ai/agent-rules/*` 第三份领域规则文件：`new-domain-project.*` 创建时把种子**项目化**进 L3 `ai/project-rules.md` §5 并移除种子文件（v1.75.0「不设第三份领域规则种子」口径）。
- **`domain-template-sync.json` 重写**：`domain/**` 改为**同路径覆盖**下发（L3 `domain/` 为覆盖同步区，不得直改）；scaffold 骨架保留 `copy-if-missing` 种子化到 L3 `docs/design\|research/`（项目事实永不覆盖）；移除 `ai/agent-rules/*`、`ai/doc-standards/agent-*`、`template-docs/agent-system/*` 旧目标。
- **脚本适配**：`check-agent-template.{ps1,sh}` overlay 清单改 `domain/**`（11 件）+ 新增「领域规则已项目化」检查（迁移前 15 findings → 0 findings）；`new-domain-project.{ps1,sh}` 不再剥离 `domain/`、新增规则项目化块、L3 身份文件与 README/CLAUDE.md 路径口径更新。`sync-domain-template.*` / `check-domain-derived-sync.*` 纯 manifest 驱动，零改动。
- **`_examples/single-agent-demo/` 迁移到新 L3 布局**：`template-docs/agent-system/*` → `domain/*`；`ai/agent-rules/*` 移除并项目化进 `ai/project-rules.md` §5；`ai/doc-standards/agent-*.md` → `domain/standards/`；脚本副本同步更新；研究记录路径指针更新。
- **母仓残留清理**（v1.72.1 审计口径）：删除 `MAINTAINERS.md`（v1.70.0 起不下行的母仓维护者手册）、`.github/ISSUE_TEMPLATE/`（2 个模板均引导用户向母仓开 issue，对本仓误导）、`.github/pull_request_template.md`（母仓 PR 模板）。
- **根目录占位清理**（post-sync-cleanup §3 裁剪一致性审计）：删除建仓期旧布局带入的根级 `backend/`、`frontend/`、`docker/`、`tests/`、`tasks/` 占位目录（`.gitkeep` + README，共 14 文件；非同步清单、零引用、与 §3 裁剪决策不符，且会随 `git archive` 泄漏进新建 L3）；裁剪事实回填 `ai/project-rules.md` §3。
- **文档指针更新**：根 `README.md`、`TEMPLATE-BASE.md` scope（Domain rules = `ai/domain-rules.md` 种子 + `domain/standards/` doc standards + 根级 `domain/`）、`ai/project-rules.md` §0/§1/§3/§4、`_proposals/_archive-followups.md` §2（B2 随 Batch C 关闭）。
- **C-001 随迁移解决**：剧本落位 `domain/scenarios.md`，随 `domain/` 覆盖同步自然下发（原待确认项关闭）。
- 验证：`check-agent-template.{ps1,sh}` 对 demo 0 findings；`check-domain-derived-sync.{ps1,sh}` 通过；`sync-domain-template.ps1 -DryRun` 新 manifest 全链路通过；demo `python -m unittest` 5/5 OK；脚本语法校验（bash -n / PS Parser）通过。
- 已知边界（不假装全清）：`new-domain-project.*` 端到端实跑派生未在本版验证（仅 dry-run + demo 等价物验证；真实派生留待首个 L3 项目）；`domain/checks/`（领域自检成熟位）暂空，advisory 脚本仍留 `scripts/`（§5.4 索引表认定口径）。

## v0.4.2（2026-07-30）

补 L3 agent 派生项目的 AI 启动入口（修评审遗留的"L3 入口断裂"）：`new-domain-project` 生成 L3 时写根 `CLAUDE.md`；`agent-system/README` 的 D7 段改双视角；`layer-map` D7 补 L3 入口；demo 补同结构 `CLAUDE.md`。

- `scripts/new-domain-project.{ps1,sh}`：生成 L3 根 `CLAUDE.md`（AI 启动入口：`TEMPLATE-BASE.md` → `ai/project-rules.md` → `agent-system/README.md` + `layer-map.md` → agent overlay；明确"不挂 `ai/index.md`，以本文件为入口"）。
- `domain-overlay/agent-system/README.md` D7 段：双视角（L2 仓按母模板 `ai/index.md`；L3 项目按根 `CLAUDE.md`），不再单向指向 L3 不存在的 `ai/index.md`。
- `domain-overlay/agent-system/layer-map.md` D7 第 5 条：L3 入口补"根 `CLAUDE.md`"。
- `_examples/single-agent-demo/CLAUDE.md`：新增，L3 样本入口完整。
- 验证：`new-domain-project` 实测派生 L3 含根 `CLAUDE.md`、入口指向文件均存在；demo check 通过；markdown clean。
- 详见 `_proposals/TEMPLATE-UPGRADE-l3-ai-entrypoint.md`。

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
