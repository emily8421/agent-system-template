# CHANGELOG-PLAIN

> 本文件记录 `agent-system-template` 领域模板自身版本的大白话说明；母模板同步不覆盖（见 `TEMPLATE-BASE.md` Version Semantics）。层归属：L2 领域自有。
> 母模板 `ai-project-template` 的发布历史不记在这里；继承参考见 `upstream/CHANGELOG.md` 与 `upstream/CHANGELOG-PLAIN.md`。

本文是 `CHANGELOG.md` 的大白话配套版，按同一版本顺序解释“这版到底改善了什么”。权威版本事实仍以 `VERSION`、`CHANGELOG.md`、`TEMPLATE-BASE.md` 和 Git 历史为准。

## v0.3.0（2026-07-27）

这一版把 `agent-system-template` 从“有一组 agent 文档骨架”推进到真正可作为 L2 领域模板使用。

主要变化是三件事：

- 明确了三层关系：母模板 `ai-project-template` 是 L1，本仓是 L2 领域模板，真正业务项目是 L3。`TEMPLATE-BASE.md` 和 `template-docs/agent-system/layer-map.md` 负责说明哪些文件归哪一层、哪些能改、哪些会同步覆盖。
- 补齐了 agent 领域标准件：agent 架构、工具权限、memory / state、trace / replay、HITL / safety、agent eval，以及 single-agent / multi-agent profile。
- 新增了 L2 到 L3 的同步与检查机制：`domain-template-sync.json`、`scripts/sync-domain-template.*`、`scripts/check-domain-derived-sync.*`，默认不覆盖 L3 派生项目自己的业务事实。

这一版还加入了 `_examples/single-agent-demo/`，用最小单 agent 项目验证领域标准件能落到项目文档、代码、测试和 REQ / TC 映射上。

暂缓项：领域自检仍保持 advisory-first，不接入阻断 CI。至少再经过一个真实 agent 派生项目验证后，再判断哪些检查可以升级为 gate。

## v0.1.0（2026-07-10）

这是 `agent-system-template` 的领域模板初始版本。

这一版基于母模板 `ai-project-template` 创建 agent 领域模板身份，保留自己的 `VERSION` 和 `CHANGELOG.md`，并引入第一批 agent 领域骨架：

- `template-docs/agent-system/README.md`
- `template-docs/agent-system/agent-system-checklist.md`
- agent 架构、工具权限、memory / state 的设计文档骨架
- agent eval 调研计划骨架

从这一版开始，本仓的版本号表示 agent 领域模板自身演进；母模板继承版本另由 `TEMPLATE-BASE.md` 记录。
