# Template Base

> Records the upstream template lineage for this domain template (inherits ai-project-template methodology, adds domain-specific standards). Do not use this file for ordinary derived project metadata.

- Lineage type: domain template
- Template repository: github.com/emily8421/ai-project-template
- Base template version: v1.44.3
- Current synced template version: v1.59.0
- Synced at: 2026-07-29
- Domain template version file: VERSION
- Domain template version at sync time: v0.3.0
- Domain standards scope: Agent 架构（planner / executor / tool router / memory / evaluator）；Tool 权限模型（注册 / 边界 / 危险操作确认 / 沙箱审计）；Memory / state（短期上下文 / 长期记忆 / 持久化 / 清理）；Trace / replay（执行轨迹 / 回放模式 / 失败归因 / 隐私保留）；HITL / safety（人工确认 / 接管 / 回滚 / prompt injection / 数据泄露防护）；Agent eval（任务集 / 轨迹评估 / 工具调用准确率 / 成本延迟）；Profiles（single-agent 正式标准件 / multi-agent stub）；Domain rules（`ai/agent-rules/`）；Agent doc standards（`ai/doc-standards/agent-*.md`）；L2→L3 sync and advisory self-check scripts

## Version Semantics

- `VERSION` is owned by this domain template and records the domain template version.
- `CHANGELOG.md` and `CHANGELOG-PLAIN.md` are owned by this domain template and record domain template evolution; template sync does not overwrite them.
- `TEMPLATE-BASE.md` records the inherited ai-project-template version used for methodology sync audit.
- `upstream/CHANGELOG.md` and `upstream/CHANGELOG-PLAIN.md` are generated read-only references for upstream ai-project-template release notes.
- Template sync commits keep the message format `sync template v1.59.0 from ai-project-template`.
