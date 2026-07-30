# CLAUDE.md

本仓是 **agent 派生项目（L3 示例：single-agent-demo）**，单源锚定 agent-system-template（L2 领域模板）；母模板通用方法论经 L2 传递，本项目不直连母模板。

## AI 启动入口

1. 读 `TEMPLATE-BASE.md`：确认本项目是 agent 派生项目，继承自哪个 L2 版本。
2. 读 `ai/project-rules.md`：本项目专属约束（身份、Phase、技术栈、形态）。
3. 读 `template-docs/agent-system/README.md` 与 `template-docs/agent-system/layer-map.md`：领域标准件导航与判层（L1 / L2 / L3 归属）。
4. agent 相关任务（设计 / 实现 / 工具权限 / memory / trace / HITL / eval）前读 `ai/agent-rules/` 与对应 `ai/doc-standards/agent-*.md`。
5. 同步领域模板更新用 `scripts/sync-domain-template.*`；领域自检 `scripts/check-domain-derived-sync.*` + `scripts/check-agent-template.*`。

> 本项目不挂母模板 `ai/index.md` 启动路由（L1 入口已随 L2 传递）；以本文件为本项目的 AI 启动入口。
