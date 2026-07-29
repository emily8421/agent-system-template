# 层映射表（Layer Map）

> 层归属：L2 领域自有。AI 进入 `agent-system-template` 后读此表即可稳定判层（路径 → 层类 → 标记 → 同步路径 → 编辑策略），不靠猜。
> 约定来源：buildout 提案 §4.5 层治理约定（G1 / G4）。三层定义见 `template-docs/domain-templates.md` §1。

## 三层定义

| 层 | 含义 | 本仓库中的身份 |
|---|---|---|
| **L1 母模板下发** | `ai-project-template` 下发，只读吸收 | 本仓库是 L1 的**下游** |
| **L2 领域自有** | `agent-system-template` 自身维护 | 本仓库 = L2 |
| **L3 派生项目填写** | 领域派生项目填业务事实 | 本仓库是 L3 的**上游** |

## 路径 → 层类 → 同步 / 编辑策略

| 路径 | 层类 | 标记 | 同步行为 | 本地可否编辑 |
|---|---|---|---|---|
| `ai/index.md`、`ai/rules-core.md`、`ai/global-rules.md`、`ai/document-lifecycle-rules.md`、`ai/implementation-lifecycle-rules.md`、`ai/session-rules.md` | L1 | sync notice | 母模板 sync 覆盖 | 否；改走回流 |
| `ai/project-rules.md` | L3 | 撰写提要 | 不参与同步 | 派生项目填 |
| `ai/doc-standards/README.md`、`ai/doc-standards/00-*.md`、`ai/doc-standards/01-*.md`、`ai/doc-standards/02-*.md`、`ai/doc-standards/03-*.md`、`ai/doc-standards/04-*.md`、`ai/doc-standards/05-*.md`、`ai/doc-standards/06-*.md`、`ai/doc-standards/07-*.md`、`ai/doc-standards/08-*.md`、`ai/doc-standards/09-*.md`、`ai/doc-standards/design-doc.md`、`ai/doc-standards/frontend-interaction.md`、`ai/doc-standards/ui-prototype-strategy.md` | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `ai/doc-standards/agent-*.md` | L2 | 领域所有权标记 | L2→L3 下行 | 是 |
| `ai/commands/*`、`ai/prompts/*` | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `docs/00-09` 骨架（撰写提要 / 占位） | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `docs/00-09` 内容、`docs/design/*`、`docs/research/*` 项目事实 | L3 | 项目事实 | 不参与同步 | 派生项目填 |
| `scripts/sync-template.*`、`scripts/check-derived-sync.*`、`scripts/check-template.*`、`scripts/new-project.sh` 等通用脚本 | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `domain-template-sync.json`、`scripts/sync-domain-template.*`、`scripts/check-domain-derived-sync.*`、`scripts/check-agent-template.*` | L2 | 领域所有权标记 | L2→L3 下行 | 是 |
| `template-docs/domain-templates.md`、`template-docs/docs-scaffold/*`、`template-docs/beginner-guide.md` 等通用方法论件 | L1 | sync notice | 母模板 sync 覆盖 | 否 |
| `VERSION`、`CHANGELOG.md`、`TEMPLATE-BASE.md` | L2 | 领域所有权标记 | sync 不覆盖（`--domain-template`） | 是 |
| `template-docs/agent-system/*`（含本文件） | L2 | 领域所有权标记 | 不参与母模板同步 | 是 |
| `ai/agent-rules/*` | L2 | 领域所有权标记 | L2→L3 下行 | 是 |
| `template-docs/agent-system/profiles/*` | L2 | 领域所有权标记 | L2→L3 下行 | 是 |
| `_proposals/*`、`_archive/*`、`_examples/*` | L2 | 领域所有权标记 | 不参与同步 | 是 |
| 根 `README.md` | L3 | 项目件 | 不参与同步 | 派生项目填 |

## AI 判层规则

1. 查本表定位路径所属层类。
2. **L1 文件**：不得本地编辑；要改先在本仓库 `_proposals/` 起草，成熟后 `submit-proposal` 回流母模板。
3. **L2 文件**：领域模板维护者可直接编辑；属本仓库自治范围。
4. **L3 文件**：派生项目填写；本仓库（作为领域模板）只提供骨架 / 撰写提要，不预填业务事实。
5. **领域规则件**（`ai/agent-rules/`、`ai/doc-standards/agent-*.md` 等 L2）采用 D7 过渡期读取路径：AI 处理 agent 任务时，完成 L1 启动路由后必须按 `TEMPLATE-BASE.md` 与 `template-docs/agent-system/README.md` 主动读取领域 overlay；不等母模板强制路由钩子。
