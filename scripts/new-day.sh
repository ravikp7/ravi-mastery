#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="${REPO_ROOT}/day-updates/_template.md"
START_DATE="2026-07-07"

# Allow TODAY override for testing: TODAY_ISO="${TODAY:-$(date +%Y-%m-%d)}"
TODAY_ISO="${TODAY:-$(date +%Y-%m-%d)}"
TARGET="${REPO_ROOT}/day-updates/${TODAY_ISO}.md"

if [[ -f "$TARGET" ]]; then
  echo "Today's file already exists: $TARGET"
  exit 0
fi

# Compute day number (workdays since start).
DAY_NUMBER=$(python3 -c "
from datetime import date, timedelta
import os
start = date.fromisoformat('${START_DATE}')
today = date.fromisoformat(os.environ.get('TODAY', date.today().isoformat()))
days = 0
d = start
while d <= today:
    if d.weekday() < 5:
        days += 1
    d += timedelta(days=1)
print(days)
")

# Naive phase/week mapping (Ravi can refine): 5 workdays per week.
WEEK=$(( (DAY_NUMBER + 4) / 5 ))
if   [[ $WEEK -le 1  ]]; then PHASE=0
elif [[ $WEEK -le 5  ]]; then PHASE=1
elif [[ $WEEK -le 12 ]]; then PHASE=2
elif [[ $WEEK -le 19 ]]; then PHASE=3
elif [[ $WEEK -le 25 ]]; then PHASE=4
elif [[ $WEEK -le 32 ]]; then PHASE=5
else                          PHASE=6
fi

sed \
  -e "s/{{DATE}}/${TODAY_ISO}/" \
  -e "s/{{DAY_NUMBER}}/${DAY_NUMBER}/" \
  -e "s/{{PHASE}}/${PHASE}/" \
  -e "s/{{WEEK}}/${WEEK}/" \
  "$TEMPLATE" > "$TARGET"

echo "Created: $TARGET"
