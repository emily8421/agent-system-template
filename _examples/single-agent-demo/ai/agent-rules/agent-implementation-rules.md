# Agent Implementation Rules

> Layer: L2 domain-owned. These rules apply to agent-system-template and agent-derived projects when agent domain rules are present (L2 source `domain-overlay/rules/`; L3 delivered at `ai/agent-rules/`).

## Read Path

1. Complete the L1 startup route from `ai/index.md` and `ai/rules-core.md`.
2. Read `TEMPLATE-BASE.md` and `template-docs/agent-system/layer-map.md` to identify L1 / L2 / L3 ownership.
3. Read `template-docs/agent-system/README.md` and the relevant profile before changing agent docs or code.
4. Read this file before agent implementation, refactor, sync, self-check, or eval work.

## Implementation Boundaries

- Do not bind the domain template to a specific agent runtime, model provider, vector store, UI, or business prompt.
- Do not implement behavior that lacks a REQ-ID, NFR, TC-ID, task, or documented manual acceptance path.
- Do not turn candidate, stub, advisory, or demo-only behavior into a mandatory production fact.
- Do not edit L1 mother-template files in place; route reusable cross-domain changes through `_proposals/`.

## Required Agent Controls

Every non-trivial agent implementation should define:

- Profile choice: single-agent by default; multi-agent only after explicit signals.
- Role boundaries: planner, executor, tool router, memory, evaluator, and optional supervisor.
- Tool permission model with high-risk actions separated from low-risk local operations.
- Memory and state policy, including sensitive-data exclusion and cleanup.
- Trace and replay contract with run / step IDs and privacy handling.
- HITL gates for high-risk or irreversible actions.
- Eval plan covering success, refusal, permission, memory, trace, and regression paths.

## Execution Rules

- Keep agent loops bounded by explicit stop conditions, retry limits, or human handoff.
- Record tool calls, permission decisions, memory writes, refusals, and eval results in traceable form.
- Prefer deterministic tests for local policy and safety behavior before relying on model-quality evals.
- When code and docs diverge, stop and decide whether to fix code back to docs or update docs through the documented lifecycle.
