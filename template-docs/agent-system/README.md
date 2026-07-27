# Agent System 领域标准件

> 本目录是 `agent-system-template` 领域模板叠加的 agent 专用标准件，继承自母模板 `ai-project-template` 通用方法论之外的内容。具体 agent 项目派生后按各文件【撰写提要】填写，**不绑定具体 runtime**。

## 文件导航

| 文件 | 职责 |
|---|---|
| `agent-system-checklist.md` | agent 项目派生与验收检查表 |
| `docs/design/agent-architecture.md` | agent 架构（planner / executor / tool router / memory / evaluator 角色与边界） |
| `docs/design/tool-permission-model.md` | 工具权限模型（注册 / 边界 / 危险操作 / 沙箱 / 审计） |
| `docs/design/memory-and-state.md` | memory / state 设计（短期 / 长期 / 持久化 / 清理 / 可解释） |
| `docs/research/agent-eval-plan.md` | agent eval 计划（任务集 / 轨迹 / 准确率 / 成本延迟） |
| `layer-map.md` | 层映射表：路径 → 层类（L1/L2/L3）→ 同步 / 编辑策略；AI 进项目查此表判层（见 buildout 提案 §4.5） |

## 设计边界

- **必须覆盖**（具体项目填写时）：agent 角色边界、tool 权限矩阵、memory 生命周期、trace / replay、eval 指标、human-in-the-loop、prompt injection / 数据泄露 / 越权风险。
- **暂不覆盖**（不绑定）：具体 agent runtime 框架（LangGraph / AutoGen / CrewAI 等）、具体模型供应商、具体向量库 / memory backend、具体 UI、具体业务 prompt。

## 与母模板文档的关系

- 通用需求 / 架构 / 技术 / 数据 / 接口 / 验证链路（`docs/00-09`）继承母模板。
- 本目录只补 agent 专用维度，不替代 `docs/00-09`；具体项目同时维护两者，且 agent 标准件必须能追溯到 `docs/02-srs.md` 的 REQ-ID。
