#!/usr/bin/env bash

curl -sf http://127.0.0.1:5000/health \
  | grep -q '"status": "ok"' || exit 1

curl -sf http://127.0.0.1:5000/version \
  | grep -q '"version":' || exit 1

exit 0