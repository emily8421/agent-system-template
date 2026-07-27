# 09 Verification

## Automated Tests

Run from this directory:

```powershell
python -m unittest discover -s tests
```

Run from repository root:

```powershell
python -m unittest discover -s _examples/single-agent-demo/tests
```

## Test Matrix

| ID | Requirement | Test / Check | Expected Result |
|---|---|---|---|
| TC-001 | REQ-001, REQ-004, NFR-OBS-001 | `test_normal_run_has_trace_and_output` | Completed answer with ordered trace. |
| TC-002 | REQ-005 | `test_prompt_injection_refused_before_tools` | Refused before tool invocation. |
| TC-003 | REQ-002 | `test_high_risk_publish_requires_approval` | Returns `needs_approval`. |
| TC-004 | REQ-003, REQ-004 | `test_sensitive_memory_rejected_and_redacted` | Memory empty; trace has reject event and redaction. |
| TC-005 | REQ-002 | `test_approved_high_risk_records_tool` | Approved high-risk action is traceable. |

## Manual Acceptance

- Review `docs/research/agent-standard-mapping.md` to confirm every L2 standard has an L3 destination.
- Review `docs/research/checklist-validation.md` to confirm the checklist can be used on a concrete project.
