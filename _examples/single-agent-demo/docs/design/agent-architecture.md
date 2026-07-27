# Agent Architecture

## Profile

- Profile: single agent.
- Runtime: local Python process.
- Autonomy: bounded to answer drafting and local demo tools.
- Human role: approval authority for high-risk actions.

## Loop

| Step | Actor | Behavior | Requirement |
|---|---|---|---|
| 1 | User | Sends prompt through CLI. | U-001 |
| 2 | Agent planner | Classifies prompt and intent. | REQ-001 |
| 3 | Safety gate | Refuses prompt injection before tools. | REQ-005 |
| 4 | Tool router | Runs low-risk tools or stops for approval. | REQ-002 |
| 5 | Memory | Stores only safe, in-process facts. | REQ-003 |
| 6 | Evaluator | Records output checks. | REQ-004 |

## Boundaries

The agent does not call external services, write files, retain state after process exit, or execute arbitrary commands.
