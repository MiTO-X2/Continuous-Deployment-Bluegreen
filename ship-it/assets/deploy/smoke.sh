#!/usr/bin/env bash
# smoke.sh BASE_URL EXPECTED_VERSION — the pipeline's telemetry gate.
set -u
URL="$1"; WANT="$2"
for i in $(seq 1 15); do
  H=$(curl -sf --max-time 2 "$URL/health") && \
  V=$(curl -sf --max-time 2 "$URL/version" | grep -o '"version": "[0-9]*"' | grep -o '[0-9]*')
  if [ "${V:-}" = "$WANT" ] && echo "$H" | grep -q '"ok"'; then
    echo "smoke OK: $URL serves healthy v$WANT"
    exit 0
  fi
  sleep 1
done
echo "SMOKE FAILED: $URL never served a healthy v$WANT" >&2
exit 1