# Tool Permission Model

## Tool Classes

| Tool | Risk | Behavior |
|---|---|---|
| `lookup_policy` | Low | Returns static local policy guidance. |
| `draft_answer` | Low | Produces a deterministic response from local inputs. |
| `publish_update` | High | Requires explicit human approval. |

## Approval Rule

High-risk tools cannot run unless `approve_high_risk=True` is passed to `run_agent()` or `--approve-high-risk` is passed to the CLI.

## Requirement Mapping

- REQ-002: high-risk actions stop for approval.
- TC-003: approval missing path.
- TC-005: approval granted path.
