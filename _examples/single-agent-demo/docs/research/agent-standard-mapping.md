# Agent Standard Mapping

This file is the Batch 3a hard contract for Batch 3b. It maps L2 agent standards to L3 project docs, code, requirements, and tests.

| L2 Standard | L3 Destination | Code / Test Hook | Requirement / Test |
|---|---|---|---|
| `template-docs/agent-system/README.md` profile selection | `README.md`, `docs/03-prd.md` | `run_agent()` single-agent loop | U-001, REQ-001, TC-001 |
| `profiles/single-agent.md` | `docs/design/agent-architecture.md` | `run_agent()` | REQ-001, TC-001 |
| `docs/design/agent-architecture.md` | `docs/04-architecture.md`, `docs/design/agent-architecture.md` | `TraceRecorder`, `ToolRouter`, `DemoMemory` | REQ-001 to REQ-004 |
| `docs/design/tool-permission-model.md` | `docs/design/tool-permission-model.md` | `ToolRouter.run()` | REQ-002, TC-003, TC-005 |
| `docs/design/memory-and-state.md` | `docs/design/memory-and-state.md` | `DemoMemory.remember()` | REQ-003, TC-004 |
| `docs/design/trace-and-replay.md` | `docs/design/trace-and-replay.md`, `docs/09-verification.md` | `TraceRecorder.record()` | REQ-004, NFR-OBS-001, TC-001 |
| `docs/design/hitl-and-safety.md` | `docs/design/hitl-and-safety.md` | `detect_prompt_injection()`, `ToolRouter.run()` | REQ-002, REQ-005, TC-002, TC-003 |
| `docs/research/agent-eval-plan.md` | `docs/research/agent-eval-plan.md`, `docs/09-verification.md` | `tests/test_agent_demo.py` | TC-001 to TC-005 |
| `agent-system-checklist.md` | `docs/research/checklist-validation.md` | Manual review + tests | Checklist sections A to F |

## Batch 3b Implications

- `domain-template-sync.json` should preserve both the source standard path and the target project path.
- Sync automation must not overwrite project-owned facts such as scenario text, requirement IDs, or test names without an explicit update mode.
- A future `check-agent-template.*` should verify presence and traceability first, then evolve advisory checks after real project use.
