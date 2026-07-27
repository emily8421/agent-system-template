# Memory And State

## State Model

The demo uses only in-process memory. There is no database, file write, cache, vector store, or cross-run persistence.

## Memory Policy

| Data Type | Handling |
|---|---|
| Non-sensitive topic text | May be stored in `DemoMemory` during the run. |
| Sensitive terms such as token, password, secret, API key, private key | Must not be stored. |
| Trace details | Must be redacted before recording. |

## Requirement Mapping

- REQ-003: sensitive memory rejection.
- TC-004: memory rejection and trace redaction.
