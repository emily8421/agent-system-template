# project/ — agent 项目代码容器骨架

> 层归属：L2 领域自有（`domain/scaffold/` 领域派生项目生成件）。本骨架由 `new-domain-project.*` 与 `domain-template-sync.json`（copy-if-missing）种子化到 L3 派生项目的 `project/`；之后归项目自有，同步永不覆盖。L2 模板仓自身不启用 `project/`（无产品代码）。

## 形态裁剪（agent 领域默认口径）

创建 L3 项目时按形态决定子目录，决策记入项目 `ai/project-rules.md` §3：

| 形态 | 典型布局 | 裁剪 |
|---|---|---|
| Python 包 / CLI（默认） | `project/<包名>/`、`project/tests/` | 不建 frontend/backend/docker |
| 消息通道内 agent / 纯库 | `project/<包名>/`（或纯 `project/tests/` 验证件） | 同上 |
| Web / 桌面 agent 前端 | 叠加 `project/frontend/` | 按母模板 `web-fullstack-profile` §4-§5 口径 |
| 容器化部署 | 叠加 `project/docker/` | 部署边界写入 `docs/04` / `docs/05` |

约定：

- **代码只进 `project/`**，不在仓库根级散落（含脚本型实现与测试）；根级只保留方法论 / 治理 / 文档结构。
- agent 实现遵守 L2 领域规则（`ai/project-rules.md` §5 项目化实例：工具风险分级、trace 留痕、HITL 门）。
- 测试位置随形态：默认 `project/tests/`；运行口径写入 `docs/09-verification.md`。
- 修改本骨架（领域侧）经 L2 仓 PR；项目侧自定义不回写。
