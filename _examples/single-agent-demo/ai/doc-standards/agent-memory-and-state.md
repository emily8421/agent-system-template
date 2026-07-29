# Agent Memory And State Doc Standard

> Layer: L2 domain-owned doc standard for `docs/design/memory-and-state.md`.

## Required Sections

- State inventory: short-term context, long-term memory, cache, persistent store, checkpoints.
- Data classification: ordinary, sensitive, secret, regulated, derived summary.
- Retention and cleanup policy.
- Read / write permissions and owner.
- Recovery / replay relationship.
- Mapping to REQ-ID / NFR / TC-ID.

## Required Checks

- Sensitive data is excluded, redacted, encrypted, or explicitly justified.
- Memory writes are traceable and reversible where possible.
- Demo or in-process memory is not described as production persistence.
- Cleanup and retention behavior is testable or manually verifiable.

## Forbidden

- Storing tokens, passwords, private keys, or customer-sensitive data in plain text.
- Treating vector memory or cache as a source of truth without freshness rules.
- Creating persistent state without a matching docs/06 or technical-spec decision.
