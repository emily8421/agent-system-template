# Agent Tool Permission Model Doc Standard

> Layer: L2 domain-owned doc standard for `docs/design/tool-permission-model.md`.

## Required Sections

- Tool registry: tool name, owner, purpose, input contract, output contract.
- Risk class for every tool.
- Approval requirement and who approves.
- Sandbox / dry-run / live mode behavior.
- Trace fields for invocation, denial, approval, failure, and rollback.
- Mapping to REQ-ID / NFR / TC-ID.

## Required Checks

- Dangerous operations such as file deletion, external writes, spending money, permission changes, deployment, or production data writes require confirmation.
- Unknown risk defaults upward, not downward.
- Tool denial is an explicit success path when the request is unsafe.
- Tests or manual checks cover allowed, denied, and approval-required paths.

## Forbidden

- Allowing arbitrary command execution without a documented policy.
- Letting the agent bypass a human rejection through another route.
- Logging raw secrets or sensitive payloads in trace.
