# 归档提案转入的活跃待办

> 层归属：L2 领域自有。本文件跟踪从已归档提案（`_archive/proposals/`）转出的、尚未完成的活跃待办，避免被归档埋没。
> 提案主体已落地归档；此处只留"后续可选 / 未核 / 待真实项目触发"的尾巴。每条带来源提案 + 当前评估 + 建议处置。

## 1. new-domain-project 后置项（来源：TEMPLATE-UPGRADE-agent-new-domain-project，PR#12 v0.4.0）

- **C-001**：`scripts/new-domain-project.*` 加入 `domain-template-sync.json` 下发清单。
- **命令入口**：`ai/commands/*` 属 L1 下发，领域创建命令入口的边界待定。
- **CI 接入**：领域自检接 CI。
- 当前评估：CHANGELOG v0.4.0 已记"留待真实 agent 项目增多后再评估"，暂不阻塞。
- 建议处置：低优先；待 ≥2 个真实 agent 派生项目验证脚本稳定后再做。

## 2. domain-overlay 彻底清晰（来源：TEMPLATE-UPGRADE-domain-overlay-relocation，PR#13 v0.4.1，B1）

- **B2 / 轨 B**：~~`scripts/` 内领域脚本仍与通用脚本混层；L3 派生项目目录仍混层。~~ **已解决（v0.5.0 Batch C）**：母模板 v1.75.0 定型三层布局后，本仓已迁移为根级 `domain/`（README / layer-map / scenarios / scaffold / standards），L3 布局同步收敛（`domain/` 覆盖区，无第三份领域规则文件）；`scripts/` 内领域脚本与通用脚本共存为 v1.75.0 §5.4 索引表认定的正式口径（机制件按功能归位，文件名含 domain 可 grep），不再视为混层问题。
- 当前评估：已关闭（2026-09-11 Batch C 迁移）。

## 3. 母模板 wrapper PS5.1 stderr 陷阱（来源：TEMPLATE-UPGRADE-ps1-native-stderr-stop，PR#13 v0.4.1）

- 母模板 `sync-template.ps1` / `check-derived-sync.ps1` / `check-template.ps1` 的 `$ErrorActionPreference="Stop"` 是否把 native command stderr（如 git CRLF warning）当 `NativeCommandError` 中断。
- 当前评估：**本机实证未命中**（2026-09-10 v1.75.0 同步轮：Windows PowerShell 5.1 下 `sync-template.ps1` / `check-derived-sync.ps1` 带 git CRLF stderr 警告完整跑通，EXIT=0，见 `sync-records/template-sync/2026-09-10-sync-template-v1.75.0.md`）；证据仅覆盖 CRLF warning 类 stderr，其他 stderr 类别仍未核。本仓 `new-domain-project.ps1` 已修（`Invoke-SafeNative`）。
- 建议处置：核实母模板三脚本；若命中，与 issue #293（PATH，已修）同类但不同问题，另起回流提案。

## 4. buildout 开放项（保留提案，未归档）

见 `_proposals/TEMPLATE-UPGRADE-agent-template-buildout.md`：D6（领域自检接 CI，暂缓）、Batch 4（远期）。
