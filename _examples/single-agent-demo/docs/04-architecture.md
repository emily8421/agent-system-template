# 04 Architecture

## Context

`single-agent-demo` is a local CLI program. It demonstrates a bounded agent loop without relying on external runtimes.

## Components

| Component | File | Responsibility |
|---|---|---|
| CLI | `agent_demo.py` | Parse prompt and approval flag, print JSON. |
| Planner | `run_agent()` | Decide whether the request is normal, unsafe, or high risk. |
| Tool router | `ToolRouter` | Apply risk classification before local tool execution. |
| Memory | `DemoMemory` | Store only safe in-process facts. |
| Trace recorder | `TraceRecorder` | Emit ordered trace events. |
| Evaluator | `evaluate_answer()` | Record minimal output quality checks. |

## Flow

1. CLI passes the user prompt to `run_agent()`.
2. The agent records request and planning trace steps.
3. Safety checks run before tool routing.
4. Low-risk tools produce local policy/draft output.
5. High-risk publish intent returns `needs_approval` unless `--approve-high-risk` is provided.
6. The evaluator records final checks and the CLI prints JSON.

## Design Links

- Tool gates: `docs/design/tool-permission-model.md`
- Memory: `docs/design/memory-and-state.md`
- Trace: `docs/design/trace-and-replay.md`
- HITL and safety: `docs/design/hitl-and-safety.md`
