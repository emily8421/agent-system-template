# Project Rules: single-agent-demo

> L3 project-owned rules for the Batch 3a validation example.

## Project Scope

- Phase: validation demo.
- Shape: single agent, local CLI.
- Runtime: Python standard library only.
- External access: no network, no model provider, no package installation.
- Persistence: none; memory is in-process only.
- UI/API: none.

## Agent Rules

- The agent must keep every run traceable through ordered trace steps.
- Low-risk local tools may run without interruption.
- High-risk actions such as publish/send/write outside the process must stop for human approval.
- Sensitive values must not be stored in memory or trace details.
- Prompt-injection style requests must be refused before tool execution.

## Verification

- Run `python -m unittest discover -s tests` before changing behavior.
- Update `docs/09-verification.md` and `docs/research/agent-standard-mapping.md` when REQ/TC coverage changes.
