# Trace / Replay 设计

> 【撰写提要：具体 agent 项目填写本文件，定义 agent 执行轨迹、回放方式、失败归因和审计保留策略。不绑定具体 runtime。需追溯到 `docs/02-srs.md` 的 REQ-ID、`docs/09-verification.md` 的 TC-ID。】

## 目标与边界

- Trace 目标：记录 agent 从输入到输出的关键决策、工具调用、权限判定、memory 读写和评估结果，支持审计、调试、回归与失败归因。
- Replay 目标：在可控环境中复现一次执行，验证修复、比较策略变化或定位不稳定行为。
- 非目标：不记录密钥、完整敏感原文、不可公开客户数据；不把 trace 当作长期业务事实库。

> 【撰写提要：说明本项目为什么需要 trace/replay，哪些场景必须可回放，哪些内容因隐私或成本只保留摘要。】

## Trace 粒度

| 字段 | 必填 | 说明 |
|---|---|---|
| Trace ID / Run ID | 是 | 一次用户请求或任务执行的唯一标识 |
| Step ID | 是 | planner / executor / tool / memory / evaluator 的步骤序号 |
| Actor | 是 | 执行步骤的角色或子 agent |
| Input 摘要 | 是 | 输入摘要或脱敏片段；不得保留敏感明文 |
| Decision / Rationale | 视风险 | 关键决策依据，允许摘要 |
| Tool call | 调用工具时必填 | 工具名、参数摘要、权限级别、确认结果 |
| Memory access | 读写记忆时必填 | memory key / 来源 / 写入原因 / 清理策略 |
| Output 摘要 | 是 | 步骤结果、错误、拒绝或降级 |
| Cost / Latency | 推荐 | token、调用次数、耗时、重试次数 |
| Redaction marker | 是 | 标明脱敏、截断或未记录原因 |

## Replay 模式

| 模式 | 用途 | 约束 |
|---|---|---|
| Dry replay | 只回放决策与工具选择，不执行真实副作用 | 默认推荐；适合调试和回归 |
| Sandbox replay | 在沙箱或 mock 工具中执行 | 适合验证工具参数、权限和异常路径 |
| Live replay | 对真实外部系统重放 | 默认禁止；仅在人工确认、限额和回滚策略明确后允许 |

> 【撰写提要：列出本项目允许的 replay 模式、触发条件、确认方式和禁止路径。】

## 失败归因

| 失败类型 | 归因信号 | 后续动作 |
|---|---|---|
| 规划错误 | 任务拆解遗漏、顺序错误、循环 | 调整 planner 策略或任务拆分规则 |
| 工具选择错误 | 工具不匹配、参数错误、权限误判 | 更新 tool registry / permission matrix |
| Memory 错误 | 读取过期记忆、写入不当、未脱敏 | 修正 memory 生命周期与清理规则 |
| Eval 错误 | 错误通过、错误拒绝、未触发人工确认 | 更新 eval task 与 HITL gate |
| 外部依赖错误 | API 失败、超时、限流、不可用 | 增加重试、降级或人工接管 |

## 隐私与保留

- Trace 默认记录摘要、ID 和判定，不记录密钥、账号密码、token、客户敏感原文。
- Replay 数据集应可脱敏、可最小化、可删除。
- 保留周期、清理责任和调试访问权限必须写明。

> 【撰写提要：填写保留周期、清理命令或人工流程、谁可查看 trace/replay 证据。】

## 与 docs/00-09 的追溯

- REQ-ID / NFR：
- 关联工具权限设计：`docs/design/tool-permission-model.md`
- 关联 memory 设计：`docs/design/memory-and-state.md`
- 关联 eval / TC-ID：`docs/research/agent-eval-plan.md`、`docs/09-verification.md`

> 【撰写提要：列出本文件承接的 REQ-ID、NFR、Phase 和验证入口；不得新增 `docs/03-prd.md` 未批准需求。】
