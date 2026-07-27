# Token Hotspot：提案评估（2026-07-27）

> 可选观察材料，非项目事实文档，不进入正式提交。不含 token / 密钥 / 账号 / 敏感数据；仅任务类型、文件路径、命令类别、热点判断、质量影响与优化建议。

- 汇总状态：未汇总

## 1. 任务
- 类型：提案评估 / 修订（分析 · 设计任务，非编码）。
- 触发：从快速续接进入分析，连续读取多份规则包 + 两份提案全文，并对照另一 AI 的分析结论、本地核验其引用的行号。

## 2. 主要上下文成本
- 规则包（全读）：`ai/index.md`、`ai/rules-core.md`、`ai/session-rules.md`、`ai/document-lifecycle-rules.md`（~549 行）、`ai/global-rules.md`（~189 行）、`ai/project-rules.md`。
- 提案 / 治理文件：`_proposals/analysis-agent-template-architecture.md`、`_proposals/TEMPLATE-UPGRADE-agent-template-buildout.md`、`TEMPLATE-BASE.md`、`CHANGELOG.md`、`_proposals/README.md`、`template-docs/agent-system/README.md`。
- 命令类别：git 只读（status / log / stash / remote）、Glob。

## 3. 为什么触发
- `rules-core` 要求「文档 / 设计」任务前先读完整规则包；`document-lifecycle-rules` 与 `global-rules` 都偏长。
- 跨 AI 复核要求本地核验对方引用的行号，导致重读 `CHANGELOG` / `TEMPLATE-BASE` / `_proposals/README` 等小文件。

## 4. 质量影响（正收益）
- 核验 catch 到真实矛盾：`CHANGELOG.md` 所有权（`TEMPLATE-BASE.md:17` 宣称归领域模板 vs `CHANGELOG.md:3` 仍顶母模板 notice + 母模板版本史）。
- 纠正另一 AI 的错误建议：`project-rules.md` 桥接无效（`:3` 写明不参与跨项目同步，不下发）。
- 若不核验，会直接把这两条错误结论写进提案。

## 5. 优化建议
- 「文档 / 设计」层必读包偏大（`document-lifecycle-rules` + `global-rules` 合计 ~740 行）；可为「提案评估 / 修订」这类轻量分析设更小的专用规则子集，避免每次全读。
- 提案类长文档建议加 TL;DR 速查块，减少全读。
- 跨 AI 复核时，对方引用的行号应在结论产出前本地核验（本轮已做，是质量正收益，值得固化为习惯）。
