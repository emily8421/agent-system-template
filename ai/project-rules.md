# 项目专属规则

> 本文件记录 `agent-system-template` 仓库自身的维护约束，不参与母模板 L1 同步，也不参与 L2→L3 下行同步。
> 本仓身份是 L2 领域模板；真正业务项目的 L3 事实应由派生项目填写，不能在本仓预填。

## 0. 项目标识

- 项目名称：`agent-system-template`
- 代号 / 缩写：`agent-system-template` / `agent-system`
- 仓库角色：L2 领域模板，继承 L1 母模板 `ai-project-template`，向 L3 agent 派生项目下发领域标准件。
- 当前领域模板版本：根 `VERSION`，当前为 `v0.4.2`。
- 当前继承母模板版本：`TEMPLATE-BASE.md` 的 `Current synced template version`，当前为 `v1.67.0`。
- 分层权威入口：`TEMPLATE-BASE.md` 与 `template-docs/agent-system/layer-map.md`。

## 1. Phase 边界

当前阶段：Domain Template `v0.4.x`，L2 机制稳定化与真实派生验证期。

允许：

- 维护 L2 领域自有文件：`domain-overlay/*`（rules / doc-standards / agent-system）、`domain-template-sync.json`、领域同步 / 检查脚本、`_examples/*`、`_proposals/*`。
- 对本仓 L2 版本记录做维护：`VERSION`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md`、`TEMPLATE-BASE.md`、`sync-records/template-sync/*`。
- 运行 L1→L2 母模板同步与 L2→L3 领域同步检查，按同步记录留痕。
- 为通用问题起草去项目化 `_proposals/TEMPLATE-UPGRADE-*.md`，成熟后回流母模板或领域模板维护流程。

禁止：

- 不得把 L3 业务需求、客户场景、具体数据库 / API / UI 项目事实写进本仓 `docs/00-09`。
- 不得把 `docs/00-09` scaffold 占位当成本仓已确认业务事实。
- 不得直接修改 L1 同步文件并长期保留漂移；若为解除同步阻塞做本地兼容修复，必须在同步记录中说明并形成上游回流提案。
- 不得把 advisory 检查结果写成已阻断或已验收，除非对应脚本 / CI 已升级为 gate 并通过。

下一阶段预告：

- 通过至少一个真实 L3 agent 派生项目验证 L2→L3 同步、文档骨架和 advisory 检查。
- 根据真实验证结果决定哪些 agent 领域 advisory 可升级为 gate。
- 将已验证的跨领域问题回流到母模板，并在母模板合并后再下行同步。

## 2. 技术栈约束

- 本仓不是运行型前后端应用；主要产物是 Markdown 方法论、JSON manifest、PowerShell / Bash 同步与检查脚本、最小示例项目。
- 脚本需兼容 Windows PowerShell 与 Git Bash；Windows 兼容问题优先用 PowerShell fallback 复现和验证。
- `_examples/single-agent-demo/` 可使用 Python 标准库测试作为领域标准件 smoke，但不得把示例实现扩展成正式产品能力。
- 不引入新运行依赖、包管理器、外部服务、LLM 凭据、数据库或前端框架，除非先形成明确维护计划并经人工确认。

## 2.5 运行环境与资源约束

- 本机环境文档：本仓作为 L2 模板仓，默认豁免 `docs/env/local-env.md`；只有当任务进入真实运行依赖评估、重型示例或可点击 Demo 时，再运行 `scripts/collect-env.ps1` 并补环境事实。
- 技术环境评估报告：常规文档 / 同步脚本维护不需要；若新增真实运行依赖或重型示例，先执行技术环境评估并写入 `docs/research/`。
- Demo 阶段必须能在本机运行的部分：同步 / 检查脚本与 `_examples/single-agent-demo` 的最小测试。
- 允许降级 / Mock / 远程运行的部分：仅限示例项目中的 Mock agent 行为；必须显式标记为示例或 Mock。
- 禁止在本机运行的重资源部分：本阶段不引入本机模型、数据库、容器集群或长期后台服务。
- 是否允许使用公司服务器：默认不需要；如需远端资源，必须先人工确认用途、权限和成本。
- 若需服务器，资源申请口径：待具体任务确认。

## 2.6 图表格式偏好

- 图表格式：`mermaid`。
- 仅当 L2 标准件需要表达 agent 架构、工具调用、状态流或 trace / replay 时使用图表；不为 scaffold 占位强行补图。

## 2.7 UI 原型策略

- 是否涉及可点击 UI：否。
- 是否需要开发前可视化原型：豁免。
- 豁免理由：本仓当前阶段是 agent 领域模板与脚本机制维护，不交付前端界面；如未来新增可点击 agent console 示例，应另行补 UI brief、交互设计和原型策略。

## 2.8 项目版本管理

- 根 `VERSION` 记录 `agent-system-template` 领域模板自身版本。
- `CHANGELOG.md` 与 `CHANGELOG-PLAIN.md` 记录领域模板自身演进。
- `TEMPLATE-BASE.md` 记录继承的母模板版本与同步时间。
- `upstream/CHANGELOG.md` 与 `upstream/CHANGELOG-PLAIN.md` 是母模板发布历史的只读继承参考。
- L2 版本递增遵循 `PATCH / MINOR / MAJOR`：兼容修复为 PATCH；新增领域标准件或下游采用面为 MINOR；不兼容分层 / 同步机制变化为 MAJOR。
- 新增 `_proposals/` 草案默认不递增版本；只有合并到 L2 同步范围并改变下游行为时才递增。

## 3. 项目形态与文档裁剪

- 是否有持久化存储：无。`docs/06-db-design.md` 在本仓保留为 L3 scaffold，不作为本仓当前数据库设计事实。
- 是否有对外接口：无稳定服务 API。`docs/07-api-spec.md` 在本仓保留为 L3 scaffold；脚本命令契约以脚本帮助、README、同步记录和测试结果为准。
- 演示形态：不需演示；仅保留脚本 smoke 与 `_examples/single-agent-demo/` 作为领域标准件验证样例。
- 前端交互设计：豁免，当前无 UI 交付。
- UI 原型策略：豁免，见 §2.7。
- 通用详细设计：L2 领域标准件已放在 `template-docs/agent-system/docs/design/*`；根 `docs/design/*` 留给 L3 派生项目。
- 需要保留的代码 / 资源目录：`scripts/`、`tests/`（如存在）、`_examples/`、`domain-overlay/`（rules / doc-standards / agent-system）、`sync-records/`、`upstream/`、`_proposals/`。

## 4. 目录规范的项目特例

- `domain-overlay/`：L2 agent 领域增量集中区（rules / doc-standards / agent-system）；分层入口见 `domain-overlay/README.md` 与 `domain-overlay/agent-system/layer-map.md`。
- `domain-template-sync.json`：L2→L3 下行同步 manifest。
- `sync-records/template-sync/`：L1→L2 母模板同步运行记录。
- `upstream/`：L1 母模板 changelog 继承参考。
- `_examples/`：领域标准件验证样例，不是本仓产品实现。

## 5. 编码约定与禁区

### 5.1 既有约定

- PowerShell 脚本保持 Windows PowerShell 5.1 兼容，优先显式 UTF-8 输出，避免依赖交互式 shell 状态。
- Bash 脚本保持 Git Bash / MSYS 路径守卫语义，成功路径输出摘要，失败路径保留可定位片段。
- Manifest 使用 JSON，避免用非结构化文本推断同步清单。
- 示例项目保持最小可验证，不引入真实外部服务或长期凭据。

### 5.2 禁区

- 不得在未确认前安装依赖、提交、推送、创建 / 合并 PR、删除分支或执行破坏性命令。
- 不得记录 token、账号密码、客户敏感数据或本机私有路径。
- 不得把 L1 同步文件的本地修复长期停留为未回流差异。
- 不得把 L2 领域标准件自动写入 L3 项目事实，除非 L3 同步策略明确为 `copy-if-missing` 且用户确认。

## 6. AI 修改确认规则

- AI 在进行任何文件新增、修改、删除、重命名、格式化、批量替换前，必须先说明目的、影响范围、预计文件、预计变更摘要、风险与验证方式，并等待用户明确确认后再执行。
- AI 在运行任何可能写入文件、安装依赖、生成构建产物、修改配置、提交代码或改变项目状态的命令前，必须先询问用户确认。
- 低风险只读检查可合并执行；命令失败、超时、权限不足、sandbox / network 错误或 CI pending 时必须先停止汇报。
- `.ai/session-handoff.md` 是本地续接文件，不进入提交；长期事实必须回写正式文档、同步记录、提案或 Git 历史。
