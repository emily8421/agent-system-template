# Trace And Replay

## Trace Contract

Each run emits a `trace_id` and ordered trace entries.

| Field | Meaning |
|---|---|
| `step_id` | Stable order marker such as `T001`. |
| `actor` | User, planner, safety, tool router, memory, evaluator, or agent. |
| `event` | Short event name. |
| `detail` | Redacted structured details. |

## Replay

Manual replay reads the trace in order and compares each decision with `docs/09-verification.md`. Because this demo has no external dependencies, replay does not require captured HTTP, model, or database state.

## Requirement Mapping

- REQ-004: ordered trace steps.
- NFR-OBS-001: required trace fields.
- TC-001 and TC-004: trace coverage.
