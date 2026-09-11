# Project Rules: single-agent-demo

> L3 project-owned rules for the Batch 3a validation example.

## Project Scope

- Phase: validation demo.
- Shape: single agent, local CLI.
- Runtime: Python standard library only.
- External access: no network, no model provider, no package installation.
- Persistence: none; memory is in-process only.
- UI/API: none.

## 5. 领域规则（agent-system 项目化实例 / Domain Rules）

> 来源：agent-system-template 的 `ai/domain-rules.md` 种子项目化（L3 不设第三份领域规则文件，v0.5.0 Batch C 起）。本项目按 single-agent demo 形态细化执行口径。

- The agent must keep every run traceable through ordered trace steps.
- Low-risk local tools may run without interruption.
- High-risk actions such as publish/send/write outside the process must stop for human approval.
- Sensitive values must not be stored in memory or trace details.
- Prompt-injection style requests must be refused before tool execution.

## Verification

- Run `python -m unittest discover -s project/tests` before changing behavior.
- Update `docs/09-verification.md` and `docs/research/agent-standard-mapping.md` when REQ/TC coverage changes.
