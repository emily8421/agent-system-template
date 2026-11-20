# TEMPLATE-UPGRADE-sync-closing-version-pointer-check patch（old→new）
> 归档批注（2026-11-20）：B 组——主提案已随母模板 v1.79.2 采纳落地（issue #565）；本 patch 为措辞修订稿，内容已并入主提案落地形态。下行锚点 7beca4e（v1.79.5 同步 PR #29）。残留待办：无。

> 基于母模板 v1.79.1 文件内容起草；锚点如与最新版有偏移，按语义就近落位，落点裁量权在维护者。

## 1. `ai/prompts/maintainers/12-sync-template.md` 步骤 14（尾部追加）

old（步骤 14 现末句）：

```text
…如本次同步刷新了 `ai/doc-standards/domain-rules.md` 规范基线，对照它维护领域种子（§0-§4）。
```

new（末句后追加）：

```text
…对照它维护领域种子（§0-§4）。同步收尾另核对派生仓内非同步清单文件的版本复制指针（如 `ai/project-rules.md` §0 的领域模板版本 / 继承母模板版本、根 README 状态行等）与权威源（根 `VERSION` / `TEMPLATE-BASE.md`）一致；发现滞留即随收尾提交回写，或建议改写为纯指针（「以 <权威源> 为准，不复制版本号」）从源头消除漂移面。
```

## 2. `ai/prompts/maintainers/15-post-sync-cleanup.md` 第一段 §5（「审计版本机制启用状态」条后追加一条）

old（现条目，锚点）：

```text
- 审计版本机制启用状态：检查 `ai/project-rules.md` 是否含「项目版本管理」规则（辅信号，对应 §2.4 的 PATCH/MINOR/MAJOR 语义），以及 `.github/workflows/project-check.yml` 是否含「Check project version consistency」校验（主信号，防 VERSION↔CHANGELOG 漂移）。
```

new（其后追加，同措辞核心句）：

```text
- **审计非同步清单文件的版本复制指针**：核对 `ai/project-rules.md` §0 的领域模板版本 / 继承母模板版本、根 README 状态行等非同步清单文件中的版本复制与权威源（根 `VERSION` / `TEMPLATE-BASE.md`）一致；发现滞留即随收尾提交回写，或建议改写为纯指针（「以 <权威源> 为准，不复制版本号」）从源头消除漂移面。该审计同样适用于普通项目自查，不限于同步后。
```
