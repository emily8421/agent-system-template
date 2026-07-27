# single-agent-demo

> Layer: L3 example project derived from `agent-system-template`.

This is the Batch 3a validation example for the agent domain template. It is a minimal, runnable single-agent project that maps the L2 agent standards into L3 project docs and a small Python implementation.

## Run

```powershell
python agent_demo.py "summarize the escalation policy"
python -m unittest discover -s tests
```

## Scope

- Python standard library only.
- CLI-first; no service, UI, database, model provider, or network dependency.
- No persistent memory. Demo memory is in-process and rejects sensitive terms.
- High-risk tool actions stop for human approval.

## Document Chain

| Area | File |
|---|---|
| Project rules | `ai/project-rules.md` |
| Scenario to verification | `docs/00-scenario.md` to `docs/09-verification.md` |
| Agent design | `docs/design/*.md` |
| Eval and mapping | `docs/research/*.md` |
| Implementation | `agent_demo.py`, `tests/test_agent_demo.py` |

`docs/06-db-design.md` and `docs/07-api-spec.md` are intentionally omitted because this demo has no persistence layer and no API surface.
