# 层映射表（Layer Map）

> 层归属：L2 领域自有。AI 进入 `agent-system-template` 后读此表即可稳定判层（路径 → 层类 → 标记 → 同步路径 → 编辑策略），不靠猜。
> 约定来源：buildout 提案 §4.5 层治理约定（G1 / G4）。三层定义见 `template-docs/domain-templates.md` §1。
>
> **路径视角**：本表描述 **L2 源仓库**的实际路径。L2 领域增量集中在 `domain-overlay/`（入口见 `domain-overlay/README.md`）；下发到 L3 派生项目后，落到 L3 的 `ai/agent-rules/`、`ai/doc-standards/agent-*.md`、`template-docs/agent-system/`（source→target 映射以 `domain-template-sync.json` 为准）。表中 L2 行同时给出「L2 源 → L3 下发 target」。

## 三层定义

| 层 | 含义 | 本仓库中的身份 |
|---|---|---|
| **L1 母模板下发** | `ai-project-template` 下发，只读吸收 | 本仓库是 L1 的**下游** |
| **L2 领域自有** | `agent-system-template` 自身维护 | 本仓库 = L2 |
| **L3 派生项目填写** | 领域派生项目填业务事实 | 本仓库是 L3 的**上游** |

## 路径 → 层类 → 同步 / 编辑策略

| 路径（L2 源 → L3 下发 target） | 层类 | 标记 | 同步行为 | 本地可否编辑 |
|---|---|---|---|---|
| `ai/index.md`、`ai/rules-core.md`、`ai/global-rules.md`、`ai/document-lifecycle-rules.md`、`ai/implementation-lifecycle-rules.md`、`ai/session-rules.md` | L1 | sync notice | 母模板 sync 覆盖 | 否；改走回流 |
| `ai/project-rules.md` | L3 | 撰写提要 | 不参与同步 | 派生项目填 |
| `ai/doc-standards/README.md`、`ai/doc-standards/00-09*`、`ai/doc-standards/design-doc.md`、`ai/doc-standards/frontend-interaction.md`、`ai/doc-standards/ui-prototype-strategy.md` | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `domain-overlay/doc-standards/agent-*.md` → L3 `ai/doc-standards/agent-*.md` | L2 | 领域所有权标记 | L2→L3 下行 | 是 |
| `ai/commands/*`、`ai/prompts/*` | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `docs/00-09` 骨架（撰写提要 / 占位） | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `docs/00-09` 内容、`docs/design/*`、`docs/research/*` 项目事实 | L3 | 项目事实 | 不参与同步 | 派生项目填 |
| `scripts/sync-template.*`、`scripts/check-derived-sync.*`、`scripts/check-template.*`、`scripts/new-project.sh` 等通用脚本 | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `domain-template-sync.json`、`scripts/sync-domain-template.*`、`scripts/check-domain-derived-sync.*`、`scripts/check-agent-template.*`、`scripts/new-domain-project.*` | L2 | 领域所有权标记 | L2→L3 下行（脚本留原位） | 是 |
| `VERSION`、`CHANGELOG.md`、`CHANGELOG-PLAIN.md`、`TEMPLATE-BASE.md` | L2 | 领域所有权标记 | sync 不覆盖（`--domain-template`） | 是 |
| `domain-overlay/agent-system/*`（含本文件、profiles/、docs/design/、docs/research/） → L3 `template-docs/agent-system/*` 与 `docs/design\|research/` | L2 | 领域所有权标记 | L2→L3 下行 | 是 |
| `domain-overlay/rules/*` → L3 `ai/agent-rules/*` | L2 | 领域所有权标记 | L2→L3 下行 | 是 |
| `_proposals/*`、`_archive/*`、`_examples/*`、`domain-overlay/README.md` | L2 | 领域所有权标记 | 不参与同步 / 不下发 | 是 |
| 根 `README.md` | L2 | 领域所有权标记 | 不参与同步 | 是（本仓为领域模板说明；派生项目根 README 才由 L3 项目填写） |

## AI 判层规则

1. 查本表定位路径所属层类。
2. **L1 文件**：不得本地编辑；要改先在本仓库 `_proposals/` 起草，成熟后 `submit-proposal` 回流母模板。
3. **L2 文件**：领域模板维护者可直接编辑；属本仓库自治范围。
4. **L3 文件**：派生项目填写；本仓库（作为领域模板）只提供骨架 / 撰写提要，不预填业务事实。
5. **领域规则件**（L2 源 `domain-overlay/rules/`、`domain-overlay/doc-standards/agent-*.md`；下发 L3 后在 `ai/agent-rules/`、`ai/doc-standards/agent-*.md`）采用 D7 过渡期读取路径：AI 处理 agent 任务时，**在 L2 仓**完成母模板 `ai/index.md` 启动路由后按 `TEMPLATE-BASE.md` 与 `domain-overlay/README.md`、**在 L3 项目**以根 `CLAUDE.md` 为入口按 `TEMPLATE-BASE.md` 与 `template-docs/agent-system/README.md` 主动读取领域 overlay；不等母模板强制路由钩子。
