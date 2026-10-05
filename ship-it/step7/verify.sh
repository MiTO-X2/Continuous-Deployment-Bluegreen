#!/usr/bin/env bash

# Users are back on v3.
curl -sf http://127.0.0.1:8080/version \
  | grep -q '"version": "3"' || exit 1

# Traffic is routed to BLUE.
grep -qx blue ~/tutorial/.prod/live_color || exit 1

# The previous v5 environment is still available for inspection/rollback semantics.
docker ps --format '{{.Names}}' | grep -qx app-green || exit 1

# The rolled-back version is no longer exposing the beta feature.
if curl -sf http://127.0.0.1:8080/beta >/dev/null 2>&1; then
    exit 1
fi

exit 0