# Agent System 检查表

> 具体 agent 项目从本领域模板派生后，按本表逐项确认；领域模板自身演进也对照本表。

## 派生前

- [ ] 确认是 agent 类系统（planner / executor / tool use），非纯 CRUD / 纯检索
- [ ] 确认需要复用本领域标准件（架构 / 权限 / memory / eval）；否则直连母模板
- [ ] `TEMPLATE-BASE.md` 已记录派生来源与 base version

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

## Eval（对照 `docs/research/agent-eval-plan.md`）

- [ ] 任务集覆盖核心场景
- [ ] 轨迹可回放 / 可归因
- [ ] 工具调用准确率、拒答 / 越权率、成本 / 延迟有指标

## 安全

- [ ] prompt injection 防护
- [ ] 数据泄露路径已评估
- [ ] human-in-the-loop 审批点明确
