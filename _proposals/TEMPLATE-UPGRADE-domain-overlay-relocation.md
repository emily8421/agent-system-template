# TEMPLATE-UPGRADE: 领域增量收拢到 `domain-overlay/`（轨 A · B1）

> 类型：L2 领域模板自身建设提案（agent-system-template 自治；不改 L1 母模板、不改 L1 主同步路径）。
> Release impact：patch（AI 建议，待维护者确认）。
> Release strategy：单独发布。
> 状态：执行中（2026-07-30，分支 feat/domain-overlay-relocation）。
> 关联：`_proposals/analysis-agent-template-architecture.md`；母模板 `template-docs/domain-templates.md` 三层方法论；buildout 提案 G1/G4/D7。

## 1. 动机（为什么）

领域模板原本的定位是「母模板通用方法论 + 少量领域增量」。但当前领域件散落在 `ai/`（与 L1 通用规则混层）、`template-docs/`（与通用手册混层）、`scripts/`（与通用脚本混层），层归属只能靠「文件头标记 + `layer-map.md` 表 + 两份 sync 清单」交叉判断——这层元数据与文件本体分离，已证实会滞后（`layer-map` 把根 README 分错层；README 版本号停在 v0.3.0；playbook 说"创建脚本远期未做"而 v0.4.0 已落地）。

结果：AI 进项目要"猜"一个文件属于哪一层、会不会被同步、能不能改；人看目录也分不清"这是通用方法论还是领域增量"。这违背了"增量、不多猜"的初衷。

**目标**：把"内容型领域件"物理收拢进 `domain-overlay/`，让 L2 仓库根目录自带层归属答案——左边是继承来的通用方法论（会同步、别动），`domain-overlay/` 是本领域增量（L2 自有、整体下发给 L3）。

## 2. 范围：B1（仅 L2 收拢，target 不变）

| 维度 | B1（本提案） | B2（后续可选，见 §8） |
|---|---|---|
| L2 仓库清晰 | ✅ 领域件收拢到 `domain-overlay/` | ✅ 同 |
| L3 派生项目形态 | 不变（target 仍落在 `ai/agent-rules/` 等） | 也收拢（target 改 `domain-overlay/`） |
| `check-agent-template.*` `$overlay` 数组 | 不用改 | 必须改 |
| `_examples/single-agent-demo` | 零影响 | 要重 sync + 改 demo check 脚本 |
| 风险 | 低 | 中（偏离母模板 `ai/` 约定更远） |

选 B1 的理由：轨 A 定位是"L2 仓内低风险试验"；target 不变 → L3 下发行为零变化 → `check-agent-template` 与 demo 都不动，风险最低。L3 清晰（B2）需等至少一个真实 agent 项目试用后再评估，且与轨 B（回流母模板 MAJOR）合并更稳妥。

## 3. 拟改（执行清单）

### 3.1 物理移动（`git mv`，保留历史）
- `ai/agent-rules/*.md`（2）→ `domain-overlay/rules/`
- `ai/doc-standards/agent-*.md`（6）→ `domain-overlay/doc-standards/`（文件名不变；L1 的 `00-09`/`design-doc` 留在 `ai/doc-standards/`）
- `template-docs/agent-system/**` → `domain-overlay/agent-system/`（内部结构不变）
- 新增 `domain-overlay/README.md`（overlay 区入口）

### 3.2 必改的 4 类硬约束（缺一功能断，来自两份路径耦合调研）
1. `domain-template-sync.json`：每条移动件的 `source` 改新路径，**`target` 保持不变**。
2. D7 三指针：`TEMPLATE-BASE.md`（scope 散文）、`domain-overlay/agent-system/README.md`（导航表 + AI 读取路径段）、`domain-overlay/agent-system/layer-map.md`（路径表行 + D7 第 5 条）。
3. `scripts/new-domain-project.{ps1,sh}`：剥离黑名单加 `domain-overlay`（否则 `git archive HEAD` 会把 `domain-overlay/` 泄漏进每个 L3，与 sync 下发的 target 重复）。
4. `check-agent-template.*` `$overlay` 数组：**B1 下不改**（它查 L3 target，target 不变）。

### 3.3 软引用更新（改文字即可）
根 `README.md`（导航 + 版本号 v0.3.0→v0.4.x）、`domain-derived-scenarios.md`（§6 路径 + §3/§3.3/§10-C002「创建脚本远期未做」滞后修正）、`agent-implementation-rules.md`（自引用）、`ai/project-rules.md`（目录清单 + 版本号）、`layer-map.md`（根 README 归 L2）。

## 4. 不改（已验证零耦合）

- `ai/index.md`、`ai/rules-core.md`（L1，零引用 agent-*）——这正是 D7 用指针而非 L1 钩子的原因。
- `scripts/sync-domain-template.*`、`scripts/check-domain-derived-sync.*`（manifest 驱动，路径无关）。
- `.github/workflows/project-check.yml`（L2 CI 只调 `check-derived-sync.sh`）。
- `docs-system-audit`（不扫 `agent-*`）。
- 母模板、L3 target 路径。

## 5. 版本影响：patch

`target` 不变 = 下游（L3）同步行为零变化；同步清单结构（source/target 对）语义不变，只是 source 指向重组后的位置；下游必做流程不变。按 CONTRIBUTING「兼容性默认规则」判 **patch**。VERSION v0.4.0 → v0.4.1，CHANGELOG 新增条目。若维护者认定目录结构属新采用面，可升 minor。

## 6. 影响面

- L2 维护者：目录更清晰，AI/人进 `domain-overlay/` 即知领域增量边界。**正面**。
- L3 派生项目：下发行为不变（target 不变），形态不变。**零影响**。
- `_examples/single-agent-demo`：target 不变，demo 不动。**零影响**（dry-run 确认 source→target 映射仍成立）。

## 7. 验证（端到端）

1. `sync-domain-template.ps1 -Source . -Target _examples/single-agent-demo -DryRun`：无 `missing source file`。
2. `check-domain-derived-sync.ps1 -Source . -Target _examples/single-agent-demo -Advisory`：通过。
3. `check-agent-template.ps1 -Target _examples/single-agent-demo`：通过。
4. `new-domain-project.ps1` 实测：生成的 L3 不含 `domain-overlay/`、overlay 落到 `ai/agent-rules/`、L3 自检通过；测完删除临时项目。
5. JSON 解析 + markdown clean + `git status` 核对仅预期 rename/编辑。
6. `new-domain-project.ps1` 保持 UTF-8 BOM + CRLF。

## 8. 后续（B2 / 轨 B，本提案不含）

- **B2（L3 也收拢）**：触发条件 = 至少一个真实 agent L3 项目试用 B1 后确认 L3 混层确为痛点。额外改动：manifest `target` 改 `domain-overlay/`、`check-agent-template.*` 数组、`new-domain-project.*` echo 文本、重 sync demo。
- **轨 B（回流母模板 MAJOR）**：把"目录自表达层 + overlay 整区下发"上升为母模板领域模板目录标准；并把 `scripts/` 内领域脚本与通用脚本的解耦一并处理（B1/B2 都不动 scripts 路径，因脚本硬编码）。
