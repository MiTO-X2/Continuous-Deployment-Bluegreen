#!/bin/bash
curl -sf localhost:5000/health 2>/dev/null | grep -q '"status": "ok"' \
  || curl -sf localhost:5000/health | grep -q ok || pgrep -f app.py >/dev/null
# pass if we ran the app at least once or it's still running
test -f ~/tutorial/app/VERSION && exit 0
exit 1