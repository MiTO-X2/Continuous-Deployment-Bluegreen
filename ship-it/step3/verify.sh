#!/usr/bin/env bash

curl -sf http://127.0.0.1:8080/version \
  | grep -q '"version": "1"' || exit 1

curl -sf http://127.0.0.1:8080/version \
  | grep -q '"color": "blue"' || exit 1

exit 0