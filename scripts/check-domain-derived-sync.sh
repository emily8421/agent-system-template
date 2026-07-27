#!/usr/bin/env bash
# check-domain-derived-sync.sh - Validate L2 -> L3 agent domain sync state.
set -euo pipefail

usage() {
  echo "Usage: bash scripts/check-domain-derived-sync.sh --target <derived-project> [--source <agent-system-template>] [--advisory]" >&2
}

SOURCE=""
TARGET=""
ADVISORY=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      SOURCE="${2:-}"
      shift 2
      ;;
    --target)
      TARGET="${2:-}"
      shift 2
      ;;
    --advisory)
      ADVISORY=1
      shift
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -z "$SOURCE" ]]; then
  SOURCE="$(cd "$SCRIPT_DIR/.." && pwd)"
else
  SOURCE="$(cd "$SOURCE" && pwd)"
fi
if [[ -z "$TARGET" ]]; then
  usage
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

python - "$SOURCE" "$TARGET" "$ADVISORY" <<'PY'
import hashlib
import json
import os
import sys

source, target, advisory_raw = sys.argv[1:4]
advisory = advisory_raw == "1"
manifest_path = os.path.join(source, "domain-template-sync.json")
with open(manifest_path, "r", encoding="utf-8") as f:
    manifest = json.load(f)

def digest(path):
    if not os.path.isfile(path):
        return ""
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

issues = 0
failures = 0
print("==> Domain derived sync check")
print(f"source: {source}")
print(f"target: {target}")
print(f"mode: {'advisory' if advisory else 'strict'}")
print()

for item in manifest["files"]:
    src_rel = item["source"]
    dst_rel = item["target"]
    mode = item.get("mode", "copy-if-missing")
    src = os.path.join(source, *src_rel.split("/"))
    dst = os.path.join(target, *dst_rel.split("/"))
    if not os.path.isfile(src):
        print(f"FAIL source missing: {src_rel}")
        failures += 1
        continue
    if not os.path.isfile(dst):
        print(f"WARN target missing: {dst_rel}")
        issues += 1
        continue
    if mode == "overwrite-domain-owned":
        if digest(src) == digest(dst):
            print(f"OK   domain-owned matches: {dst_rel}")
        else:
            print(f"WARN domain-owned differs: {dst_rel}")
            issues += 1
    else:
        print(f"OK   project-owned exists: {dst_rel}")

print()
if failures:
    print(f"FAIL domain derived sync check failed: {failures} fatal issue(s).")
    sys.exit(1)
if issues and not advisory:
    print(f"FAIL domain derived sync check found {issues} issue(s).")
    sys.exit(1)
if issues:
    print(f"OK advisory check completed with {issues} issue(s).")
else:
    print("OK domain derived sync check passed.")
PY
