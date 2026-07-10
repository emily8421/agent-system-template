# agent-system-template

面向 **agent 系统**的领域模板，继承自 [`ai-project-template`](https://github.com/emily8421/ai-project-template)（base version 见 `TEMPLATE-BASE.md`）。它在母模板通用方法论之上，叠加 agent 类系统专用的标准件（架构 / 工具权限 / memory-state / eval）。

## 这是什么

- **领域模板**（domain template），不是普通业务项目。定位见母模板 `template-docs/domain-templates.md`：母模板 → **领域模板（本仓）** → 具体 agent 项目；两层是默认主路径，领域模板是可选增强。
- 服务于**多个同类 agent 项目**复用同一套 agent 标准件；单个 agent 项目若无需复用，直连母模板即可。
- 叠加的标准件见 `template-docs/agent-system/`（架构 / 工具权限模型 / memory-state / eval 计划 + 检查表），不绑定具体 runtime。

## 怎么用（派生具体 agent 项目）

从本领域模板派生具体 agent 项目（操作见母模板 `scenario-guides.md` A20 + 本仓 `template-docs/agent-system/agent-system-checklist.md`）：

- 继承母模板通用方法论 + 本领域模板的 agent 标准件
- 填入业务事实（需求 / 真实工具 / 数据 / 账号权限 / 验收用例）

## 与母模板关系

- **继承**：本仓通过 `TEMPLATE-BASE.md` 溯源母模板版本；通用方法论经 `sync-template` 下行接收（详见母模板 `template-docs/domain-templates.md` §4）。
- **回流**：本仓沉淀的跨领域通用经验，经提案回流母模板。
- ⚠️ 当前 sync 按两端校验（多级同步待母模板 inheritance Batch 3）；`VERSION`/`CHANGELOG.md` 在 sync 清单内会被覆盖，**领域模板自身版本以 `TEMPLATE-BASE.md` 为权威溯源**。

## 当前状态

- 版本：`v0.1.0`（领域 scaffold MVP 初版；详见 `TEMPLATE-BASE.md`）
- 状态：候选 / 演进中（对应母模板 inheritance 提案 Batch 2）

## 目录速览

| 路径 | 作用 |
|---|---|
| `TEMPLATE-BASE.md` | 领域模板溯源（继承自 ai-project-template 的 base version + 版本演进，不被 sync 覆盖） |
| `template-docs/agent-system/` | agent 领域标准件（架构 / 工具权限 / memory-state / eval + 检查表） |
| `ai/` `template-docs/` `scripts/` `docs/` 骨架 | 继承自母模板的通用方法论（随 sync 刷新） |
| `docs/` | 具体派生项目填入的业务事实 |

> 完整方法论、AI 行为规则、场景引导均继承自母模板 `ai-project-template`；本 README 只说明领域模板身份，不重复母模板通用说明。
