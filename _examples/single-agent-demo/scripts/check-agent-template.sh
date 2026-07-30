#!/usr/bin/env bash
# check-agent-template.sh - Advisory-first agent scaffold and traceability check.
set -euo pipefail

usage() {
  echo "Usage: bash scripts/check-agent-template.sh [--target <agent-project>] [agent-project]" >&2
}

TARGET=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      if [[ $# -lt 2 || "${2:-}" == --* ]]; then
        usage
        exit 1
      fi
      TARGET="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      if [[ $# -gt 0 ]]; then
        if [[ -n "$TARGET" ]]; then
          usage
          exit 1
        fi
        TARGET="$1"
        shift
      fi
      if [[ $# -gt 0 ]]; then
        usage
        exit 1
      fi
      ;;
    --*)
      usage
      exit 1
      ;;
    *)
      if [[ -n "$TARGET" ]]; then
        usage
        exit 1
      fi
      TARGET="$1"
      shift
      ;;
  esac
done

TARGET="${TARGET:-.}"
TARGET="$(cd "$TARGET" && pwd)"

python - "$TARGET" <<'PY'
import os
import re
import sys

target = sys.argv[1]
findings = 0

def warn(message):
    global findings
    print(f"WARN {message}")
    findings += 1

def ok(message):
    print(f"OK   {message}")

def require_file(rel):
    if os.path.isfile(os.path.join(target, *rel.split("/"))):
        ok(f"file exists: {rel}")
    else:
        warn(f"missing file: {rel}")

print("==> Agent template advisory check")
print(f"target: {target}")
print("strength: advisory-first")
print()

required = [
    "README.md",
    "TEMPLATE-BASE.md",
    "ai/project-rules.md",
    "docs/00-scenario.md",
    "docs/01-user-requirements.md",
    "docs/02-srs.md",
    "docs/03-prd.md",
    "docs/04-architecture.md",
    "docs/05-tech-spec.md",
    "docs/08-dev-plan.md",
    "docs/09-verification.md",
    "docs/design/agent-architecture.md",
    "docs/design/tool-permission-model.md",
    "docs/design/memory-and-state.md",
    "docs/design/trace-and-replay.md",
    "docs/design/hitl-and-safety.md",
    "docs/research/agent-eval-plan.md",
]
overlay = [
    "ai/agent-rules/agent-implementation-rules.md",
    "ai/agent-rules/tool-safety-rules.md",
    "ai/doc-standards/agent-architecture.md",
    "ai/doc-standards/agent-tool-permission-model.md",
    "ai/doc-standards/agent-memory-and-state.md",
    "ai/doc-standards/agent-trace-and-replay.md",
    "ai/doc-standards/agent-hitl-and-safety.md",
    "ai/doc-standards/agent-eval-plan.md",
]

for rel in required:
    require_file(rel)
for rel in overlay:
    if os.path.isfile(os.path.join(target, *rel.split("/"))):
        ok(f"domain overlay exists: {rel}")
    else:
        warn(f"domain overlay missing or not yet synced: {rel}")

texts = []
for root, _, files in os.walk(target):
    for name in files:
        if name.endswith(".md"):
            path = os.path.join(root, name)
            try:
                with open(path, "r", encoding="utf-8") as f:
                    texts.append(f.read())
            except OSError:
                warn(f"cannot read markdown: {path}")
all_text = "\n".join(texts)

print()
print("==> Traceability")
if re.search(r"REQ-[0-9A-Za-z-]+", all_text):
    ok("REQ-ID found in project docs")
else:
    warn("no REQ-ID found in project docs")
if re.search(r"TC-[0-9A-Za-z-]+", all_text):
    ok("TC-ID found in project docs")
else:
    warn("no TC-ID found in project docs")

mapping_path = os.path.join(target, "docs", "research", "agent-standard-mapping.md")
if os.path.isfile(mapping_path):
    with open(mapping_path, "r", encoding="utf-8") as f:
        mapping = f.read()
    if "L2 Standard" in mapping and "REQ-" in mapping and "TC-" in mapping:
        ok("agent standard mapping links L2 standards to REQ/TC")
    else:
        warn("agent standard mapping exists but lacks L2/REQ/TC links")
else:
    warn("agent standard mapping missing: docs/research/agent-standard-mapping.md")

print()
print(f"OK advisory check completed with {findings} finding(s).")
PY
