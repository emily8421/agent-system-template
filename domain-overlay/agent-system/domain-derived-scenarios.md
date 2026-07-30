# Domain-Derived Scenarios（agent-system 领域派生项目场景剧本）

> 层归属：L2 领域自有。本剧本是 `agent-system-template` 的 **L2→L3 场景剧本（playbook）**：从母模板下发骨架 `template-docs/domain-derived-scenarios-template.md` 复制后领域化；不参与母模板同步，由本仓库（agent-system-template）自治维护。
> 配套文件：`template-docs/agent-system/README.md`、`layer-map.md`、`agent-system-checklist.md`、根 `domain-template-sync.json`、`scripts/sync-domain-template.*`、`scripts/check-domain-derived-sync.*`、`scripts/check-agent-template.*`。

## 0. 元信息与使用边界

| 项 | 内容 |
|---|---|
| 领域模板 | `agent-system-template`（L2） |
| 领域名 | `agent-system` |
| 领域派生项目 | agent 业务系统（L3） |
| 继承来源 | `ai-project-template`（L1，方法论经 L2 传递）+ `agent-system-template`（L2，agent 标准件） |
| 领域同步入口 | `scripts/sync-domain-template.ps1` / `.sh` |
| 领域自检入口 | `scripts/check-domain-derived-sync.*`（L2→L3 边界）+ `scripts/check-agent-template.*`（agent scaffold / 追溯，advisory） |
| 下发清单 | 根 `domain-template-sync.json` |

使用本剧本前先确认当前仓库角色：

1. **母模板 L1（ai-project-template）**：只维护通用方法论，不创建 agent 派生项目。
2. **领域模板 L2（agent-system-template，本仓库）**：维护 agent scaffold、领域同步清单、领域自检和本剧本。
3. **领域派生项目 L3**：只从 L2 接收 agent overlay，不直接跨层同步 L1。

## 1. 核心原则：L3 单源锚定 L2

> 本节是创建与同步所有判断的根基。

**agent 派生项目（L3）单源锚定本领域模板（L2）**：

- L3 **只从 `agent-system-template` 同步**。L1 母模板的通用方法论（`docs/00-09` 骨架、通用 `ai/` 规则、通用脚本）**已由 L2 吸收**，并随 agent overlay 一起下发；L3 一次性从 L2 全部拿到，**不直连 L1**。
- L3 **不挂 L1 同步入口**：L3 仓库不应保留指向 L1 的 `sync-template.*` / `check-derived-sync.*` 同步链路，只保留 L2 的 `sync-domain-template.*` / `check-domain-derived-sync.*`。
- `domain-template-sync.json` 里的 `requires_l1_sync_first` 是**给 L2 自己**的约束（L2 自身要先从 L1 sync 方法论），**不是**给 L3 的；L3 不承担"先同步 L1"的义务。

> **澄清历史歧义**：本目录 `README.md` 原「L2→L3 同步机制」一节写过"领域派生项目先完成母模板 L1 同步"——此处的"L1 同步"是**逻辑顺序**（L3 要有通用方法论底座），而该底座**经 L2 传递**，不等于 L3 物理直连 L1。该句已修正为单源锚定表述（见 README 同节）。

## 2. 适用性判断

| 用户目标 | 路由 |
|---|---|
| 创建普通业务项目（非 agent） | 回到母模板 A2 / `scripts/new-project.sh`，不走本剧本 |
| 创建或维护领域模板 | 走母模板 A20 / `/run domain-template-lab` |
| **从 agent-system-template 创建同类 agent 项目** | **走本剧本 §3** |
| 同步已有 agent 项目的领域标准件 | 走本剧本 §4 |
| 把 agent 经验回流上游 | L3 先回流 L2（§7）；跨领域通用结论由 L2 提炼后回流 L1 |

不适用情况：

- 单个 agent 项目，尚未证明 agent 标准件可复用（先按普通项目或独立实验仓验证）。
- 想让 L3 同时直连 L1 和 L2（违反 §1 与 §11）。
- 想把 agent 项目业务事实写回 L2 或 L1。

## 3. 创建领域派生项目

> 现状：领域版一键创建脚本 `scripts/new-domain-project.*` 已落地（v0.4.0；见根 `CHANGELOG.md`）：从 L2 整仓派生、剥离所有 L1 同步入口与 L2 维护件（含 `domain-overlay/`）、叠加 agent overlay、装领域 check workflow、`git init`。**优先用脚本**；手动组合流程（§3.2）作为脚本不可用时的等价回退，实证样本为 `_examples/single-agent-demo`。脚本的命令入口（`ai/commands/*` 属 L1 下发）、加入 `domain-template-sync.json` 下发清单与 CI 接入仍待办（见 §10 C-001 / C-002）。

### 3.1 为什么不能直接用母模板 `new-project.sh` 建底座

`scripts/new-project.sh` 是 L1 下发件，专为**普通派生项目**设计：

- 远端默认指向 `ai-project-template`（L1）；
- 生成的是 **`ordinary derived project`** 版 `TEMPLATE-BASE.md`；
- 装的是 **L1 边界**的 `project-check.yml`（匹配 `sync template … from ai-project-template`）；
- 没有 agent overlay、没有领域身份、没有领域自检。

若用它建 agent 项目底座，再叠加 L2 overlay，会产生：身份错误（ordinary 而非领域派生）、L1+L2 双同步入口（违反 §11）、CI 边界检查指向 L1。因此**底座必须从 L2 派生**，不用 `new-project.sh`。

### 3.2 过渡期组合流程（手动）

1. **从 L2 派生骨架**（不用 `new-project.sh`）：
   - 推荐 `git clone --depth 1 <agent-system-template> <agent-project>` 后删 `.git`，或在 L2 仓 `git archive HEAD | tar -x` 到目标目录。
2. **写领域派生版身份文件**（手动；自动生成属 Batch 4 远期）：
   - `VERSION` = `v0.1.0`（项目自有版本起点）；
   - `CHANGELOG.md` / `CHANGELOG-PLAIN.md`（项目自有演进，同步不覆盖）；
   - `TEMPLATE-BASE.md`：lineage = **agent derived project (L3)**，单源锚定 L2。推荐字段：

     ```text
     - Lineage type: agent derived project (L3)
     - Domain template repository: github.com/<owner>/agent-system-template
     - Domain template version: <L2 VERSION>
     - Inherited base template version (via L2): <L2 TEMPLATE-BASE 的 Current synced template version>
     - Domain standards scope: agent-system（架构 / 工具权限 / memory-state / trace-replay / HITL-safety / agent-eval）
     - Project version file: VERSION
     ```

   - 根 `README.md`：改写为 agent 项目说明。
3. **叠加 agent overlay**（核心下发动作）：

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\sync-domain-template.ps1 -Source <agent-system-template> -Target <agent-project> -DryRun
   # 确认新增/更新/跳过清单后：
   powershell -ExecutionPolicy Bypass -File scripts\sync-domain-template.ps1 -Source <agent-system-template> -Target <agent-project> -Commit
   ```

   - `domain-template-sync.json` 中 `overwrite-domain-owned` 文件（README/layer-map/checklist/profiles/agent-rules/doc-standards/脚本）会更新；`copy-if-missing` 的项目骨架（`docs/design/agent-*.md` 等）只在缺失时写入，**不覆盖已有项目事实**。
4. **配置领域同步边界检查**（过渡期手动；自动注入属 Batch 4 远期）：
   - 确保 `.github/workflows/project-check.yml`：普通 PR 跑 `git diff --check`；当提交信息匹配 `^sync agent domain template v… from agent-system-template` 时跑 `scripts/check-domain-derived-sync.sh`。不要沿用 `new-project.sh` 注入的、指向 L1 的 workflow。
5. **`git init` + 首提交 + 可选建远端**（`gh repo create`）。
6. **跑领域自检**（见 §5）。

### 3.3 一键脚本（已落地 v0.4.0）

`scripts/new-domain-project.sh` / `.ps1` 已把 §3.2 的组合流程固化为脚本：整仓 `git archive` 派生 → 剥离 L1 同步入口与 L2 维护件（含 `domain-overlay/`）→ 写领域派生身份 → 叠加 agent overlay → 装领域版 `project-check.yml` → `git init`。

```powershell
powershell -ExecutionPolicy Bypass -File scripts\new-domain-project.ps1 <项目名> [-Source <agent-system-template>] [-NoRemote]
```

仍待办：命令入口（`ai/commands/*` 属 L1 下发）、加入 `domain-template-sync.json` 下发清单（C-001）、CI 接入——等真实 agent 项目增多后再评估。

## 4. 同步领域模板更新

L3 只从 L2 同步 agent overlay。最小流程：

1. 读 L3 的 `TEMPLATE-BASE.md`，确认上游是 `agent-system-template`（若不是，说明 lineage 错误，先按 §3.2 修正）。
2. `sync-domain-template.* -DryRun`，列出将新增/更新/跳过的文件。
3. 确认 copy-if-missing 与 overwrite-domain-owned 的行为符合预期。
4. 用户确认后 `-Commit`。
5. 运行记录写入 L3 约定的同步记录目录。

同步**永不覆盖**：项目自身 `docs/` 事实、`VERSION`/`CHANGELOG`、业务代码/配置/密钥/客户数据、已明确由项目维护的领域配置。

## 5. 初始化后整理与领域自检

创建或同步后，按顺序整理：

1. 填写项目身份、目标用户、交付边界、运行环境前提。
2. agent 形态选型：先按 `profiles/single-agent.md` 判断是否足够；只有出现明确多 agent 信号才进入 `profiles/multi-agent.md`（当前为 stub）。
3. 填写 agent 必需 facts：架构（`docs/design/agent-architecture.md`）、工具权限、memory/state、trace/replay、HITL/safety、eval 计划；agent 标准件必须能追溯到 `docs/02-srs.md` 的 REQ-ID。
4. 跑领域自检：

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\check-domain-derived-sync.ps1 -Source <agent-system-template> -Target <agent-project> -Advisory
   powershell -ExecutionPolicy Bypass -File scripts\check-agent-template.ps1 -Target <agent-project>
   ```

5. `check-agent-template.*` 起步为 **advisory**：发现 scaffold 缺失/追溯弱项只告警，不阻断；只有脚本解析/运行错误直接失败。advisory 升 gate 需真实项目验证后另行提案。
6. 把验证摘要写入项目记录，不把项目事实回写 L2/L1。

## 6. 领域派生项目日常开发

母模板通用 A 场景仍适用：需求、设计、实现、验证、PR、CI、版本、回流不重写。

agent 任务在执行这些场景前，额外叠加领域 overlay（D7 读取路径）：

- 进项目先读 `TEMPLATE-BASE.md` 与 `template-docs/agent-system/layer-map.md` 判层；
- agent 设计/实现/工具权限/memory/trace/HITL/eval/同步/自检任务前读 `ai/agent-rules/`；
- 生成或审计 agent 文档前读 `ai/doc-standards/agent-*.md`。

## 7. L3→L2 回流

L3 回流 L2 的内容：agent scaffold 缺口、checklist 漏项、同步清单误覆盖/漏同步、多个同类 agent 项目可复用的 prompt/脚本/评估样例/验收口径。

不直接回流 L1：单个 agent 项目的业务事实、领域专属工具/字段/流程/客户约束、尚未在多个项目验证的候选做法。跨领域通用结论由 L2 提炼后再回流 L1。

## 8. 领域模板发布后的下游同步

L2 发布新版本后，维护者给 L3 一份同步说明：L2 新版本号与变更摘要、受影响 overlay 文件、推荐 DryRun 命令、必跑自检命令、已知迁移风险与人工检查项。

L3 完成同步后记录：同步前后版本、DryRun 摘要、实际变更文件、自检结果、项目侧保留/跳过的文件。

## 9. 验证与完成判据

一次创建/同步完成，至少满足：

- 已确认走的是 L2→L3 路径，L3 单源锚定 L2，未直连 L1。
- L3 的 `TEMPLATE-BASE.md` lineage = agent derived project，记录了 L2 版本与经 L2 继承的 L1 版本。
- 已运行 `sync-domain-template.*` 的 DryRun（或说明为何暂无）。
- 已运行 `check-domain-derived-sync.*` + `check-agent-template.*`，或列明阻塞原因。
- 已记录同步结果、待办与回流项。

## 10. 待确认项

| ID | 待确认项 | AI 建议 | 阻塞 |
|---|---|---|---|
| C-001 | 本剧本 `domain-derived-scenarios.md` 是否加入 `domain-template-sync.json` 下发清单（让每个 L3 创建时自动拿到） | 第一步先不下发；等第一个真实 agent 项目试用后再评估，按 `overwrite-domain-owned` 下发 | 不阻塞 |
| C-002 | `new-domain-project.*` 已固化 §3.2 组合流程（v0.4.0 落地）；待评估是否加入下发清单与命令入口 | 已落地脚本；下发清单 / 命令入口 / CI 待真实项目增多后评估 | 不阻塞 |

## 11. 禁止事项

- **不让 L3 同时直连 L1 和 L2**（L3 单源锚定 L2）。
- **不用母模板 `new-project.sh` 建 agent 项目底座**（会产生 ordinary 身份 + L1 同步入口，见 §3.1）。
- 不把 agent scaffold 写进母模板默认同步范围。
- 不把 L3 业务事实回写 L2 或 L1。
- 不把未验证的领域候选资产（含一键创建脚本）写成已落地机制。
