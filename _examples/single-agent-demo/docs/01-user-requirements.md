# 01 User Requirements

| ID | Requirement | Acceptance Signal |
|---|---|---|
| U-001 | As a user, I can ask one local agent to answer a policy/task question. | CLI returns `status=completed` and a concise answer. |
| U-002 | As a maintainer, I can see why the agent took each step. | Result contains ordered trace steps with actors and events. |
| U-003 | As a safety reviewer, I can verify high-risk actions require approval. | Publish-like requests return `needs_approval` without approval. |
| U-004 | As a security reviewer, I can confirm sensitive terms are not stored. | Memory rejects sensitive values and trace details are redacted. |
| U-005 | As a template maintainer, I can map docs to code and tests. | `docs/research/agent-standard-mapping.md` links standards, REQ IDs, and tests. |
