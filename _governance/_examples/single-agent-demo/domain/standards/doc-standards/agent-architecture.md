# Agent Architecture Doc Standard

> Layer: L2 domain-owned doc standard for `docs/design/agent-architecture.md`.

## Required Sections

- Profile decision: single-agent / multi-agent, with reason.
- Role table: planner, executor, tool router, memory, evaluator, optional supervisor.
- Boundary table: what each role may and may not do.
- Flow: prompt / input to plan, tool calls, memory, eval, output.
- Failure handling: timeout, tool failure, loop guard, refusal, fallback, human handoff.
- Traceability: REQ-ID / NFR / TC-ID mapping.

## Required Checks

- No runtime or model provider is implied unless `docs/05-tech-spec.md` already chooses it.
- Multi-agent behavior is not asserted unless profile evidence exists.
- Every role or module maps to at least one REQ-ID or NFR.
- High-risk decisions refer to `docs/design/hitl-and-safety.md`.

## Forbidden

- Adding new product capabilities not present in `docs/03-prd.md`.
- Hiding permission boundaries inside prompt text only.
- Treating a stub, candidate, or future profile as implemented.
