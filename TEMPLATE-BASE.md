# TEMPLATE-BASE

> 本文件是 `agent-system-template` 领域模板的溯源记录，**不参与母模板下行同步**（不在 `template-sync.json` 清单），由本领域模板自行维护，sync 不会覆盖。

## 继承关系

- **领域模板**：agent-system-template（本仓）
- **继承自（母模板）**：[ai-project-template](https://github.com/emily8421/ai-project-template)
- **base version**：`v1.44.3`（2026-07-10 派生时的母模板版本）
- 派生命令：`new-project.sh agent-system-template --local`（来源 local = ai-project-template v1.44.3）

## 领域模板版本

- 当前：`v0.1.0`（2026-07-10，领域 scaffold MVP 初版）
- 版本演进：
  - `v0.1.0`：从母模板 v1.44.3 派生；叠加 agent scaffold MVP（架构 / 工具权限 / memory-state / eval）。

## 叠加的标准件范围

继承母模板通用方法论之外，本领域模板叠加（见 `template-docs/agent-system/`）：

- Agent 架构（planner / executor / tool router / memory / evaluator）
- Tool 权限模型（注册 / 边界 / 危险操作确认 / 沙箱审计）
- Memory / state（短期上下文 / 长期记忆 / 持久化 / 清理）
- Agent eval（任务集 / 轨迹评估 / 工具调用准确率 / 成本延迟）

## 同步关系

- 本仓对母模板是**下游**：通过 `scripts/sync-template.sh` 接收母模板通用方法论更新。
- 本仓对具体 agent 项目是**上游**：具体项目从本仓派生并同步 agent 标准件。

### ⚠️ 版本治理限制（待母模板 inheritance Batch 3）

当前 `sync-template.sh` 按两端校验（母模板 ↔ 派生），`VERSION` 与 `CHANGELOG.md` 在 sync 清单内，sync 后会被母模板覆盖。因此：

- 领域模板**自身版本以本文件（TEMPLATE-BASE.md）为权威溯源**——本文件不在 sync 清单，不被覆盖。
- 根目录 `VERSION` / `CHANGELOG.md` 在每次 sync 后需对照本文件恢复；多级同步与版本保留机制待母模板 inheritance **Batch 3** 落地后自动处理。

多级同步自动化、领域模板自检、`new-project --profile` 属 Batch 3 / Batch 4，尚未落地（见母模板 `template-docs/domain-templates.md` §4 / §7）。
