# TEMPLATE-UPGRADE: 补 L3 agent 派生项目的 AI 启动入口

> **📦 已归档（2026-08-05）** · 主体已落地 —— PR [#15](https://github.com/emily8421/agent-system-template/pull/15)，VERSION v0.4.2。原状态字段"执行中"已过时（实际已合并）。
> - 残留待办：无。

> 类型：L2 领域模板自身建设提案。
> Release impact：patch（待确认）—— v0.4.2。
> Release strategy：单独发布。
> 状态：执行中（2026-07-30，分支 feat/l3-ai-entrypoint）。
> 关联：评审遗留（L3 入口断裂）；PR #13（v0.4.1 domain-overlay）；`_proposals/analysis-agent-template-architecture.md`。

## 1. 动机

`new-domain-project` 派生 L3 时正确剥离了母模板 L1 入口（`CLAUDE.md` / `INIT-PROMPT.md` / `AGENTS.md` / `ai/index.md` / `ai/rules-core.md`），符合"L3 单源锚定 L2、不挂 L1"。但生成后 **L3 没有任何 AI 启动入口文件**，且下发的 `agent-system/README.md` 的 D7 段仍指向 L3 不存在的 `ai/index.md`。结果：AI / 人进 L3 项目找不到"先读哪个文件"——评审第一轮发现的「入口断裂」。这直接违背"AI 能读懂"的核心诉求。

## 2. 拟改

- `new-domain-project.{ps1,sh}`：生成 L3 时写根 `CLAUDE.md`（AI 启动入口：`TEMPLATE-BASE.md` → `ai/project-rules.md` → `agent-system/README.md` + `layer-map.md` → agent overlay；明确"不挂 ai/index.md，以本文件为入口"）。
- `agent-system/README.md`（L2 源 `domain-overlay/agent-system/README.md`）D7 段改双视角：L2 仓按母模板 `ai/index.md`；L3 项目按根 `CLAUDE.md` → `TEMPLATE-BASE` + `project-rules`。
- `layer-map.md` D7 第 5 条：L3 入口补"根 `CLAUDE.md`"。
- `_examples/single-agent-demo`：补同结构 `CLAUDE.md`，保持 L3 样本完整。

## 3. 不改

- L3 单源锚定 L2（不重新挂 L1 入口文件）。
- 不改 L1 文件（`ai/index.md` 等仍只在 L2 仓）。

## 4. 验证

- `new-domain-project` 实测派生：L3 含根 `CLAUDE.md`，入口指向的文件均存在（`TEMPLATE-BASE.md` / `ai/project-rules.md` / `template-docs/agent-system/*` / `ai/agent-rules/*` / `ai/doc-standards/agent-*`）。
- demo `check-domain-derived-sync` / `check-agent-template` 通过；markdown clean。

## 5. 版本影响：patch（v0.4.2）

新增 L3 入口文件 + 文案双视角；不改变同步语义或 L3 形态（仅补一个入口 + 修文案）。

## 6. 后续

- 若真实 L3 项目反馈入口需更丰富（如 merge 母模板入口精华），再迭代；当前最小可用。
