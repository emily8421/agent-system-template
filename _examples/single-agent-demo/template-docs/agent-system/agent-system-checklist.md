# Agent System 检查表

> 具体 agent 项目从本领域模板派生后，按本表逐项确认；领域模板自身演进也对照本表。

## 派生前

- [ ] 确认是 agent 类系统（planner / executor / tool use），非纯 CRUD / 纯检索
- [ ] 确认需要复用本领域标准件（架构 / 权限 / memory / eval）；否则直连母模板
- [ ] `TEMPLATE-BASE.md` 已记录派生来源与 base version

## 形态 Profile（对照 `profiles/`）

| 检查项 | Single agent | Multi agent |
|---|---|---|
| 适用判断 | [ ] 一个 agent 足以承担主流程 | [ ] 已证明需要多个自治 agent |
| 职责边界 | [ ] planner / executor / router / memory / evaluator 在单 agent 内可审计 | [ ] 每个 agent 的目标、输入、输出、权限清晰 |
| 协作复杂度 | [ ] 无并行协作、交接、互评或仲裁需求 | [ ] 协作协议、supervisor / 仲裁和终止条件已设计 |
| 当前状态 | [ ] 可按正式标准件执行 | [ ] 仅按 stub 评估，需真实项目验证后再固化 |

## 架构（对照 `docs/design/agent-architecture.md`）

- [ ] 角色已定义：planner / executor / tool router / memory / evaluator / supervisor
- [ ] 角色间边界与数据流清晰
- [ ] 失败 / 超时 / 死循环兜底

## 工具权限（对照 `docs/design/tool-permission-model.md`）

- [ ] 工具注册清单 + 每个工具的权限级别
- [ ] 危险操作（写文件 / 发请求 / 花钱 / 删数据）需确认或沙箱
- [ ] 越权调用被拒绝并记录

## Memory / state（对照 `docs/design/memory-and-state.md`）

- [ ] 短期上下文 / 长期记忆边界清晰
- [ ] 敏感数据不入记忆或脱敏
- [ ] 状态持久化与清理策略明确

## Trace / replay（对照 `docs/design/trace-and-replay.md`）

- [ ] Trace ID / Run ID / Step ID 可串起一次 agent 执行
- [ ] 工具调用、权限判定、memory 读写、eval 结果进入 trace
- [ ] Replay 模式已分级：dry / sandbox / live（live 默认禁止或需人工确认）
- [ ] 失败可归因到规划、工具、memory、eval 或外部依赖
- [ ] 敏感数据脱敏、摘要化或拒绝记录

## Eval（对照 `docs/research/agent-eval-plan.md`）

- [ ] 任务集覆盖核心场景
- [ ] 轨迹可回放 / 可归因
- [ ] 工具调用准确率、拒答 / 越权率、成本 / 延迟有指标

## HITL / Safety（对照 `docs/design/hitl-and-safety.md`）

- [ ] 高风险动作（花钱 / 删改数据 / 对外写入 / 权限变更）必须人工确认或沙箱
- [ ] 人工拒绝后不得换路径绕过确认
- [ ] 人工接管、暂停、恢复、回滚和降级路径明确
- [ ] prompt injection 防护
- [ ] 数据泄露路径已评估
- [ ] human-in-the-loop 审批点明确
