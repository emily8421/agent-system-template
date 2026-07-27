# HITL And Safety

## Human-In-The-Loop

The only approval gate in this demo is high-risk publish intent. Without approval, the agent returns `needs_approval` and does not execute the high-risk tool.

## Safety Checks

| Risk | Control |
|---|---|
| Prompt injection | Refuse before tool routing. |
| Sensitive memory | Reject storage and redact trace details. |
| External side effects | Not implemented in this demo. |
| High-risk publish action | Require approval. |

## Requirement Mapping

- REQ-002: high-risk approval gate.
- REQ-003: sensitive memory handling.
- REQ-005: injection refusal.
