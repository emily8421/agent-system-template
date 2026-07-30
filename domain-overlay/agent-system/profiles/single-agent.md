# Single Agent Profile

> 层归属：L2 领域自有。具体 agent 项目采用单 agent 形态时，按本 profile 裁剪 agent 标准件；不绑定具体 runtime。

## 适用条件

适合使用 single-agent 形态的项目：

- 一个 agent 可以承担主要规划、执行、工具路由和结果评估。
- 工具数量和权限边界可由一张 tool registry / permission matrix 管住。
- 任务流程以单条主线为主，不需要多个自治 agent 并行协作。
- 失败处理可以通过重试、降级、人工确认或人工接管完成。

不适合的信号：

- 多个 agent 需要独立目标、独立 memory 或互相评审。
- 需要并行执行、角色协商、任务拍卖、长期协作状态或复杂 supervisor。
- 单 agent 已经无法解释失败来源或权限边界。

## 必填标准件

| 标准件 | single-agent 填写重点 |
|---|---|
| `docs/design/agent-architecture.md` | 说明一个 agent 内部如何划分 planner / executor / tool router / memory / evaluator 职责 |
| `docs/design/tool-permission-model.md` | 以工具为中心定义权限级别、危险操作确认和审计 |
| `docs/design/memory-and-state.md` | 区分任务内上下文、跨任务记忆、状态恢复和清理 |
| `docs/design/trace-and-replay.md` | 记录单 agent 的每一步决策、工具调用、memory 读写和 eval 结果 |
| `docs/design/hitl-and-safety.md` | 定义高风险动作的人工确认、接管、回滚和 injection 防护 |
| `docs/research/agent-eval-plan.md` | 以任务集覆盖主流程、越权拒绝、失败兜底和成本/延迟 |

## 推荐结构

```text
agent runtime boundary
  ├─ planner policy
  ├─ executor loop
  ├─ tool router + permission check
  ├─ memory adapter
  ├─ evaluator / termination policy
  └─ trace writer
```

> 【撰写提要：具体项目可用代码模块、服务或配置映射上述职责；没有独立模块时，也要说明职责如何在实现中分离。】

## Readiness Gate

- REQ-ID 已映射到 agent 能力和工具能力。
- Tool registry 已列出所有可调用工具和危险操作。
- HITL gate 覆盖高风险工具与不确定结果。
- Trace/replay 能定位失败发生在规划、工具、memory、eval 或外部依赖。
- Eval task 覆盖成功路径、拒绝路径、越权路径和降级路径。

## 升级到 Multi Agent 的触发

出现以下任一情况时，应重新评估是否切换到 multi-agent profile：

- 需要多个自治角色并行处理不同目标。
- 需要 agent 之间的任务交接、互评、仲裁或 supervisor。
- 单 agent prompt / policy 过大，导致职责边界不可审计。
- trace 中失败频繁来自角色混杂或上下文污染。
