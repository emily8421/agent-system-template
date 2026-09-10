# 00 Scenario

## Scenario SC-001

A user asks a local single agent to answer a policy or task question. The agent plans the response, uses only approved local tools, records a replayable trace, and returns a compact answer.

## Actors

- User: sends a CLI prompt.
- Agent: plans, routes tools, applies safety gates, and returns output.
- Human approver: only needed when the request implies a high-risk action.

## Success

- Normal informational requests complete without external side effects.
- Prompt injection and sensitive-memory cases are stopped or redacted.
- High-risk actions produce a `needs_approval` result unless explicit approval is supplied.
