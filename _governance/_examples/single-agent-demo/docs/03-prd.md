# 03 PRD

## Goal

Validate that the agent domain template can be manually applied to a small L3 single-agent project before automation is designed.

## Features

| ID | Feature | Included |
|---|---|---|
| F-001 | Single-agent CLI | One command accepts a prompt and emits JSON. |
| F-002 | Tool permission model | Local low-risk tools run; high-risk publish action needs approval. |
| F-003 | Trace and replay | Each run emits ordered trace steps. |
| F-004 | Safety handling | Prompt injection is refused; sensitive values are not stored. |
| F-005 | Eval plan | Unit tests and manual verification matrix cover core behavior. |

## Non-Goals

- No autonomous multi-agent orchestration.
- No external LLM, vector database, web API, or UI.
- No production-grade persistence, auth, telemetry, or deployment.
