# _governance/ — 治理记录容器（L2 自有）

> 层归属：L2 领域自有。本容器对齐母模板 v1.67.0 治理目录容器口径（本仓 v0.5.0 Batch C 迁入）：项目治理记录与项目产出分离，根目录保持简洁。不参与任何同步，由本仓自行治理；分层导航见 `domain/layer-map.md`。

## 分区

| 分区 | 用途 |
|---|---|
| `_proposals/` | 提案收件箱：可回流母模板的去项目化 `TEMPLATE-UPGRADE-*.md` 草案与前置分析（见 `_proposals/README.md`） |
| `_archive/` | 已落地 / 已决议提案归档（真值留痕，见 `_archive/proposals/README.md`） |
| `_examples/` | 领域标准件验证样例（`single-agent-demo/`），不是本仓产品实现 |
| `sync-records/` | L1→L2 母模板同步运行记录（`template-sync/`，按版本一份） |
| `ai-records/` | AI 协作记录入库位（token-hotspots / pitfalls 阶段汇总等；默认空，见 `ai-records/README.md`） |

> 迁移记录（2026-09-11）：`_proposals/`、`_archive/`、`_examples/`、`sync-records/` 由根级 `git mv` 迁入本容器（v1.67.0 前存量仓容器迁移）；历史路径引用以 Git 历史为准。
