# 05 Tech Spec

## Runtime

- Language: Python 3.
- Dependencies: standard library only.
- Entry point: `agent_demo.py`.
- Test command: `python -m unittest discover -s tests`.

## Data Contracts

`run_agent(user_input: str, approve_high_risk: bool = False) -> dict`

Required result fields:

| Field | Meaning |
|---|---|
| `status` | `completed`, `refused`, or `needs_approval` |
| `output` | User-facing result text |
| `reason` | Present for refused or approval-gated results |
| `trace_id` | Stable ID derived from input |
| `trace` | Ordered trace entries |
| `memory` | In-process safe memory snapshot |

## Safety Defaults

- Prompt-injection phrases are refused before tool execution.
- Sensitive terms are redacted from trace details and output.
- Publish-like actions are classified as high risk.
