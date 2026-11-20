# 归档提案

> 层归属：L2 领域自有（`_archive/` 不在 `template-sync.json`，母模板同步不覆盖）。
> 本目录收纳主体已落地的 `TEMPLATE-UPGRADE-*` 提案，避免作为待办重复执行。归档规则见 `_proposals/README.md` §归档。

## 归档标准

提案满足以下任一条件即归档：

- **A 组（领域级）**：在本仓库落地（PR 合并 + CHANGELOG 记录）。
- **B 组（回流母模板）**：母模板已采纳落地（PR 合并或 issue 关闭）——无论是否经本提案正式 `submit-proposal` 回流，只要母模板已等价实现。

归档**不删原内容**；在每个提案 H1 下补归档批注（落地证据 PR#/commit + 残留待办指引）。活跃待办转 `_proposals/_archive-followups.md`，避免被归档埋没。

## 已归档提案（2026-08-05 首批）

| 提案 | 组 | 落地证据 | 残留待办 |
|---|---|---|---|
| domain-changelog-ownership | B→母模板 | 母模板 v1.60.1（保留清单 + upstream + 措辞） | — |
| token-hotspots-local-only | B→母模板 | 母模板 v1.57.2（.gitignore + §4.1 + 断言） | — |
| scenario-guides-three-layer-routing | B→母模板 | 母模板 scenario-guides §2.1 + 23-domain-template-lab | — |
| powershell-start-process-path-normalization | B→母模板 | 母模板三脚本 Repair-ProcessPathEnvironment + issue #293 CLOSED | — |
| agent-new-domain-project | A 领域 | PR#12, v0.4.0 | C-001 / 命令入口 / CI（见 followups） |
| domain-overlay-relocation | A 领域 | PR#13, v0.4.1（B1） | B2 / 轨 B（见 followups） |
| ps1-native-stderr-stop | A 领域 | PR#13, v0.4.1 | stderr 回流（见 followups，未核实） |
| l3-ai-entrypoint | A 领域 | PR#15, v0.4.2 | — |
| post-sync-cleanup-container-audit | B→母模板 | 母模板 v1.75.2（issue #463，2026-09-16 CLOSED；post-sync-cleanup 审计清单补存量仓治理容器迁移显式审计项） | — |

## 已归档提案（2026-11-16 第二批 · v1.79.1 同步轮收口）

> 归档操作序列按母模板 v1.79.1 固定步执行：`git mv` 与本索引表登记同批完成，不留「只 rename 未登记」中间态。

| 提案 | 组 | 落地证据 | 残留待办 |
|---|---|---|---|
| sync-route-annotations | B→母模板 | 母模板 v1.76.1 路由行拆分（「派生项目下行同步」最小必读集）+ v1.76.2 残余收口（issue #514 CLOSED 2026-11-03）；本仓下行锚点 982a7af（v1.79.1 同步） | — |
| structure-migration-precheck | B→母模板 | 母模板 v1.76.2「母仓结构取证」固定预检步（git-guide §5.5 + post-sync-cleanup 审计项引用；issue #515 CLOSED 2026-11-03）；本仓下行锚点 982a7af（v1.79.1 同步） | — |

## 已归档提案（2026-11-20 第三批 · v1.79.5 同步轮收口）

> 归档操作序列按母模板 v1.79.1 固定步执行：`git mv` 与本索引表登记同批完成，不留「只 rename 未登记」中间态。

| 提案 | 组 | 落地证据 | 残留待办 |
|---|---|---|---|
| sync-closing-version-pointer-check | B→母模板 | 母模板 v1.79.2 版本复制指针核对 advisory 步（12-sync-template 步骤 14 + 15-post-sync-cleanup §5 两处同措辞；issue #565 CLOSED，changelog 明确记录实施）；本仓下行锚点 7beca4e（v1.79.5 同步 PR #29） | — |
| sync-closing-version-pointer-check-patch | B→母模板 | 主提案措辞修订稿，内容已并入主提案落地形态（随上条同批归档） | — |

**保留未归档**：`_proposals/TEMPLATE-UPGRADE-agent-template-buildout.md`（总纲提案，D6 暂缓 / Batch 4 远期开放）。
