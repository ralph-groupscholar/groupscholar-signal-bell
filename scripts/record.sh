#!/usr/bin/env bash
set -euo pipefail

: "${DATABASE_URL:?DATABASE_URL is required}"

if [[ $# -lt 3 ]]; then
  echo "Usage: scripts/record.sh <severity> <category> <note> [source] [owner]"
  exit 1
fi

if [[ $# -ge 5 ]]; then
  sql=$(bin/signal-bell "$1" "$2" "$3" "$4" "$5")
elif [[ $# -ge 4 ]]; then
  sql=$(bin/signal-bell "$1" "$2" "$3" "$4")
else
  sql=$(bin/signal-bell "$1" "$2" "$3")
fi
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -c "$sql"
