#!/usr/bin/env bash
# Simulates a developer committing a change.
# Usage: ./new_change.sh VERSION [--broken] [--beta]
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"
V="${1:?usage: new_change.sh VERSION [--broken] [--beta]}"; shift || true
echo "$V" > app/VERSION
rm -f app/BROKEN app/BETA_ON
for a in "$@"; do
  case "$a" in
    (--broken) touch app/BROKEN ;;   # bad production config, invisible to unit tests
    (--beta)   touch app/BETA_ON ;;  # enable the beta feature flag
  esac
done
git add -A
git commit -qm "release v$V $*"
echo "committed: $(git log --oneline -1)"