# TEMPLATE-BASE

> Example-owned file. This file describes the L2 -> L3 derivation used for Batch 3a validation.

## Upstream

- Domain template: `agent-system-template`
- Source commit used for manual derivation: `b5cbee4`
- Domain version target: `v0.2.0`
- Derivation mode: manual Batch 3a validation; no `domain-template-sync.json` or sync script is used in this example.

## Role

This directory is an L3 agent project example. It consumes the L2 standards in `template-docs/agent-system/` and turns them into project-level docs, implementation, and tests.

## Local Ownership

The example owns its project facts, code, tests, and validation notes. Upstream template changes should be re-applied deliberately after reading the mapping in `docs/research/agent-standard-mapping.md`.
