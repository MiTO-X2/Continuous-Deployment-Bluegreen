#!/usr/bin/env bash

docker image inspect app:2 >/dev/null 2>&1 || exit 1

docker run --rm app:2 \
  python3 -c 'from pathlib import Path; assert Path("VERSION").read_text().strip() == "2"' \
  || exit 1

exit 0