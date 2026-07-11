# TEMPLATE-BASE

> 本文件是 `agent-system-template` 领域模板的溯源记录，**不参与母模板下行同步**（不在 `template-sync.json` 清单），由本领域模板自行维护，sync 不会覆盖。

## 继承关系

- **领域模板**：agent-system-template（本仓）
- **继承自（母模板）**：[ai-project-template](https://github.com/emily8421/ai-project-template)
- **base version**：`v1.44.3`（2026-07-10 派生时的母模板版本，溯源锚点）
- **当前已同步到**：`v1.45.6`（2026-07-11 下行同步；见 `sync-records/template-sync/2026-07-11-sync-template-v1.45.6.md`）
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
- `VERSION`：每次 sync 后**需恢复为领域版本**（对照本文件「领域模板版本」当前 `v0.1.0`），不保留母模板版本号。
- `CHANGELOG.md`：**接受由母模板 sync 维护**（每次 sync 带入母模板 CHANGELOG）；领域版本演进**只记本文件**，不手动恢复 CHANGELOG——避免每次 sync 后繁琐重建。该取舍待 Batch 3 自动化后重新评估。
- 多级同步与版本保留机制（含 VERSION 自动保留、领域 CHANGELOG）待母模板 inheritance **Batch 3** 落地后自动处理。

多级同步自动化、领域模板自检、`new-project --profile` 属 Batch 3 / Batch 4，尚未落地（见母模板 `template-docs/domain-templates.md` §4 / §7）。
