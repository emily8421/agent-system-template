# Multi Agent Profile（Stub）

> 层归属：L2 领域自有。**待真实多 agent 项目验证后补全。** 当前仅作为占位与评估入口，不应作为强制标准件下发；具体项目采用前必须先形成项目级设计和风险确认。

## 当前状态

- 状态：stub / 待验证。
- 原因：当前领域模板尚无真实 multi-agent 项目验证，不宜把角色编排、通信协议、仲裁机制或 supervisor 策略写成既定标准。
- 使用边界：可作为评估清单，不能替代 `docs/design/agent-architecture.md`、`tool-permission-model.md`、`trace-and-replay.md`、`hitl-and-safety.md` 的项目级填写。

## 适用信号（候选）

可能需要 multi-agent 的信号：

- 多个自治角色有不同目标、工具权限或 memory 边界。
- 需要并行执行、互相评审、任务交接、仲裁或 supervisor。
- 单 agent 已无法稳定解释职责边界、失败来源或安全决策。

## 设计前置

采用前至少补齐：

- 角色清单：每个 agent 的职责、输入、输出、权限和禁止项。
- 协作协议：消息格式、交接条件、终止条件、冲突处理。
- Supervisor / 仲裁：谁能暂停、回滚、降级或终止任务。
- Trace：跨 agent 的 Run ID、Step ID、消息链和工具调用链。
- HITL：跨 agent 高风险动作如何归并到人工确认。
- Memory：共享 memory 与私有 memory 的边界、污染防护和清理。

## 待验证问题

| ID | 待验证项 | 建议验证方式 |
|---|---|---|
| MA-C1 | 多 agent 协作是否真的优于 single-agent + tools | 用同一任务集对比完成率、成本、失败归因 |
| MA-C2 | supervisor 是否需要独立 agent | 从人工接管和失败回放中提取证据 |
| MA-C3 | agent 间消息是否需要稳定契约 | 用 trace/replay 检查是否可复现和审计 |
| MA-C4 | 共享 memory 是否会造成上下文污染 | 设计污染用例并纳入 eval |

## 后续补全条件

至少一个真实 multi-agent 项目完成以下证据后，再把本 stub 升级为正式 profile：

- 项目级 multi-agent 架构设计已落盘。
- Trace/replay 能复现跨 agent 协作过程。
- Eval task 覆盖协作成功、冲突、越权、降级和人工接管。
- 形成可复用的角色/协作/安全模式，并经领域模板维护者确认。
