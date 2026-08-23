#!/usr/bin/env bash
# git commit-msg hook: normalizes the commit message to nightshift's
# Conventional Commits subset, rejecting it if the type prefix is
# missing or unrecognized.
#
# Install via: scripts/install-hooks.sh (symlinks this into .git/hooks/commit-msg)
set -euo pipefail

# Hooks are invoked by git with CWD set to the repo's top-level working
# directory, so a repo-relative path is more reliable here than resolving
# BASH_SOURCE (which doesn't follow the .git/hooks/ symlink on macOS).
REPO_ROOT="$(git rev-parse --show-toplevel)"
MSG_FILE="$1"

set +e
"$REPO_ROOT/scripts/commit-msg-normalize.sh" "$MSG_FILE"
STATUS=$?
set -e

if [[ $STATUS -ne 0 ]]; then
  echo "" >&2
  echo "❌ Commit message rejected. Expected: <type>: <subject>" >&2
  echo "   Valid types: feat fix docs refactor test chore perf ci" >&2
  echo "   Bypass in an emergency with: git commit --no-verify" >&2
  exit "$STATUS"
fi

exit 0
