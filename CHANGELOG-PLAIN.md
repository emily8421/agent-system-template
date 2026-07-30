# CHANGELOG-PLAIN

> 本文件记录 `agent-system-template` 领域模板自身版本的大白话说明；母模板同步不覆盖（见 `TEMPLATE-BASE.md` Version Semantics）。层归属：L2 领域自有。
> 母模板 `ai-project-template` 的发布历史不记在这里；继承参考见 `upstream/CHANGELOG.md` 与 `upstream/CHANGELOG-PLAIN.md`。

本文是 `CHANGELOG.md` 的大白话配套版，按同一版本顺序解释“这版到底改善了什么”。权威版本事实仍以 `VERSION`、`CHANGELOG.md`、`TEMPLATE-BASE.md` 和 Git 历史为准。

## v0.4.1（2026-07-30）

这一版把散落在各处的 agent 领域内容集中收拢到一个 `domain-overlay/` 目录，让仓库一眼能分清"哪些是继承母模板的通用方法、哪些是本领域自己加的"。

以前 agent 的规则、文档标准、标准件散在 `ai/`、`template-docs/`、`scripts/` 里，和母模板下发的东西混在一起，要靠查表才能判断一个文件是哪一层的、能不能改、会不会被同步覆盖——既容易看错，AI 也得猜。现在这些领域内容统一放进 `domain-overlay/`：根目录左边是继承来的通用方法（会同步、别动），`domain-overlay/` 是本领域自己加的部分（自己维护、整体下发给 agent 项目）。

主要变化：

- 把 `ai/agent-rules/`、`ai/doc-standards/agent-*.md`、`template-docs/agent-system/` 这些领域件用 `git mv` 挪进 `domain-overlay/`，文件历史保留；新增 `domain-overlay/README.md` 当入口说明。
- 同步清单 `domain-template-sync.json` 改了源头路径指向新位置，但**派生项目里落到哪里不变**（所以已有 agent 项目和示例完全不受影响）。
- 判层用的 `layer-map.md` 改成同时写"L2 源位置 → 派生项目里位置"两套路径，顺手修了把根 README 错分到 L3 的老问题；同步脚本、检查脚本主体不用改（它们按清单走）。
- 派生脚本 `new-domain-project.*` 加了一条：派生时把 `domain-overlay/` 剥掉（不然它会和下发的标准件重复）。
- 顺手修了几处过时：根 README 的版本号、说明书写"创建脚本还没做"（其实上版已做）。

还没彻底清的（老实说）：派生出来的 agent 项目目录里，agent 规则还在 `ai/` 下混着；同步脚本也还和通用脚本混在 `scripts/`。这俩要彻底分开，得改母模板的目录约定（大改、走回流），等真有 agent 项目用起来再说。

## v0.4.0（2026-07-30）

这一版补上了"从本模板一键创建一个 agent 项目"的能力——之前只能同步已有项目，现在能直接生成新的。

主要变化：

- 新增 `scripts/new-domain-project.ps1`（PowerShell）和 `.sh`（Git Bash）：一条命令从本模板派生出一个干干净净的 agent 项目——自动把母模板的同步入口剥掉（agent 项目只认本模板这一层，不直连母模板）、写好 agent 项目身份文件、把 agent 标准件铺进去、配上领域 CI。
- 新增 `template-docs/agent-system/domain-derived-scenarios.md` 这份"创建 / 同步说明书"，并修了 README 里一句容易让人误解的话（明确 agent 项目单源锚定本模板）。

踩到的坑（给以后维护者）：PowerShell 5.1 要求脚本存成 **UTF-8 with BOM + CRLF**，否则中文会乱码、脚本会崩。已处理好并写进 `.gitattributes`（强制 CRLF），但 BOM 要靠编辑时保持。另外 `.sh` 还没在 Git Bash 实测。

还没做的：让"说一句新建项目"就能触发（命令入口）、把说明书自动塞给每个新项目、接入 CI——等真有多几个 agent 项目再说。

## v0.3.0（2026-07-27）

这一版把 `agent-system-template` 从“有一组 agent 文档骨架”推进到真正可作为 L2 领域模板使用。

主要变化是三件事：

- 明确了三层关系：母模板 `ai-project-template` 是 L1，本仓是 L2 领域模板，真正业务项目是 L3。`TEMPLATE-BASE.md` 和 `template-docs/agent-system/layer-map.md` 负责说明哪些文件归哪一层、哪些能改、哪些会同步覆盖。
- 补齐了 agent 领域标准件：agent 架构、工具权限、memory / state、trace / replay、HITL / safety、agent eval，以及 single-agent / multi-agent profile。
- 新增了 L2 到 L3 的同步与检查机制：`domain-template-sync.json`、`scripts/sync-domain-template.*`、`scripts/check-domain-derived-sync.*`，默认不覆盖 L3 派生项目自己的业务事实。

这一版还加入了 `_examples/single-agent-demo/`，用最小单 agent 项目验证领域标准件能落到项目文档、代码、测试和 REQ / TC 映射上。

暂缓项：领域自检仍保持 advisory-first，不接入阻断 CI。至少再经过一个真实 agent 派生项目验证后，再判断哪些检查可以升级为 gate。

## v0.1.0（2026-07-10）

这是 `agent-system-template` 的领域模板初始版本。

这一版基于母模板 `ai-project-template` 创建 agent 领域模板身份，保留自己的 `VERSION` 和 `CHANGELOG.md`，并引入第一批 agent 领域骨架：

- `template-docs/agent-system/README.md`
- `template-docs/agent-system/agent-system-checklist.md`
- agent 架构、工具权限、memory / state 的设计文档骨架
- agent eval 调研计划骨架

从这一版开始，本仓的版本号表示 agent 领域模板自身演进；母模板继承版本另由 `TEMPLATE-BASE.md` 记录。
