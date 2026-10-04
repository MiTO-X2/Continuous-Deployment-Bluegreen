#!/usr/bin/env bash
# Creates production from scratch: network, blue env (v1), proxy on :8080.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE="$ROOT/.prod"
mkdir -p "$STATE/conf.d"

docker network create cdnet 2>/dev/null || true
docker rm -f app-blue app-green proxy 2>/dev/null || true

echo "starting BLUE environment with v1 ..."
docker run -d --name app-blue --network cdnet -p 8081:5000 -e COLOR=blue app:1 >/dev/null

sed "s/__COLOR__/blue/" "$ROOT/deploy/nginx.server.template" > "$STATE/conf.d/server.conf"
echo "starting reverse proxy on :8080 ..."
docker run -d --name proxy --network cdnet -p 8080:80 \
  -v "$STATE/conf.d":/etc/nginx/conf.d:ro nginx:alpine >/dev/null

echo blue > "$STATE/live_color"
sleep 1
"$ROOT/deploy/smoke.sh" http://127.0.0.1:8081 1
"$ROOT/deploy/smoke.sh" http://127.0.0.1:8080 1
echo "production is up: v1 live on BLUE"