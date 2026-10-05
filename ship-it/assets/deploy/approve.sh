#!/usr/bin/env bash
# The human gate of continuous delivery: promote the verified candidate.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE="$ROOT/.prod"
LIVE=$(cat "$STATE/live_color")
[ "$LIVE" = blue ] && IDLE=green || IDLE=blue
PORT=$([ "$IDLE" = blue ] && echo 8081 || echo 8082)

V=$(curl -sf "http://127.0.0.1:$PORT/version" | grep -o '"version": "[0-9]*"' | grep -o '[0-9]*') \
  || { echo "no verified candidate waiting on $IDLE - run the pipeline first"; exit 1; }
echo "human approval granted -> releasing v$V from $IDLE"
"$ROOT/deploy/flip.sh" "$IDLE"
"$ROOT/deploy/smoke.sh" http://127.0.0.1:8080 "$V"
echo "OK v$V is LIVE"