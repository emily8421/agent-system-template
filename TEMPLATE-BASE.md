# Template Base

> Records the upstream template lineage for this domain template (inherits ai-project-template methodology, adds domain-specific standards). Do not use this file for ordinary derived project metadata.

- Lineage type: domain template
- Template repository: github.com/emily8421/ai-project-template
- Base template version: v1.44.3
- Current synced template version: v1.57.1
- Synced at: 2026-07-25
- Domain template version file: VERSION
- Domain template version at sync time: v0.1.0
- Domain standards scope: Agent 架构（planner / executor / tool router / memory / evaluator）；Tool 权限模型（注册 / 边界 / 危险操作确认 / 沙箱审计）；Memory / state（短期上下文 / 长期记忆 / 持久化 / 清理）；Trace / replay（执行轨迹 / 回放模式 / 失败归因 / 隐私保留）；HITL / safety（人工确认 / 接管 / 回滚 / prompt injection / 数据泄露防护）；Agent eval（任务集 / 轨迹评估 / 工具调用准确率 / 成本延迟）；Profiles（single-agent 正式标准件 / multi-agent stub）；Domain rules（`ai/agent-rules/`）；Agent doc standards（`ai/doc-standards/agent-*.md`）；L2→L3 sync and advisory self-check scripts
- Layer map: `template-docs/agent-system/layer-map.md`（路径 → 层类 L1/L2/L3 → 同步 / 编辑策略；AI 判层入口，见 buildout 提案 §4.5 G4）

## Domain Overlay Read Path

- D7 decision: closed by transitional domain pointers. Until the L1 mother template provides a generic overlay delegation hook, this file plus `template-docs/agent-system/README.md` are the domain-owned read-path contract.
- Agent-related AI tasks must first complete the L1 startup route, then read `template-docs/agent-system/README.md` and `template-docs/agent-system/layer-map.md`.
- Agent design, implementation, tool permission, memory, trace, HITL, eval, sync, and self-check tasks must read the relevant files under `ai/agent-rules/` before acting.
- Agent documentation generation or audit tasks must read the relevant `ai/doc-standards/agent-*.md` domain doc standard before editing docs.

## Domain Sync Mechanism

- L2→L3 sync manifest: `domain-template-sync.json`.
- Sync entrypoints: `scripts/sync-domain-template.ps1` / `scripts/sync-domain-template.sh`.
- Derived sync check: `scripts/check-domain-derived-sync.ps1` / `scripts/check-domain-derived-sync.sh`.
- Agent advisory self-check: `scripts/check-agent-template.ps1` / `scripts/check-agent-template.sh`.
- Policy: domain-owned overlay files may update; project-owned docs are copy-if-missing and are not overwritten by default.

## Domain Self-Check Strength

- D8 decision: initial `check-agent-template.*` behavior must be advisory-first.
- Advisory checks may report missing scaffold, weak traceability, and unmapped REQ / TC links, but should not block by default unless the command itself fails to parse or run.
- Promotion from advisory to gate requires at least one real derived agent project validation and a later proposal / version note.

## Domain Template Role

- Downstream role: this repository receives common methodology from `ai-project-template` and does not edit L1 synced files in place.
- Upstream role: this repository owns L2 agent standards under `template-docs/agent-system/` and will later provide the L2 → L3 path for agent-derived projects.
- Cross-domain improvements discovered here should be proposed upstream to `ai-project-template`; agent-specific standards stay in this repository.

## Version Semantics

- `VERSION` is owned by this domain template and records the domain template version.
- `CHANGELOG.md` is owned by this domain template and records domain template evolution; template sync does not overwrite it.
- `TEMPLATE-BASE.md` records the inherited ai-project-template version used for methodology sync audit.
- Template sync commits keep the message format `sync template v1.57.1 from ai-project-template`.
