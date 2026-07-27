# TEMPLATE-UPGRADE: Agent 领域模板建设（机制层 + 规则标准件 + 示例验证）

> 来源：2026-07-27 架构评估会话；前置分析见本仓库 `_proposals/analysis-agent-template-architecture.md`
> 状态：**草案 · 待维护者确认**（含建议、候选方案与待确认项，非既成事实）
> 目标版本：领域模板 `v0.1.0` → 拟 `v0.2.0`（Batch 0 治理 + Batch 2 收尾 + 3a）/ `v0.3.0`（Batch 3b 机制层）
> Release impact：minor（AI 建议，待维护者确认；新增领域标准件与机制层，不改母模板主同步路径）
> Release strategy：分批落地；本提案只在 `agent-system-template` 仓库内试验；跨领域通用经验成熟后另起提案回流母模板 inheritance Batch 3，不污染母模板主路径
> 仓库角色：**领域模板**（相对母模板为下游，相对 agent 派生项目为上游）

## 1. 背景

母模板 `_proposals/TEMPLATE-UPGRADE-domain-template-inheritance.md` 定义了三层继承机制（母模板 → 领域模板 → 领域派生项目），其落地节奏：

- Batch 1（方法论文档化）✅
- Batch 2（建仓 + scaffold MVP）✅ —— 本仓库 `template-docs/agent-system/` 6 件已就位
- Batch 3（领域自检 / 多级同步自动化）**部分落地**：C-004 版本保留（`--domain-template`）✅、`domain-template-lab` AI 入口 ✅；**多级同步自动化与具体领域资产未落地**
- Batch 4（profile / 发布回流 SOP）待办

本仓库 `agent-system-template` 已具备「继承层 + 领域骨架层」，但**领域机制层缺失**（见分析报告 §1）。后果：领域标准件无法下发、无法自检、无法约束 agent 项目——本仓库目前是「带 agent 文档的普通派生项目」，尚未成为真正的领域模板。

本提案目标：补齐领域机制层 + 领域规则标准件 + 示例验证，打通「领域模板 → agent 项目」第二跳。

> 治理前提（v0.2.0 前须修正，详见 §4.5 层治理约定 / §7 Batch 0）：现状层归属不清导致——(1) `CHANGELOG.md` 错顶母模板 sync notice，且领域版本（v0.x）与母模板版本（v1.45.x）两套编号空间撞车；(2) `_proposals/README.md` 漂离母模板当前提案收件箱规格。

## 2. 目标

1. 补全领域文档标准件（trace-replay、hitl-safety、profiles），使 agent 骨架覆盖 README 已声明但未落文件的维度。
2. 新增领域**规则**标准件（`ai/agent-rules/`）与 agent 文档审计基线（`ai/doc-standards/agent-*.md`），让领域模板具备「约束 AI 行为」的能力，而非仅提供文档。
3. 落地领域机制层：`domain-template-sync.json` + `sync-domain-template.*` + `check-domain-derived-sync.*` + 领域自检 `check-agent-template.*`，打通第二跳同步。
4. 用一个最小示例项目（`_examples/single-agent-demo`）手动走通「领域模板 → agent 项目」全路，验证标准件可用性与映射关系，再决定自动化形态。
5. 支持单 / 多 agent 形态分化（领域内 profile），不拆分仓库。

## 3. 非目标

- 不绑定具体 agent runtime（LangGraph / AutoGen / CrewAI 等）、模型供应商、向量库 / memory backend、UI、业务 prompt（与 inheritance 提案 §7 一致）。
- 不改写母模板下发的 `ai/` 通用规则、`docs/00-09` 骨架与 `scripts/sync-template.*` 语义（继承不 fork）。
- 不修改母模板 `git-guide.md` §5 主同步路径、不让 agent 项目直接同步母模板、不让领域派生项目业务事实回写母模板。
- 不在本提案阶段实现 `new-project --profile agent-system`（留待 Batch 4，需真实项目试用后再评估）。
- 不引入自检门禁断言到母模板 `check-template.*`（领域自检属本仓库）。

## 4. 架构原则（摘要）

1. **继承不 fork**：领域只叠加不改写；冲突走提案回流母模板。
2. **领域标准件分两类**：文档标准件（agent docs 该长什么样）+ 规则标准件（AI 该怎么干活，当前缺失）。
3. **约束派生项目**：领域标准件进入下行同步清单 + 领域自检，而非仅作参考。
4. **单 / 多 agent 领域内 profile 分化**，不拆仓。

> 完整阐述见分析报告 §2。

## 4.5 层治理约定（Layer Governance · Batch 0 前置）

> 来源：2026-07-27 维护者关切——三层（母模板 → 领域模板 → 领域派生项目）的上下行机制与目录 / 命名层区分需先定清，否则人与 AI 都会搞乱层归属。本节是后续所有 Batch 的前置约定。状态：草案 · 待维护者确认。
> 设计依据：母模板 `template-docs/domain-templates.md` §3 / §4 / §5（三层职责边界、双重身份、TEMPLATE-BASE 约定）。本会话核出的 CHANGELOG 版本空间撞车、`_proposals/README.md` 漂移、`ai/agent-rules/` 读路径断，均为层未分清的症状。

三层（L1 母模板 / L2 领域模板 / L3 领域派生项目）的版本空间、目录、命名、同步路径必须可被人和 AI 稳定识别。锁定四条约定：

### G1 · 层归属标签（每份受治理文件 / 目录都可判层）

| 层类 | 标记 | 拥有者 | 同步行为 | 本地可否编辑 |
|---|---|---|---|---|
| **L1 母模板下发** | 现有 sync notice | 母模板 | 每次母模板 sync 覆盖 | 否；改动走 `_proposals` 回流母模板 |
| **L2 领域自有** | 领域所有权标记（domain-owned；sync 保留） | 领域模板 | sync 不覆盖（已验证 `sync-template.* --domain-template`） | 是 |
| **L3 派生项目填写** | 【撰写提要】/ 占位 | 派生项目 | 不参与同步 | 派生项目填 |

- L1 文件**不能**本地加标签（sync 会回滚）→ 其层身份由「现有 sync notice + 路径约定」推断，见 G4。
- L2 文件**应**带领域所有权标记；当前错顶母模板 sync notice 的（`CHANGELOG.md`）在 Batch 0 修正。
- 路径约定：`template-docs/agent-system/`、`ai/agent-rules/`、`profiles/` = L2；`ai/index.md`、母模板下发的 `ai/*-rules.md`、`docs/00-09` 骨架、`scripts/sync-template.*`、`template-docs/domain-templates.md` = L1；`ai/project-rules.md`、`docs/00-09` 内容、根 `README.md` = L3。

### G2 · 版本空间强制隔离

- 领域 `VERSION` / `CHANGELOG.md` **只记领域版本**（v0.x）；不得混入母模板版本条目（v1.45.x）。
- 母模板同步版本记在 `TEMPLATE-BASE.md` 的 `Current synced template version`（已有），不进领域 CHANGELOG。
- 理由：domain v0.x 与 parent v1.45.x 是两套独立编号空间，混入一个 CHANGELOG 会同时违反 check-template 的「顶部 == VERSION」与「版本降序」两条断言。
- **应用**：CHANGELOG 转纯领域版（移除继承的母模板条目）—— **Batch 0 已落地**。

### G3 · L2→L3 下行清单 + 命名映射

- `domain-template-sync.json`（Batch 3b 建）记录「领域模板 → 领域派生项目」下发清单，每条含：源路径（L2）→ 目标路径（L3）→ 件类（通用件继承自母模板 / 领域件领域专属）。
- 命名约定：领域件下发到派生项目时保持稳定路径与 REQ-ID 可追溯（沿用 `template-docs/agent-system/README.md` 既有约定）。
- 该清单的契约形态由 Batch 3a 的「显式映射表」产出。
- 通用件（`docs/00-09` 骨架、`ai/` 通用规则）已由母模板 sync 下发到 L2，再随 L2→L3 透传；领域件只走 L2→L3。

### G4 · 层映射（AI 可读）+ 上行回流分层路由

- 在 `TEMPLATE-BASE.md` 增补或新建 `template-docs/agent-system/layer-map.md`，维护**层映射表**：路径 → 层类（L1/L2/L3）→ 同步路径 → 编辑策略。AI 进项目后读此表即可稳定判层，不靠猜（也降低 D7 严重度：AI 可经层映射发现 L2 领域规则件；D7 的强制路由钩子仍待决策）。
- 上行回流两级（沿用母模板方法论 §4）：L3→L2 领域专属经验 → 领域模板 `_proposals/`；L2→L1 跨领域通用经验 → 母模板 `_proposals/`（经 submit-proposal）。
- 路由规则：**领域专属停在 L2；只有跨领域通用才上行 L1**。
- **应用**：重构 §9 D5——`_proposals/` 区分「领域自建提案」与「待上行母模板的跨领域提案」两类。

## 5. 目标目录架构（摘要）

新增 / 补全（`★`）部分：

```text
template-docs/agent-system/
  docs/design/trace-and-replay.md        ★ 补
  docs/design/hitl-and-safety.md         ★ 补
  profiles/single-agent.md               ★ 新增
  profiles/multi-agent.md                ★ 新增
ai/agent-rules/                          ★ 新增（领域规则标准件）
  agent-implementation-rules.md
  tool-safety-rules.md
ai/doc-standards/agent-*.md              ★ 新增（agent 文档审计基线）
domain-template-sync.json                ★ 新增（领域→派生 下发清单）
scripts/sync-domain-template.*           ★ 新增
scripts/check-domain-derived-sync.*      ★ 新增
scripts/check-agent-template.*           ★ 新增（领域自检）
_examples/single-agent-demo/             ★ 新增（最小验证样例）
TEMPLATE-BASE.md                         更新：Domain standards scope + 双重身份说明
```

> 完整目录树与逐文件职责见分析报告 §3。

## 6. 三层路径机制（摘要）

```text
下行：母模板 ──(已通,--domain-template)──▶ agent-system-template ──(待打通,Batch 3)──▶ agent 项目
上行：agent 项目 ──feedback──▶ agent-system-template ──proposal(仅跨领域通用)──▶ 母模板
```

第二跳（领域→agent 项目）是断点，本提案核心即打通它。领域模板双重身份（对母模板下游 / 对 agent 项目上游）写入 `TEMPLATE-BASE.md`。

> 完整机制图见分析报告 §4。

## 7. 推荐分批落地

### Batch 0 · 层治理约定落地（§4.5；v0.2.0 落地前必做，纯本仓库、低成本、不改母模板）

> 来源：2026-07-27 维护者关切（三层上下行机制 + 目录 / 命名层区分）+ 双 AI 评估会话复核。锁定 §4.5 层治理约定，否则版本发布不可审计、层归属不清、提案落点不合规。
> sync 保留 CHANGELOG 已验证（`sync-template.* --domain-template`），修正不会被回滚；CI 不跑 check-template，非阻断。

- **`CHANGELOG.md` 转 L2 领域所有权**（G1 + G2）：顶掉错误的母模板 sync notice → 换领域所有权标记；转纯领域版（移除继承的母模板版本条目 v1.45.x，它们属母模板版本空间，已记在 `TEMPLATE-BASE.md`）；补 `## v0.1.0（2026-07-10）` 领域初始条目。
- **`_proposals/README.md` 重同步 + 两类区分**（G4）：重同步到母模板当前提案收件箱规格（GitHub issue 收件、`_remote-issues/` 镜像、Release impact / strategy 字段…），并加「领域自建 / 待上行跨领域」两类区分。
- **层映射表**（G4）：`TEMPLATE-BASE.md` 增补或新建 `template-docs/agent-system/layer-map.md`，列路径 → 层类 → 同步路径 → 编辑策略（AI 判层入口）。
- 分析报告自相矛盾：已修（§8「现仅 README」改述）。
- 版本：随 `v0.2.0`。G3 的 `domain-template-sync.json` 形态在 Batch 3a 映射表产出后、3b 落地前定稿。

### Batch 2 收尾（已落地：领域骨架补全，纯文档，低风险）

- 已补 `template-docs/agent-system/docs/design/trace-and-replay.md`、`hitl-and-safety.md`。
- 已新增 `profiles/single-agent.md`（正式落）；`profiles/multi-agent.md` **仅落 stub**（头部标「待真实多 agent 项目验证后补全」，因当前无多 agent 真实项目验证，不宜当既定标准件下发）；README 已补单 / 多 agent 选型判定。
- 已更新 `agent-system-checklist.md` 单 / 多 agent 分栏。
- 已更新 `TEMPLATE-BASE.md` 的 `Domain standards scope`（+ trace / hitl / profiles）与双重身份说明。
- 版本：拟 `v0.2.0`（minor，新增领域文档件）。

### Batch 3a（已落地：手动验证，先不写自动化脚本）

- 已建 `_examples/single-agent-demo/`：一个最小可跑的单 agent 派生项目，手动把领域标准件落进其 `docs/`、设计记录、eval 计划与代码骨架。
- 已验证：`agent-system-checklist.md` 可用于具体项目评估；领域文档→项目 docs 映射（D2）成立；REQ-ID / TC-ID 可从需求追到代码测试。
- 已产出：`_examples/single-agent-demo/docs/research/agent-standard-mapping.md` 显式映射表（标准件 → 项目 docs → 代码 / 测试 → REQ / TC），作为 Batch 3b sync 清单与自检设计的硬契约。
- 已产出 checklist 实战反馈：`_examples/single-agent-demo/docs/research/checklist-validation.md`；本轮结论是不必改 checklist 正文，Batch 3b 应优先把映射表和 advisory 自检固化。
- 未写 `domain-template-sync.json`、`sync-domain-template.*`、`check-agent-template.*`，保持 Batch 3a 与 3b 边界。
- 版本：仍 `v0.2.0`（示例与验证，不改模板主干能力）。

### Batch 3b（机制化，基于 3a 经验）

> **开工前置门禁**：必须先关闭 §9 D7（领域规则读路径）与 D8（领域自检强度），否则机制层半残——规则无人读 / 自检误杀。

- 落 `domain-template-sync.json`（通用件 + 领域件下发清单）。
- 落 `scripts/sync-domain-template.*`（领域→派生，dry-run / commit）+ `scripts/check-domain-derived-sync.*`（边界检查，不覆盖业务事实）。
- 落领域自检 `scripts/check-agent-template.*`（agent scaffold 完整性 + REQ-ID 可追溯）。
- 落 `ai/agent-rules/` + `ai/doc-standards/agent-*.md`。
- 版本：拟 `v0.3.0`（minor，新增机制层与规则标准件）。

### Batch 4（远期，需真实项目试用后评估）

- `new-project --profile agent-system | multi-agent`。
- 领域发布 / 回流 / 下行同步 SOP。
- 至少一个真实 agent 项目试用后，评估是否提升主线地位（写进母模板 `template-methodology.md` §5）。

## 8. 验收标准

本提案阶段（设计）：

- 能清晰回答领域模板三层各自的机制缺口与本提案如何补齐。
- 能给出 Batch 2→3a→3b→4 的分批演进与版本影响。
- 不绑定 runtime；不漂移母模板规则；不污染母模板主路径。

后续实现阶段（按 Batch）：

- Batch 0：CHANGELOG 为纯领域版本（顶部 v0.1.0、无母模板条目、领域所有权标记）且 sync 不覆盖已验证；`_proposals/README.md` 重同步到母模板当前提案收件箱规格 + 领域自建 / 待上行两类区分；层映射表（layer-map）就位、AI 可据其判层。

- Batch 2（已落地）：trace-replay / hitl-safety / profiles 文件存在且关键字段齐全；checklist 单 / 多 agent 分栏可用；TEMPLATE-BASE scope 已更新。
- Batch 3a（已落地）：`_examples/single-agent-demo` 可手动走通；**显式映射表成文**（逐项对应、REQ-ID / TC-ID 可追溯）；checklist 经实战验证并形成修订反馈。
- Batch 3b：`domain-template-sync.json` 可解析；`sync-domain-template.*` dry-run 不覆盖 demo 业务事实；`check-agent-template.*` 能检出 scaffold 缺失与 REQ-ID 断链且**强度与 D8 选定一致**；`ai/agent-rules/` 被 AI 任务路由读取（**D7 已关闭**）。
- 全程：不影响母模板默认项目创建与主同步流程；不绑定特定 runtime。

## 9. 待确认项

| ID | 待确认项 | AI 建议 | 建议依据 | 备选方案 | 取舍影响 / 阻塞关系 |
|---|---|---|---|---|---|
| D1 | 领域标准件约束还是参考 | **约束**（进 readiness gate + 领域自检强制） | 参考则退化为文档库；约束才有规范力 | 仅参考 | 派生项目合规成本上升；不阻塞 Batch 2 |
| D2 | agent 标准件独立放还是融入 docs/00-09 | **双态**：模板态（下发源）+ 项目态（落进项目 docs） | 纯独立与 docs 割裂，纯融入失去复用 | 纯独立 / 纯融入 | 决定 sync 映射设计；Batch 3a 重点验证 |
| D3 | 单 / 多 agent 拆仓还是领域内 profile | **领域内 profile** | 拆仓成本翻倍且共享内核 | 拆两个领域模板 | 不阻塞；影响 profiles/ 设计 |
| D4 | 第二跳同步先手动还是直接自动化 | **先手动**（3a demo）再机制化（3b） | inheritance Batch 4「需真实项目试用后再评估」 | 直接写 sync 脚本 | 避免过早固化不成熟结构；决定 3a/3b 顺序 |
| D5 ✅ | _proposals/ 落点是否合规（原语义仅回流母模板） | **已由 Batch 0 G4 落地**：`_proposals/README.md` 重写为 A 领域级 / B 待上行两类，落点合规 | — | — | 已解决，不阻塞 |
| D6 | 领域自检是否进 CI | 进本仓库 CI（`.github/workflows/`），不进母模板 | 领域 scaffold 完整性需自动守护 | 仅本地手跑 | CI 配置成本；Batch 3b 决定 |
| D7 | 领域规则读路径：`ai/agent-rules/` 如何被 AI 路由真正读取（避免无人读的文档库） | **(b) 过渡期约定指针先行 + (a) 回流候选挂账**：`TEMPLATE-BASE.md` / agent-system README 加显式指针「agent 项目须读 `ai/agent-rules/`」；成熟后把「领域 overlay 委托钩子」回流母模板 | `ai/index.md` 母模板下发只读、全文无 overlay 委托；`project-rules.md:3` 不参与同步，故 project-rules.md 桥接无效（不下发） | (a) 直接回流母模板加 overlay 钩子（彻底但跨仓、依赖母模板维护者、可能撞 inheritance 边界） | **阻塞 Batch 3b**；不定则 agent-rules/ 写了也无约束力 |
| D8 | 领域自检强度：`check-agent-template.*` 起步 advisory 还是 gate | **advisory 起步**，≥1 真实项目验证后（Batch 4）才把成熟条目升 gate | 「好」未经验证前无法设计强制；与 D1 约束方向不冲突（D1 定方向，D8 定分阶） | 直接 gate（无验证前误杀派生项目风险） | **阻塞 Batch 3b 自检行为定义**；不阻塞 Batch 2 / 3a |

## 10. 与母模板 inheritance 提案的衔接

- 本提案落地 inheritance **Batch 3 的领域侧**（具体领域资产 + 多级同步），母模板侧只保留 `domain-template-lab` 入口与边界，不新增 scaffold（符合「母模板不承载领域 scaffold」）。
- 本提案产生的**跨领域通用经验**（如多级同步自动化模式、领域自检模式），成熟后由本仓库维护者通过 `submit-proposal` 回流母模板，更新 inheritance 提案 Batch 3 / Batch 4 状态；**不直接改母模板**。
- 领域版本（`VERSION` / `TEMPLATE-BASE.md`）与母模板版本相互独立：母模板 sync 更新 `Current synced template version`，领域版本随本提案 Batch 演进（`v0.2.0` / `v0.3.0`）。
