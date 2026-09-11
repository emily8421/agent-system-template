# Agent 领域模板架构评估报告

> 类型：分析 / 评估报告（提案 `TEMPLATE-UPGRADE-agent-template-buildout.md` 的前置研究支撑）
> 日期：2026-07-27
> 评估者：AI 架构评估（Claude）
> 状态：**草案 · 待维护者确认**（含建议、候选方案与待确认项，非既成事实）
> 评估对象：`agent-system-template` 领域模板（本仓库）
> 关联：母模板 `ai-project-template` 的 `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md`（三层继承机制，部分落地）

## 0. 评估背景与范围

本报告评估「母模板（ai-project-template）→ agent 领域模板（agent-system-template）→ 派生 agent 类项目」这条三层路径中，**agent 领域模板当前应做成什么样、三层路径如何走通**。

评估基于：本仓库 Git 事实与文件结构、`TEMPLATE-BASE.md` 溯源、母模板 `template-docs/domain-templates.md` 三层方法论、母模板 inheritance 提案的 Batch 落地进展、`ai/commands/domain-template-lab.md` 实验线机制。

**范围限定**：只评估领域模板自身的架构与机制，不涉及具体 agent 业务项目的事实，不绑定具体 runtime / 模型 / 向量库（与 inheritance 提案 §7 一致）。

## 1. 现状诊断：领域模板当前卡在哪

把 agent-system-template 拆成三层来看：

| 层 | 内容 | 状态 |
|---|---|---|
| **继承层**（母模板下发，只读吸收） | `ai/` 通用规则、`docs/00-09` 骨架、`scripts/sync-template.*`、通用 `template-docs/` | ✅ 已通，current synced **v1.57.1**（2026-07-25） |
| **领域骨架层**（agent 标准件） | `template-docs/agent-system/` 6 件 MVP | ✅ inheritance Batch 2 已落地 |
| **领域机制层**（约束下发 + 自检 + 多级同步） | `domain-template-sync.json` / `scripts/sync-domain-template.*` / `scripts/check-domain-derived-sync.*` / 领域自检 / 领域规则标准件 | ❌ **inheritance Batch 3 未落地** |

**根因**：领域机制层缺失，导致领域标准件目前只是「仓库里多出来的几份文档」，**无法真正下发给 agent 派生项目、无法被自检校验、无法约束 agent 项目的 docs 与代码**。这就是「目录架构尚未明确」的本质——不是文件不够，而是**领域标准件和派生项目之间没有通路**。

一句话定性：**现在它是一个「带了 agent 文档的普通派生项目」，还不是真正的「领域模板」**。真正的领域模板 = 通用流水线 × agent 特化，且特化层能自动流到下游项目。

## 2. 架构原则（给领域模板定调）

1. **继承不 fork**。领域层的 `ai/`、docs 骨架、scripts 通用部分 = 母模板下发（只读吸收），领域只**叠加**不**改写**。一旦改写母模板规则就开始漂移，三层退化成三个独立模板，维护成本 ×3。
2. **领域标准件分两类，缺一不可**：
   - **领域文档标准件**（回答「agent 项目的 docs 该长什么样」）：agent-architecture、tool-permission、memory-state、trace-replay、hitl-safety、agent-eval。
   - **领域规则标准件**（回答「AI 在 agent 项目里该怎么干活」）：当前**完全缺失**——没有 `ai/agent-rules/`。这才是约束力的来源。
3. **约束派生项目，而不只是提供模板**。领域模板的价值在「agent 项目 sync 后自动具备研发规范」，所以领域标准件必须进入**领域下行同步清单** + 能被**领域自检**校验。否则它永远只是文档库。
4. **单 / 多 agent 分化放领域模板内部**，不拆两个领域模板。用 profile / 形态区分（领域模板内 `profiles/`，而非新建仓库）。

## 3. 目标目录架构（建议形态）

```text
agent-system-template/（领域模板仓库）
│
├── 【继承层 · 只读，母模板下发，不改写】
│   ├── ai/（通用规则）  template-docs/docs-scaffold/（通用 00-09 骨架）
│   ├── scripts/sync-template.*（从母模板吸收更新，--domain-template 保留领域版本）
│   └── VERSION(v0.1.0) / CHANGELOG → 领域版，sync 不覆盖（已就位）
│
├── 【领域层 · agent 特化，领域模板自有】
│   ├── TEMPLATE-BASE.md                  溯源：母模板 base version + agent 标准件范围（已就位）
│   │
│   ├── template-docs/agent-system/       ✅ 领域文档标准件（已有 MVP，需补全）
│   │   ├── README.md                       适用判定 + 单/多 agent 选型（已有，需补选型）
│   │   ├── agent-system-checklist.md       就绪检查表（已有，单/多 agent 分栏待补）
│   │   ├── docs/design/
│   │   │   ├── agent-architecture.md       planner/executor/critic/tool-router/memory（已有）
│   │   │   ├── tool-permission-model.md    工具注册 + 权限矩阵 + 危险操作（已有）
│   │   │   ├── memory-and-state.md         短/长期记忆 + 状态生命周期（已有）
│   │   │   ├── trace-and-replay.md       ★ 补：执行轨迹 + 回放 + 失败归因
│   │   │   └── hitl-and-safety.md        ★ 补：人工接管 + 回滚 + 降级 + injection
│   │   ├── docs/research/agent-eval-plan.md（已有）
│   │   └── profiles/                     ★ 新增：形态分化
│   │       ├── single-agent.md             单 agent 项目骨架差异点
│   │       └── multi-agent.md              多 agent 编排骨架差异点
│   │
│   ├── ai/agent-rules/                  ★ 新增：领域规则标准件（当前完全缺失）
│   │   ├── agent-implementation-rules.md   "实现 agent 前必先定 tool / memory / eval"
│   │   └── tool-safety-rules.md            危险工具 / hitl / injection 约束
│   └── ai/doc-standards/agent-*.md      ★ 新增：agent 文档审计基线（让 docs-system-audit 能审 agent 文档）
│
├── 【领域机制层 · Batch 3 核心缺口，决定能否真正当领域模板】
│   ├── domain-template-sync.json         领域→派生 下发清单（通用件 + 领域件）
│   ├── scripts/sync-domain-template.*    领域→派生 同步脚本
│   ├── scripts/check-domain-derived-sync.* 派生边界检查（不覆盖业务事实）
│   └── scripts/check-agent-template.*  ★ 领域自检（agent scaffold 完整性 + REQ-ID 可追溯）
│
├── 【治理层】 _proposals/（领域共性反馈 + 本仓库建设提案；跨领域通用部分另起回流母模板）
│
└── 【示例层 · 强烈建议】 _examples/single-agent-demo/  ★ 一个最小可跑的 agent 派生样例
```

`★` = 当前缺失、建议补齐。最关键的三块：**领域规则标准件（`ai/agent-rules/`）**、**领域机制层（Batch 3）**、**示例项目**。

## 4. 三层路径机制：下行 / 上行

```text
下行（方法论 + 领域标准件 → 流向项目）
  母模板 ──sync-template(--domain-template)──▶ agent-system-template ──sync-domain-template──▶ agent 业务项目
  通用方法论            ✅ 第一跳已通            + agent 标准件              ❌ 第二跳未通          填业务事实

上行（经验回流，两级）
  agent 业务项目 ──feedback──▶ agent-system-template ──proposal──▶ 母模板
   业务事实不回流               领域共性沉淀此处          仅跨领域通用才回流
```

**关键判断**：第一跳（母→领域）已通且版本保留机制（`--domain-template`）就位；**第二跳（领域→agent 项目）是整条路的断点**。不打通它，`template-docs/agent-system/` 永远到不了 agent 项目手里。打通第二跳 = Batch 3 的核心。

**领域模板的双重身份**（相对母模板是下游 / 相对 agent 项目是上游）必须在 `TEMPLATE-BASE.md` 一处讲清——当前已记录 lineage，建议补「双重身份与上下游同步关系」说明。

## 5. 关键决策点（需维护者拍板）

| # | 决策点 | AI 建议 | 理由 / 取舍 |
|---|---|---|---|
| D1 | 领域标准件**约束**还是**参考**？ | **约束**（进入 readiness gate + 领域自检强制） | 参考则退化为文档库；约束才让领域模板有规范力。代价：派生项目合规成本上升 |
| D2 | agent 标准件**独立放** `template-docs/agent-system/` 还是**融入** docs/00-09？ | **双态**：模板态（下发源）+ 项目态（落进项目 `docs/04-architecture` agent 子节 / `docs/design/agent-*.md`） | 需定义「领域文档→项目 docs 结构」映射。纯独立则与 docs 割裂，纯融入则失去模板复用 |
| D3 | 单 / 多 agent **拆两个领域模板**还是**领域内 profile**？ | **领域内 profile**（`profiles/single\|multi`） | 拆仓维护成本翻倍且共享内核；profile 复用同一流水线，差异点收敛 |
| D4 | 第二跳同步**现在写自动化**还是**先手动验证**？ | **先手动**：建 `_examples/single-agent-demo` 跑通映射，再决定脚本形态 | 与 inheritance Batch 4「需真实项目试用后再评估」一致；先固化结构，避免过早把不成熟形态写进脚本 |

> 现有 `template-docs/agent-system/README.md` 已约定「agent 标准件必须能追溯到 `docs/02-srs.md` 的 REQ-ID」——这是 D2 映射的已有锚点，提案应沿用并细化。

## 6. 路线图（对齐 inheritance Batch）

```text
Batch 2 收尾（现在）   补全 agent-system/ 缺件：trace-replay、hitl-safety、profiles、README 选型判定
                      更新 TEMPLATE-BASE.md 的 Domain standards scope（+trace/hitl）
        ↓
Batch 3a（近期·手动）  建 _examples/single-agent-demo：手动把领域标准件落进真实最小 agent 项目
                      → 验证 agent-system-checklist 可用、领域文档→项目 docs 映射成立（先不写脚本）
        ↓
Batch 3b（中期·机制）  基于 demo 经验落：domain-template-sync.json + sync-domain-template.*
                      + check-domain-derived-sync.* + check-agent-template.*（领域自检）
                      + ai/agent-rules/ + ai/doc-standards/agent-*.md
        ↓
Batch 4（远期）        new-project --profile agent-system|multi-agent；领域发布回流 SOP
                      至少一个真实 agent 项目试用后，评估提升主线地位（写进母模板 template-methodology §5）
```

## 7. 风险与边界

- **漂移风险**：领域模板改写母模板 `ai/` 规则会漂移。对策：领域只叠加（`agent-rules/`），不改母模板下发件；冲突走提案回流。
- **过度治理风险**：agent eval / trace 容易做重。对策：MVP 只给结构模板和检查表，不绑定 runtime（inheritance 提案 §7 已定，守住）。
- **「三套模板」幻觉**：三层必须共享同一套流水线内核，否则维护成本 ×3。对策：领域内核 = 母模板下发（只读），领域只加特化层。
- **_proposals/ 语义边界**：本仓库 `_proposals/README.md` 现定义为「回流母模板」区。本报告与配套提案属**领域模板自身建设**，主要在本仓库落地；仅其中跨领域通用经验（如多级同步机制）成熟后另起提案回流母模板 inheritance Batch 3。

## 8. 现状事实基线（评估依据）

- `VERSION`：`v0.1.0`（领域版本）
- `TEMPLATE-BASE.md`：Lineage type = domain template；母模板 `github.com/emily8421/ai-project-template`；base `v1.44.3`；current synced `v1.57.1`（2026-07-25）；Domain standards scope = 架构 / 工具权限 / memory-state / eval（4 项）
- `template-docs/agent-system/` 现有 6 文件：README、agent-system-checklist、docs/design/{agent-architecture, tool-permission-model, memory-and-state}、docs/research/agent-eval-plan
  - README 已声明「必须覆盖 trace/replay、hitl、injection」，但**无对应独立 design 文件** → Batch 2 收尾待补
- `_proposals/`：含 README 与本仓库领域自身建设提案（如本报告与配套 buildout 提案）；跨领域通用经验成熟后另起回流母模板
- inheritance 提案进展（母模板侧）：Batch 1 ✅ 方法论文档化；Batch 2 ✅ 建仓 + scaffold MVP；Batch 3 部分落地（C-004 版本保留 ✅、domain-template-lab 入口 ✅；**多级同步自动化 + 具体领域资产未落地**）；Batch 4 待办

## 9. 关联文档指针

- 三层方法论：母模板 `template-docs/domain-templates.md`
- 继承机制提案：母模板 `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md`
- 领域模板实验线入口：母模板 `ai/commands/domain-template-lab.md` + `ai/prompts/maintainers/23-domain-template-lab.md`
- 母模板下发清单：母模板 `template-sync.json`
- 配套提案：本仓库 `_proposals/TEMPLATE-UPGRADE-agent-template-buildout.md`
