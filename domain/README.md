# domain/ — agent 领域标准件（L2 自有）

> 层归属：L2 领域自有。本目录是 `agent-system-template` 叠加在母模板通用方法论之上的**唯一领域目录**（根级保留名，v1.75.0 三层布局，见 `template-docs/profiles/domain-templates.md` §5.1）：母模板同步永不触碰，L3 派生项目以 `domain/` 为覆盖同步区接收。本仓根目录其余的 `ai/`、`template-docs/`、`scripts/`、`docs/` 骨架是**继承自母模板的通用方法论**（L1 下发、按 `template-sync.json` 同步、不在本仓直接改）。
> 例外领域件：`ai/domain-rules.md`（领域规则种子）不在本目录——规则文件必须活在 `ai/` 规则层才能被 AI 入口路由（v1.60.0 机制）。

## 内容导览

| 路径 | 职责 |
|---|---|
| `layer-map.md` | 层映射表：路径 → 层类（L1/L2/L3）→ 同步 / 编辑策略；AI 进项目查此表判层 |
| `scenarios.md` | L2→L3 场景剧本（创建、同步、整理、自检、回流、发布后下游同步） |
| `scaffold/agent-system-checklist.md` | agent 项目派生与验收检查表 |
| `scaffold/docs/design/*.md`（5） | agent 项目设计骨架：架构 / 工具权限 / memory-state / trace-replay / HITL-safety（L3 项目派生后 copy-if-missing 到项目 `docs/design/`，**不绑定具体 runtime**） |
| `scaffold/docs/research/agent-eval-plan.md` | agent eval 计划骨架（任务集 / 轨迹 / 准确率 / 成本延迟） |
| `standards/profiles/single-agent.md` | 单 agent 形态 profile（默认正式标准件，适合一条主线的 agent 项目） |
| `standards/profiles/multi-agent.md` | 多 agent 形态 profile stub（待真实多 agent 项目验证后补全） |
| `standards/doc-standards/agent-*.md`（6） | agent 文档审计基线（架构 / 权限 / memory / trace / HITL / eval） |
| `../ai/domain-rules.md` | 领域规则种子（agent 实现规则 + 工具安全规则，`domain/` 的唯一例外件） |
| `../domain-template-sync.json` | L2→L3 领域下发清单 |
| `../scripts/sync-domain-template.*` | 领域模板到 agent 派生项目的同步入口 |
| `../scripts/check-domain-derived-sync.*` | 领域下发状态检查 |
| `../scripts/check-agent-template.*` | agent scaffold / 追溯 advisory 自检 |

## 设计边界

- **必须覆盖**（具体项目填写时）：agent 角色边界、tool 权限矩阵、memory 生命周期、trace / replay、eval 指标、human-in-the-loop、prompt injection / 数据泄露 / 越权风险。
- **暂不覆盖**（不绑定）：具体 agent runtime 框架（LangGraph / AutoGen / CrewAI 等）、具体模型供应商、具体向量库 / memory backend、具体 UI、具体业务 prompt。

## 下发语义（L2→L3）

`domain/` 整目录对 L3 是**同路径覆盖同步区**（source = target，见 `domain-template-sync.json`）：L2 侧维护者可直接编辑；L3 侧 `domain/` 不得直改，领域件的项目化改写走项目自有文档（`docs/`、`ai/project-rules.md`）。`scaffold/docs/*` 骨架仅作领域参考件随 `domain/` 下行；L3 项目自己的 `docs/design/*`、`docs/research/*` 是项目事实，由创建流程从 scaffold 种子化、之后**永不覆盖**。

领域派生项目**单源锚定本领域模板（L2）**：L1 母模板通用方法论已由 `agent-system-template` 吸收并随领域件一起下发，L3 只从 L2 同步、不直连 L1（详见 `scenarios.md` §1）。

## 领域自检强度（D8）

`check-agent-template.*` 起步为 advisory：发现 scaffold 缺失、追溯弱项或映射不完整时输出告警和修复建议，默认不阻断派生项目工作流。只有脚本解析 / 运行错误可直接失败。将 advisory 升为 gate 需要至少一个真实 agent 派生项目验证后另行提案确认。

## 形态选型

| 形态 | 适用 | 当前状态 |
|---|---|---|
| Single agent | 一个 agent 可承担主要规划、执行、工具路由、memory 和 eval；工具权限可由单一矩阵管住 | 正式标准件，优先使用 |
| Multi agent | 多个自治 agent 需要并行、交接、互评、仲裁或 supervisor | Stub；待真实项目验证后补全，不作为强制标准 |

> 【撰写提要：具体 agent 项目先按 `standards/profiles/single-agent.md` 判断是否足够；只有出现明确多 agent 信号时，才进入 `standards/profiles/multi-agent.md` 的候选评估。】

## AI 读取路径（D7）

启动入口按仓库角色区分：

- **L2 领域模板仓（agent-system-template）**：完成母模板 `ai/index.md` / `ai/rules-core.md` 启动路由后，读 `TEMPLATE-BASE.md` 与本目录 `layer-map.md`。
- **L3 agent 派生项目**：以根 `CLAUDE.md` 为 AI 启动入口（→ `TEMPLATE-BASE.md` → `ai/project-rules.md`（含领域规则项目化实例）→ `domain/README.md` / `domain/layer-map.md`）。

随后（两类仓库通用）：

1. 读 `TEMPLATE-BASE.md` 与 `domain/layer-map.md`，确认仓库角色与 L1 / L2 / L3 归属。
2. 读本文件与对应形态 profile：默认先读 `standards/profiles/single-agent.md`；只有出现明确多 agent 信号时才读 `standards/profiles/multi-agent.md`。
3. 在 agent 设计、实现、工具权限、memory、trace、HITL、eval、同步或自检任务前读领域规则（L2 读 `ai/domain-rules.md`；L3 读 `ai/project-rules.md` 中的领域规则项目化实例）。
4. 在生成或审计 agent 文档前读取对应 `domain/standards/doc-standards/agent-*.md` 领域文档标准。

## 与母模板文档的关系

- 通用需求 / 架构 / 技术 / 数据 / 接口 / 验证链路（`docs/00-09`）继承母模板。
- 本目录只补 agent 专用维度，不替代 `docs/00-09`；具体项目同时维护两者，且 agent 标准件必须能追溯到 `docs/02-srs.md` 的 REQ-ID。
