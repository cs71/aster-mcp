#!/usr/bin/env bash
set -euo pipefail

# Sync fork main with upstream main, then re-apply local hardening changes if needed.
# Run from repo root: ./scripts/sync-upstream.sh

git fetch upstream
git checkout main
git pull --ff-only origin main

# Try a clean fast-forward merge from upstream
if git merge --ff-only upstream/main; then
  echo "[ok] Fast-forwarded from upstream/main"
else
  echo "[warn] Fast-forward not possible; trying regular merge"
  git merge --no-edit upstream/main
fi

# Optional: build sanity check for MCP package
if [ -d mcp ]; then
  (cd mcp && npm run -s build >/dev/null 2>&1 && echo "[ok] mcp build passed" || echo "[warn] mcp build failed")
fi

git push origin main
echo "[done] origin/main updated"
