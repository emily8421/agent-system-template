# Template Base

> Records the upstream template lineage for this domain template (inherits ai-project-template methodology, adds domain-specific standards). Do not use this file for ordinary derived project metadata.

- Lineage type: domain template
- Template repository: github.com/emily8421/ai-project-template
- Base template version: v1.44.3
- Current synced template version: v1.57.1
- Synced at: 2026-07-25
- Domain template version file: VERSION
- Domain template version at sync time: v0.1.0
- Domain standards scope: Agent 架构（planner / executor / tool router / memory / evaluator）；Tool 权限模型（注册 / 边界 / 危险操作确认 / 沙箱审计）；Memory / state（短期上下文 / 长期记忆 / 持久化 / 清理）；Trace / replay（执行轨迹 / 回放模式 / 失败归因 / 隐私保留）；HITL / safety（人工确认 / 接管 / 回滚 / prompt injection / 数据泄露防护）；Agent eval（任务集 / 轨迹评估 / 工具调用准确率 / 成本延迟）；Profiles（single-agent 正式标准件 / multi-agent stub）
- Layer map: `template-docs/agent-system/layer-map.md`（路径 → 层类 L1/L2/L3 → 同步 / 编辑策略；AI 判层入口，见 buildout 提案 §4.5 G4）

## Domain Template Role

- Downstream role: this repository receives common methodology from `ai-project-template` and does not edit L1 synced files in place.
- Upstream role: this repository owns L2 agent standards under `template-docs/agent-system/` and will later provide the L2 → L3 path for agent-derived projects.
- Cross-domain improvements discovered here should be proposed upstream to `ai-project-template`; agent-specific standards stay in this repository.

## Version Semantics

- `VERSION` is owned by this domain template and records the domain template version.
- `CHANGELOG.md` is owned by this domain template and records domain template evolution; template sync does not overwrite it.
- `TEMPLATE-BASE.md` records the inherited ai-project-template version used for methodology sync audit.
- Template sync commits keep the message format `sync template v1.57.1 from ai-project-template`.
