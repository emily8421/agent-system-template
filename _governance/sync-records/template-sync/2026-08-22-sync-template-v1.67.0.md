# 派生同步运行记录：agent-system-template → v1.67.0

## 基本信息

- 项目：agent-system-template（L2 领域模板，agent 系统）
- 同步日期：2026-08-22
- 同步前模板版本：v1.64.0
- 目标模板版本：v1.67.0
- 项目 / 领域模板自身版本（`VERSION`）：v0.4.2（领域版本保留，未变）
- 继承版本记录（`TEMPLATE-BASE.md`）：存在；Lineage type: domain template；当前同步到：v1.67.0
- 同步分支：`chore/sync-template-v1.67.0`
- 实际同步提交（非 PR merge commit）：`4298d6a`（前置 bootstrap `242b9e7`）
- 操作入口：模板仓发起模式（`/run sync-methodology`，AI = Codex）

## 执行命令

- 预检 A 阶段：`main`、工作区干净、无 stash、领域 lineage 与 `--domain-template` 一致。
- 预检 B 阶段：`sync-template.ps1` / `check-derived-sync.ps1` / `template-sync.json` 均存在。
- bootstrap：`git checkout FETCH_HEAD -- scripts/sync-template.sh` → `242b9e7 chore: bootstrap latest sync script`。
- dry-run：`powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --dry-run --no-stat`（EXIT=0；v1.67.0；16 新增 / 132 修改）。
- commit：`powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --commit --domain-template` → `4298d6a sync template v1.67.0 from ai-project-template`。
- 边界验证：`powershell -ExecutionPolicy Bypass -File scripts/check-derived-sync.ps1`（EXIT=0；148 个同步清单内文件全部合规）。

## 同步结果

- 领域模板版本治理正确：保留 `VERSION` / `CHANGELOG.md` / `CHANGELOG-PLAIN.md`，更新 `TEMPLATE-BASE.md` 与 `upstream/CHANGELOG*.md`。
- 同步提交未触及根 `README.md`、`ai/project-rules.md`、`ai/domain-rules.md`、`docs/00-09` 或领域业务资产。
- Windows CRLF 警告仅在 Git 工作副本换行符转换时出现，不影响同步或边界验证结果。

## A13 完成判据矩阵

| A13 步骤 | 证据 | 状态 | 若非完成，原因 | 下一步 |
|---|---|---|---|---|
| 标准闭环计划 | 模板仓发起模式预检与逐仓计划 | 完成 |  |  |
| dry-run 预览 | `sync-template.ps1 --dry-run --no-stat`，EXIT=0 | 完成 |  |  |
| commit + 边界验证 | `4298d6a` + `check-derived-sync.ps1` 通过 | 完成 |  |  |
| post-sync-cleanup | 仅完成只读审计 | 轻量执行 | L2 专属脚本和旧路径仍有活跃依赖，不能按普通派生规则直接删除 | 独立评估 L2 路径迁移及引用更新 |
| docs-system-audit | 轻量审计 | 轻量执行 | 根 `docs/00-09` 是 L3 scaffold，不是本仓业务事实 | 真实 L3 派生验证时审计项目事实链 |
| 提案回流收口 | 未执行 | 未执行 | 尚未核对本地提案对应远端决议 | PR 前只读核对 issue / PR |
| 同步报告留痕 | 本记录 | 完成 |  |  |

## 同步后整理与文档审计摘要

- `docs/` 根目录符合 L3 scaffold 布局；`docs/env/local-env.md` 缺失符合 L2 模板豁免。
- 本仓仍保留 `sync-records/template-sync/` 作为既有 L2 记录路径；未新建 `_governance/` 容器，避免把本次同步与独立目录迁移混合。
- 发现根 `template-docs/` 旧路径副本、`check-template.*` 和 `e2e-sync-check.sh` 等文件仍被本仓 README、领域 overlay、历史记录和领域自检引用。它们不能按普通派生仓的残留规则直接删除。
- `ai/project-rules.md` 的项目自身版本和继承模板版本已按 live 文件事实回写。

## 项目验证建议

- 已执行：dry-run、同步提交、派生同步边界检查。
- 未执行：领域自检、L2→L3 下游同步验证、项目自有 workflow / CI。
- PR 前建议：运行领域自检入口，并只读核对本地提案关联的模板 issue / PR 状态。

## 后续动作

- 本次为“同步主链完成，A13 闭环尚有剩余项”。
- 将 L2 路径重组、模板仓专用脚本清理和 `_governance/` 容器迁移作为独立提案或维护任务；先建立引用映射和迁移验证矩阵，再决定是否删除旧路径。
- 推送、创建 PR、CI 和合并均未执行。
