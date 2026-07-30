# Checklist Validation

## Source

Checklist under test: `template-docs/agent-system/agent-system-checklist.md`.

## Result

The checklist is usable for a concrete single-agent project. It helped force explicit answers for profile selection, traceability, HITL behavior, memory boundaries, and evaluation coverage.

## Findings

| Area | Result | Batch 3b Feedback |
|---|---|---|
| Profile | Single-agent path is clear. | Multi-agent profile should remain advisory until validated by a real project. |
| Tool permissions | Risk classes map cleanly to code. | Self-check should detect missing high-risk approval documentation. |
| Memory | No-persistence demo is easy to express. | Self-check should allow explicit "not applicable" for DB/vector memory. |
| Trace/replay | Required fields are concrete enough. | Self-check can require `trace_id` and ordered step fields. |
| HITL/safety | Safety gates are testable. | Advisory mode is appropriate before real project validation. |
| Eval | Unit tests cover the minimum. | Mapping table should be required before sync automation is trusted. |

## Recommendation

No checklist text change is required in Batch 3a. Use this validation file and `agent-standard-mapping.md` as input to Batch 3b design.

## 2026-07-29 L2 to L3 Sync Pilot

Pilot target: `_examples/single-agent-demo`.

Commands executed:

- `powershell -ExecutionPolicy Bypass -File scripts\sync-domain-template.ps1 -Source . -Target _examples\single-agent-demo -DryRun`
- `powershell -ExecutionPolicy Bypass -File scripts\sync-domain-template.ps1 -Source . -Target _examples\single-agent-demo -Commit`
- `powershell -ExecutionPolicy Bypass -File scripts\check-domain-derived-sync.ps1 -Source . -Target _examples\single-agent-demo -Advisory`
- `powershell -ExecutionPolicy Bypass -File scripts\check-agent-template.ps1 -Target _examples\single-agent-demo`
- `python -B -m unittest discover -s tests`
- `powershell -ExecutionPolicy Bypass -File scripts\check-markdown-clean.ps1 _examples\single-agent-demo\template-docs _examples\single-agent-demo\ai _examples\single-agent-demo\docs _examples\single-agent-demo\README.md _examples\single-agent-demo\TEMPLATE-BASE.md`

Result:

- `sync-domain-template.ps1 -DryRun` showed 20 domain-owned overlay files would be added.
- Existing project-owned agent design and research files were skipped, not overwritten.
- `sync-domain-template.ps1 -Commit` copied 20 files; the target is not an independent Git root, so no nested commit was created.
- `check-domain-derived-sync.ps1 -Advisory` passed with all manifest entries OK.
- `check-agent-template.ps1 -Target _examples\single-agent-demo` passed with 0 finding(s).
- Unit tests passed: 5 tests.
- Markdown clean passed: 33 file(s).

Gate interpretation:

| Finding Type | Pilot Result | Gate Decision |
|---|---|---|
| Missing domain-owned overlay in an L3 target before sync | Resolved by running domain sync. | Candidate gate after sync; before sync it is an actionable advisory. |
| Existing project-owned docs differ from L2 source skeleton | Correctly skipped by `copy-if-missing`. | Do not gate; project facts must remain owned by L3. |
| Missing agent standard mapping | Present in pilot and detected by `check-agent-template`. | Candidate gate for mature L3 agent projects. |
| L2 root missing `docs/design/*` project docs | Not relevant to this L3 pilot; L2 keeps standards under `template-docs/agent-system/docs/*`. | Do not gate on the L2 root. |

Recommendation:

- Keep `check-domain-derived-sync` advisory-first for pre-sync diagnosis, but allow a strict post-sync mode to fail missing / differing domain-owned overlay files.
- Keep project-owned design and research files as `copy-if-missing`; do not add overwrite behavior without an explicit user-confirmed update mode.
- Treat `agent-standard-mapping.md` as a strong candidate for L3 gate once one more non-example agent project validates the same mapping pattern.
