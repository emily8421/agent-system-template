# CHANGELOG

> 本文件记录 `agent-system-template` 领域模板自身的版本演进；母模板同步不覆盖（见 `TEMPLATE-BASE.md` Version Semantics）。层归属：L2 领域自有。
> 母模板（`ai-project-template`）的版本演进不记入本文件——同步版本以 `TEMPLATE-BASE.md` 的 `Current synced template version` 为准，详细历史见母模板仓库 CHANGELOG（版本空间隔离，见 buildout 提案 §4.5 G2）。

模板版本采用三段式 `vMAJOR.MINOR.PATCH`，以根目录 `VERSION` 为单一审计入口。版本是发布边界，不是提案数量边界；提案收件箱增长不触发版本递增，只有合并到同步范围内并改变模板行为或下游同步判断的 PR 才判断 `PATCH / MINOR / MAJOR`。

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
