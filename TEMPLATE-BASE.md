# Template Base

> Records the upstream template lineage for this domain template (inherits ai-project-template methodology, adds domain-specific standards). Do not use this file for ordinary derived project metadata.

- Lineage type: domain template
- Template repository: github.com/emily8421/ai-project-template
- Base template version: v1.44.3
- Current synced template version: v1.57.1
- Synced at: 2026-07-25
- Domain template version file: VERSION
- Domain template version at sync time: v0.1.0
- Domain standards scope: Agent 架构（planner / executor / tool router / memory / evaluator）；Tool 权限模型（注册 / 边界 / 危险操作确认 / 沙箱审计）；Memory / state（短期上下文 / 长期记忆 / 持久化 / 清理）；Agent eval（任务集 / 轨迹评估 / 工具调用准确率 / 成本延迟）

## Version Semantics

- `VERSION` is owned by this domain template and records the domain template version.
- `CHANGELOG.md` is owned by this domain template and records domain template evolution; template sync does not overwrite it.
- `TEMPLATE-BASE.md` records the inherited ai-project-template version used for methodology sync audit.
- Template sync commits keep the message format `sync template v1.57.1 from ai-project-template`.
