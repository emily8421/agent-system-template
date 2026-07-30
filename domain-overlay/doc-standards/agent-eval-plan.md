# Agent Eval Plan Doc Standard

> Layer: L2 domain-owned doc standard for `docs/research/agent-eval-plan.md`.

## Required Sections

- Task set with stable eval IDs.
- Expected result and refusal criteria.
- Tool-call expectations.
- Trace and replay checks.
- Metrics: task completion, tool accuracy, refusal / overreach rate, cost, latency.
- Regression cadence and acceptance threshold.
- Mapping to REQ-ID / NFR / TC-ID.

## Required Checks

- The eval set includes success, refusal, permission, memory, trace, and failure cases.
- Metrics do not depend only on subjective answer quality.
- Model-provider-specific evals are optional unless the project explicitly binds a provider.
- Known unverified items remain visible.

## Forbidden

- Treating a demo smoke test as full production eval.
- Making cost / latency claims without measurement.
- Requiring live external side effects for routine regression.
