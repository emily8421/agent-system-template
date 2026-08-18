# 派生同步运行记录：agent-system-template → v1.64.0

## 基本信息

- 项目：agent-system-template（领域模板，agent 系统）
- 同步日期：2026-08-18
- 同步前模板版本：v1.61.4
- 目标模板版本：v1.64.0（母模板 C1 两批落地：v1.63.0 文档体系治理 / v1.64.0 形态裁剪与场景指引，含 v1.62.x Web UI 知识层）
- 项目 / 领域模板自身版本（`VERSION`）：v0.4.2（领域版本保留，未变）
- 继承版本记录（`TEMPLATE-BASE.md`）：存在；Lineage type: domain template；当前同步到：v1.64.0
- 同步分支：`chore/sync-template-v1.64.0`
- 实际同步提交（非 PR merge commit）：`9052090`（前置 bootstrap `cb157a3`）
- 操作入口：模板仓发起模式（`/run sync-methodology`，AI = Claude Code）
- AI 工具 / CLI：Claude Code

## 执行命令

- 预检 A 阶段（身份与安全）：路径存在 / git 仓（main）/ 工作区干净 / 无 stash / TEMPLATE-BASE lineage = domain template —— 全 pass
- 预检 B 阶段（同步能力）：sync-template.ps1/.sh、check-derived-sync.ps1、template-sync.json —— 全 pass
- fetch 目标版本：`git fetch --no-tags --depth=1 https://github.com/emily8421/ai-project-template.git main` → `git show FETCH_HEAD:VERSION` = v1.64.0
- bootstrap：`git checkout FETCH_HEAD -- scripts/sync-template.sh` → commit `cb157a3`（+6 行）
- dry-run：`powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --dry-run --domain-template`（EXIT=0）
- commit：`powershell -ExecutionPolicy Bypass -File scripts/sync-template.ps1 --commit --domain-template` → `9052090`（44 文件）
- 边界验证：`powershell -ExecutionPolicy Bypass -File scripts/check-derived-sync.ps1 9052090` ✅ 通过

## 同步结果

- 44 个模板方法论文件刷新，全部在同步清单内；无根 README / `ai/project-rules.md` / `ai/domain-rules.md` / `docs/00-09` / 业务代码误触。
- 本批新增下行内容：
  - v1.62.x：`template-docs/ui-knowledge/`（4 文件）+ `frontend-ui-reference-analysis-template.md` + ui-prototype-exploration 接入
  - v1.63.0：doc-standards 00-06/design OO overlay（DIAG-UC/DOM/CLS-PRELIM/STATE/CLS、概念/物理 ERD 两层）+ 02/04 引用式概述章骨架 + E6 反向同步落点约束 + 19-docs-evaluation 阶段归属审计 + §13 plantuml 指引 + 图表生成式镜像机制 + `template-docs/examples/extract-diagrams.mjs` 样例 + `docs/references/` 可选参考区约定 + 方法论产物映射示例表
  - v1.64.0：`new-project.sh --shape` + project-rules 标准 §3 裁剪执行步骤 + post-sync-cleanup 裁剪一致性审计项 + global-rules §5 根目录三层地图 + session-rules §4.3 pitfall 存量维护触发 + scenario-guides §8 项目特有场景手册指引
- 版本治理：领域模式正确——`VERSION`/`CHANGELOG`/`CHANGELOG-PLAIN` 保留领域自有（v0.4.2），`TEMPLATE-BASE.md` 更新为 inherited v1.64.0，`upstream/CHANGELOG*.md` 刷新。

## Workflow 检查

- `.github/workflows/project-check.yml` 已是派生版（仅 sync 提交跑 check-derived-sync，普通 PR 不跑 check-template）——无需迁移。

## 提案回流收口

| 本地提案 / 记录 | 模板 issue / PR | 远端状态 | 处理结果 | 本地动作建议 |
|---|---|---|---|---|
| `TEMPLATE-UPGRADE-agent-template-buildout.md`（总纲） | 无直接 issue（母模板侧对应 inheritance 提案） | — | 主体已落地（领域 v0.3.0 发布）；D6 CI 暂缓 / Batch 4 远期开放项在 `_archive-followups.md` §4 镜像 | **保留原位**（总纲含开放项，提案自述不归档） |
| `analysis-agent-template-architecture.md` | — | — | 前置分析记录 | 保留 |
| `_archive-followups.md` | — | — | 开放项集中登记 | 保留 |

- 母模板侧 C1 批（#350/#351/#354-#358）与本仓无直接回流关系；本次同步后新增回流候选：无（领域模板按 buildout 提案策略「跨领域通用经验成熟后另起提案回流」，本批无新增）。

## post-sync-cleanup / docs-system-audit（轻量）

- 本仓为领域模板，`docs/` 下无业务 00-09 项目事实（领域内容在 `template-docs/agent-system/`），post-sync-cleanup 的 docs 分区审计与裁剪一致性审计**轻量执行**：
  - 新审计项「§3 声明不启用 / 省略，但目录或骨架文档仍存在」：本仓 `ai/project-rules.md`（领域种子）未声明省略 06/07，目录结构与声明一致——无告警。
  - docs 分区：`docs/` 根目录仅 `README.md`（模板件），无越界文件——通过。
- docs-system-audit 同步后模式：跳过（无项目事实文档链；领域 scaffold 由领域自检覆盖）。标为**轻量执行 / 等价替代（领域自检）**。

## 项目验证建议

- 领域自检入口（如 `scripts/` 下领域检查脚本）建议在合并前跑一次；本次会话未运行——记录为**未验证项**，由维护者按需执行。
- 母模板 check-template 不适用于派生仓（SOP 明确）。

## 遇到的问题与后续动作

- bootstrap 一次（同步脚本 +6 行），按 SOP 正常路径，无异常。
- GitHub API 当日（08-18）间歇 503：模板仓侧 PR 创建曾受阻，重试恢复；本仓 push / PR 如遇同样情况，等待重试即可。
- 后续：领域模板侧 `ai/project-rules.md`（种子实例）无需迁移——本批无新增项目专属骨架字段（--shape 为脚本参数、三层地图为呈现层）。

## 结论

同步主链完成：预检 → bootstrap → dry-run → commit → 边界验证全过；提案回流收口无归档动作；运行记录本文件。待 PR 合并。
