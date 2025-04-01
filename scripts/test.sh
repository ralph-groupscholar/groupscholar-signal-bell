#!/usr/bin/env bash
set -euo pipefail

make build

expected="insert into groupscholar_signal_bell.signals (severity, category, note, created_at) values ('high','ops','System check complete', now());"
output=$(bin/signal-bell high ops "System check complete")

if [[ "$output" != "$expected" ]]; then
  echo "Unexpected output: $output"
  exit 1
fi

echo "OK"
