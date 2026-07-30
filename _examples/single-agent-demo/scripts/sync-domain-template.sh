#!/usr/bin/env bash
# sync-domain-template.sh - L2 agent domain template -> L3 agent project sync.
set -euo pipefail

usage() {
  echo "Usage: bash scripts/sync-domain-template.sh --target <derived-project> [--source <agent-system-template>] [--dry-run|--commit]" >&2
}

SOURCE=""
TARGET=""
MODE="--dry-run"
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
    --dry-run)
      MODE="--dry-run"
      shift
      ;;
    --commit)
      MODE="--commit"
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
if [[ "$MODE" == "--commit" ]]; then
  mkdir -p "$TARGET"
fi
TARGET="$(cd "$TARGET" && pwd)"

MANIFEST="$SOURCE/domain-template-sync.json"
if [[ ! -f "$MANIFEST" ]]; then
  echo "FAIL missing manifest: $MANIFEST" >&2
  exit 1
fi

python - "$SOURCE" "$TARGET" "$MODE" <<'PY'
import hashlib
import json
import os
import shutil
import subprocess
import sys

source, target, mode = sys.argv[1:4]
manifest_path = os.path.join(source, "domain-template-sync.json")
with open(manifest_path, "r", encoding="utf-8") as f:
    manifest = json.load(f)

version_file = os.path.join(source, manifest["source"].get("version_file", "VERSION"))
try:
    version = open(version_file, "r", encoding="utf-8").read().strip()
except OSError:
    version = "unknown"

def digest(path):
    if not os.path.isfile(path):
        return ""
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

print(f"==> Agent domain template sync ({mode.lstrip('-')})")
print(f"source: {source}")
print(f"target: {target}")
print(f"version: {version}")
print("policy: project facts copy-if-missing; domain-owned files may update")
print()

def git(*args):
    return subprocess.run(["git", "-C", target, *args], text=True, capture_output=True)

root = git("rev-parse", "--show-toplevel")
target_is_git_root = root.returncode == 0 and os.path.abspath(root.stdout.strip()) == os.path.abspath(target)
if mode == "--commit" and target_is_git_root:
    status = git("status", "--porcelain")
    if status.stdout.strip():
        print("FAIL target git working tree is not clean. Commit or stash target changes before domain sync.")
        sys.exit(1)

changed = []
errors = 0
for item in manifest["files"]:
    src_rel = item["source"]
    dst_rel = item["target"]
    item_mode = item.get("mode", "copy-if-missing")
    src = os.path.join(source, *src_rel.split("/"))
    dst = os.path.join(target, *dst_rel.split("/"))
    if not os.path.isfile(src):
        print(f"FAIL missing source file: {src_rel}")
        errors += 1
        continue
    if not os.path.exists(dst):
        print(f"ADD  {dst_rel} <= {src_rel}")
        if mode == "--commit":
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.copy2(src, dst)
            changed.append(dst_rel)
        continue
    if digest(src) == digest(dst):
        print(f"OK   {dst_rel}")
        continue
    if item_mode == "overwrite-domain-owned":
        print(f"UPD  {dst_rel} <= {src_rel}")
        if mode == "--commit":
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.copy2(src, dst)
            changed.append(dst_rel)
    else:
        print(f"SKIP {dst_rel} (project-owned exists; not overwritten)")

if errors:
    sys.exit(1)

print()
if mode != "--commit":
    print("INFO dry-run only; target unchanged.")
    sys.exit(0)

if not changed:
    print("INFO no files changed.")
    sys.exit(0)

if target_is_git_root:
    add = git("add", "--", *changed)
    if add.returncode != 0:
        print(add.stderr.strip())
        sys.exit(add.returncode)
    diff = git("diff", "--cached", "--quiet")
    if diff.returncode == 1:
        message = manifest["policy"]["commit_message"].replace("{version}", version)
        commit = git("commit", "-m", message)
        if commit.returncode != 0:
            print(commit.stderr.strip())
            sys.exit(commit.returncode)
        print(f"OK committed in target: {message}")
    elif diff.returncode == 0:
        print("INFO git index has no changes to commit.")
    else:
        print("FAIL git diff --cached failed in target.")
        sys.exit(diff.returncode)
else:
    print("INFO target is not an independent git root; files were copied but no git commit was created.")
PY
