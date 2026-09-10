# Agent Trace And Replay Doc Standard

> Layer: L2 domain-owned doc standard for `docs/design/trace-and-replay.md`.

## Required Sections

- Trace contract: trace ID, run ID if applicable, step ID, actor, event, detail.
- Events: planning, tool invocation, permission decision, memory read/write, refusal, HITL, eval.
- Replay levels: dry, sandbox, live; live must be denied by default or require approval.
- Privacy handling: redaction, summarization, retention.
- Failure attribution categories.
- Mapping to REQ-ID / NFR / TC-ID.

## Required Checks

- Trace ordering is stable enough to replay or audit.
- Tool payloads and model prompts are redacted when needed.
- Replay does not trigger live side effects unless explicitly approved.
- Eval can use trace data without requiring private raw inputs.

## Forbidden

- Using trace as a secret store.
- Recording only final answers while omitting decisions and tool calls.
- Treating live replay as safe by default.
