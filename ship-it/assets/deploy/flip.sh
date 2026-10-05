#!/usr/bin/env bash
# Repoints the proxy at a color and reloads nginx. This file is the production change.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE="$ROOT/.prod"
TARGET="${1:?usage: flip.sh blue|green}"

sed "s/__COLOR__/$TARGET/" "$ROOT/deploy/nginx.server.template" > "$STATE/conf.d/server.conf"
docker exec proxy nginx -s reload
sleep 1
curl -sf http://127.0.0.1:8080/health >/dev/null
echo "$TARGET" > "$STATE/live_color"
echo "traffic flipped -> $TARGET"