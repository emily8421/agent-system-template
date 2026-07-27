# CHANGELOG

> 本文件记录 `agent-system-template` 领域模板自身的版本演进；母模板同步不覆盖（见 `TEMPLATE-BASE.md` Version Semantics）。层归属：L2 领域自有。
> 母模板（`ai-project-template`）的版本演进不记入本文件——同步版本以 `TEMPLATE-BASE.md` 的 `Current synced template version` 为准，详细历史见母模板仓库 CHANGELOG（版本空间隔离，见 buildout 提案 §4.5 G2）。

模板版本采用三段式 `vMAJOR.MINOR.PATCH`，以根目录 `VERSION` 为单一审计入口。版本是发布边界，不是提案数量边界；提案收件箱增长不触发版本递增，只有合并到同步范围内并改变模板行为或下游同步判断的 PR 才判断 `PATCH / MINOR / MAJOR`。

## v0.1.0（2026-07-10）

领域模板初始版本（`agent-system-template` domain template identity）。

- 继承母模板 `ai-project-template` 方法论（base `v1.44.3`）+ inheritance Batch 2 领域骨架 MVP（`template-docs/agent-system/` 6 件：README、agent-system-checklist、docs/design/{agent-architecture, tool-permission-model, memory-and-state}、docs/research/agent-eval-plan）。
- 初始化领域身份：`TEMPLATE-BASE.md` Lineage type = domain template；`VERSION` = `v0.1.0`；C-004 版本保留（`sync-template.* --domain-template`）。
- 母模板后续同步（base `v1.44.3` → `v1.57.1`，2026-07-25）仅更新 `TEMPLATE-BASE.md` 的 `Current synced template version`，不改变领域版本。
