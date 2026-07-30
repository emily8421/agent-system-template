# Agent System 领域标准件

> 本目录是 `agent-system-template` 领域模板叠加的 agent 专用标准件，继承自母模板 `ai-project-template` 通用方法论之外的内容。具体 agent 项目派生后按各文件【撰写提要】填写，**不绑定具体 runtime**。

## 文件导航

| 文件 | 职责 |
|---|---|
| `agent-system-checklist.md` | agent 项目派生与验收检查表 |
| `docs/design/agent-architecture.md` | agent 架构（planner / executor / tool router / memory / evaluator 角色与边界） |
| `docs/design/tool-permission-model.md` | 工具权限模型（注册 / 边界 / 危险操作 / 沙箱 / 审计） |
| `docs/design/memory-and-state.md` | memory / state 设计（短期 / 长期 / 持久化 / 清理 / 可解释） |
| `docs/design/trace-and-replay.md` | trace / replay 设计（执行轨迹、回放模式、失败归因、隐私保留） |
| `docs/design/hitl-and-safety.md` | HITL / safety 设计（人工确认、接管、回滚、prompt injection、数据泄露防护） |
| `docs/research/agent-eval-plan.md` | agent eval 计划（任务集 / 轨迹 / 准确率 / 成本延迟） |
| `profiles/single-agent.md` | 单 agent 形态 profile（默认正式标准件，适合一条主线的 agent 项目） |
| `profiles/multi-agent.md` | 多 agent 形态 profile stub（待真实多 agent 项目验证后补全） |
| `layer-map.md` | 层映射表：路径 → 层类（L1/L2/L3）→ 同步 / 编辑策略；AI 进项目查此表判层（见 buildout 提案 §4.5） |
| `../../ai/agent-rules/agent-implementation-rules.md` | agent 实现规则标准件 |
| `../../ai/agent-rules/tool-safety-rules.md` | agent 工具安全规则标准件 |
| `../../ai/doc-standards/agent-*.md` | agent 文档审计基线 |
| `../../domain-template-sync.json` | L2→L3 领域下发清单 |
| `../../scripts/sync-domain-template.*` | 领域模板到 agent 派生项目的同步入口 |
| `../../scripts/check-domain-derived-sync.*` | 领域下发状态检查 |
| `../../scripts/check-agent-template.*` | agent scaffold / 追溯 advisory 自检 |

## 设计边界

- **必须覆盖**（具体项目填写时）：agent 角色边界、tool 权限矩阵、memory 生命周期、trace / replay、eval 指标、human-in-the-loop、prompt injection / 数据泄露 / 越权风险。
- **暂不覆盖**（不绑定）：具体 agent runtime 框架（LangGraph / AutoGen / CrewAI 等）、具体模型供应商、具体向量库 / memory backend、具体 UI、具体业务 prompt。

## AI 读取路径（D7）

Agent 相关任务在完成母模板 `ai/index.md` / `ai/rules-core.md` 启动路由后，按以下顺序读取领域 overlay：

1. 读 `TEMPLATE-BASE.md` 与 `template-docs/agent-system/layer-map.md`，确认当前仓库是 L2 领域模板还是 L3 agent 派生项目。
2. 读本文件与对应形态 profile：默认先读 `profiles/single-agent.md`；只有出现明确多 agent 信号时才读 `profiles/multi-agent.md`。
3. 在 agent 设计、实现、工具权限、memory、trace、HITL、eval、同步或自检任务前读取 `ai/agent-rules/` 中的相关规则文件。
4. 在生成或审计 agent 文档前读取对应 `ai/doc-standards/agent-*.md` 领域文档标准。

## L2→L3 同步机制

领域派生项目先完成母模板 L1 同步，再从本领域模板叠加 agent overlay：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\sync-domain-template.ps1 -Source <agent-system-template> -Target <agent-project> -DryRun
powershell -ExecutionPolicy Bypass -File scripts\sync-domain-template.ps1 -Source <agent-system-template> -Target <agent-project> -Commit
powershell -ExecutionPolicy Bypass -File scripts\check-domain-derived-sync.ps1 -Source <agent-system-template> -Target <agent-project> -Advisory
powershell -ExecutionPolicy Bypass -File scripts\check-agent-template.ps1 -Target <agent-project>
```

策略：`domain-template-sync.json` 中 domain-owned 文件可更新；项目事实 docs 使用 copy-if-missing，默认不覆盖已有需求、设计、REQ-ID、TC-ID 或测试事实。

## 领域自检强度（D8）

Batch 3b 的 `check-agent-template.*` 起步为 advisory：发现 scaffold 缺失、追溯弱项或映射不完整时输出告警和修复建议，默认不阻断派生项目工作流。只有脚本解析 / 运行错误可直接失败。将 advisory 升为 gate 需要至少一个真实 agent 派生项目验证后另行提案确认。

## 形态选型

| 形态 | 适用 | 当前状态 |
|---|---|---|
| Single agent | 一个 agent 可承担主要规划、执行、工具路由、memory 和 eval；工具权限可由单一矩阵管住 | 正式标准件，优先使用 |
| Multi agent | 多个自治 agent 需要并行、交接、互评、仲裁或 supervisor | Stub；待真实项目验证后补全，不作为强制标准 |

> 【撰写提要：具体 agent 项目先按 `profiles/single-agent.md` 判断是否足够；只有出现明确多 agent 信号时，才进入 `profiles/multi-agent.md` 的候选评估。】

## 与母模板文档的关系

- 通用需求 / 架构 / 技术 / 数据 / 接口 / 验证链路（`docs/00-09`）继承母模板。
- 本目录只补 agent 专用维度，不替代 `docs/00-09`；具体项目同时维护两者，且 agent 标准件必须能追溯到 `docs/02-srs.md` 的 REQ-ID。
