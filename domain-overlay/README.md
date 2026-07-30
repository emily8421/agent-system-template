# domain-overlay/ — agent 领域增量（L2 自有）

> 层归属：L2 领域自有。本目录集中 `agent-system-template` 叠加在母模板通用方法论之上的**领域增量**。本仓根目录其余的 `ai/`、`template-docs/`、`scripts/`、`docs/` 骨架是**继承自母模板的通用方法论**（L1 下发、按 `template-sync.json` 同步、不在本仓直接改）。进本目录一眼即可区分「通用方法论」与「领域增量」。

## 这是什么

母模板只管通用方法论；agent 类系统还需要一组 agent 专用标准件。这些标准件集中在本目录，作为领域增量整体下发给 agent 派生项目（L3）。这是「领域模板 = 通用方法论 × 领域增量」里「领域增量」那半边的物理落点。

## 内容与下发映射

| 子目录 | 内容 | 对应的 L3 下发位置（target，见 `domain-template-sync.json`） |
|---|---|---|
| `rules/` | agent 实现规则、工具安全规则（AI 在 agent 任务前读） | `ai/agent-rules/` |
| `doc-standards/` | agent 文档审计基线（架构 / 权限 / memory / trace / HITL / eval） | `ai/doc-standards/agent-*.md` |
| `agent-system/` | 领域标准件文档、`layer-map.md`、`agent-system-checklist.md`、`profiles/`、L2→L3 playbook、设计 / 研究骨架 | `template-docs/agent-system/` 与 `docs/design\|research/` |

> **L2 源路径（本目录）与 L3 target 路径不同**：领域件下发到 L3 后仍落在 L3 的 `ai/`、`template-docs/` 下（B1：target 不变）。两边路径映射以 `domain-template-sync.json` 与 `agent-system/layer-map.md` 为准。

## 编辑边界

- 本目录是 **L2 自有**：领域模板维护者可直接编辑，不会被母模板同步覆盖。
- 修改后经 `domain-template-sync.json` + `scripts/sync-domain-template.*` 下发给 L3。

## 为何 scripts 与 sync.json 不在此处

领域同步 / 自检 / 派生脚本（`sync-domain-template.*`、`check-domain-derived-sync.*`、`check-agent-template.*`、`new-domain-project.*`）与 `domain-template-sync.json` 因被脚本路径硬编码引用，留在仓库根 `scripts/` 与根目录，不在本目录。彻底解耦它们属轨 B（回流母模板 MAJOR），详见 `_proposals/TEMPLATE-UPGRADE-domain-overlay-relocation.md`。

## AI 读取路径（D7）

1. 先完成母模板 `ai/index.md` / `ai/rules-core.md` 启动路由（L1，零领域引用）。
2. 读 `TEMPLATE-BASE.md` 确认本仓是 L2 领域模板。
3. 读 `agent-system/layer-map.md` 判层；agent 任务前读 `rules/` 与对应 `doc-standards/`。
