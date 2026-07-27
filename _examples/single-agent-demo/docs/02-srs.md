# 02 SRS

## Functional Requirements

| ID | Requirement | Tests |
|---|---|---|
| REQ-001 | The system shall implement a single-agent loop with plan, tool routing, answer drafting, and evaluation. | TC-001 |
| REQ-002 | The system shall classify high-risk tool actions and stop for human approval before executing them. | TC-003, TC-005 |
| REQ-003 | The system shall avoid storing sensitive terms in demo memory and shall redact sensitive trace details. | TC-004 |
| REQ-004 | The system shall record ordered trace steps for each run so behavior can be replayed manually. | TC-001, TC-004 |
| REQ-005 | The system shall refuse prompt-injection style requests before tool execution. | TC-002 |

## Non-Functional Requirements

| ID | Requirement | Tests |
|---|---|---|
| NFR-SEC-001 | No network, file writes, model provider calls, or external dependencies are required. | TC-001 |
| NFR-OBS-001 | Trace entries must include `step_id`, `actor`, `event`, and `detail`. | TC-001 |
| NFR-TEST-001 | Behavior must be covered by Python `unittest`. | TC-001 to TC-005 |
