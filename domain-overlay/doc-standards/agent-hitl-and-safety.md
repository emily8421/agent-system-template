# Agent HITL And Safety Doc Standard

> Layer: L2 domain-owned doc standard for `docs/design/hitl-and-safety.md`.

## Required Sections

- High-risk action list.
- Approval points and approver role.
- Refusal and escalation behavior.
- Prompt-injection controls.
- Data leakage controls.
- Human takeover, pause, resume, rollback, and degraded mode.
- Mapping to REQ-ID / NFR / TC-ID.

## Required Checks

- High-risk actions stop before execution.
- Human rejection cannot be bypassed by retry wording or alternate tools.
- Safety controls are covered by tests or manual acceptance checks.
- Residual risks are explicitly listed with owner and review point.

## Forbidden

- Claiming safety is guaranteed by prompt wording alone.
- Defaulting to external write, publish, delete, deploy, or payment actions.
- Hiding irreversible actions inside low-risk tool names.
