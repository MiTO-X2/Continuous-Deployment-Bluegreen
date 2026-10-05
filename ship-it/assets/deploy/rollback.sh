#!/usr/bin/env bash
# Instant rollback = flip back to the previous, still-running environment.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE="$ROOT/.prod"
LIVE=$(cat "$STATE/live_color")
[ "$LIVE" = blue ] && OTHER=green || OTHER=blue
PORT=$([ "$OTHER" = blue ] && echo 8081 || echo 8082)

docker ps --format '{{.Names}}' | grep -qx "app-$OTHER" \
  || { echo "no previous release to roll back to - you must roll FORWARD (fix and redeploy)"; exit 1; }
V=$(curl -sf "http://127.0.0.1:$PORT/version" | grep -o '"version": "[0-9]*"' | grep -o '[0-9]*')
echo "rolling back: $LIVE -> $OTHER (v$V)"
"$ROOT/deploy/flip.sh" "$OTHER"
"$ROOT/deploy/smoke.sh" http://127.0.0.1:8080 "$V"
echo "OK rollback complete - v$V is live again"