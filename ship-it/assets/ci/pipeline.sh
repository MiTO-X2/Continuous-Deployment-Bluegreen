#!/usr/bin/env bash
# pipeline.sh — a miniature CI/CD server.
# Usage: ./ci/pipeline.sh [--ci-only]     APPROVAL=auto|manual (default: auto)
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
V=$(cat app/VERSION)
C=$(git rev-parse --short HEAD)

echo "=== [1/4] CHECKOUT  | change $C on main -> release candidate v$V"
echo "=== [2/4] TEST      | running automated unit tests"
if ! python3 -m unittest discover -s app/tests >/tmp/test.log 2>&1; then
  cat /tmp/test.log
  echo "X  TESTS FAILED - pipeline stops here; nothing was built or deployed"
  exit 1
fi
grep -E "Ran [0-9]+ test|OK" /tmp/test.log || true
echo "   tests passed"

echo "=== [3/4] BUILD     | packaging immutable artifact: docker image app:$V"
docker build -q -t "app:$V" app >/dev/null
echo "   image app:$V registered"

if [ "${1:-}" = "--ci-only" ]; then
  echo "=== CI COMPLETE     | app:$V tested and built (continuous integration only)"
  exit 0
fi

echo "=== [4/4] DEPLOY    | blue-green release of app:$V (APPROVAL=${APPROVAL:-auto})"
APPROVAL="${APPROVAL:-auto}" "$ROOT/deploy/deploy.sh" "$V"