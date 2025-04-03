#!/usr/bin/env bash
set -euo pipefail

make build

expected="insert into groupscholar_signal_bell.signals (severity, category, note, source, owner, created_at) values ('high','ops','System check complete','manual','unassigned', now());"
output=$(bin/signal-bell high ops "System check complete")

if [[ "$output" != "$expected" ]]; then
  echo "Unexpected output: $output"
  exit 1
fi

expected_custom="insert into groupscholar_signal_bell.signals (severity, category, note, source, owner, created_at) values ('high','ops','System check complete','pager','unassigned', now());"
output_custom=$(bin/signal-bell high ops "System check complete" pager)

if [[ "$output_custom" != "$expected_custom" ]]; then
  echo "Unexpected output: $output_custom"
  exit 1
fi

expected_owner="insert into groupscholar_signal_bell.signals (severity, category, note, source, owner, created_at) values ('high','ops','System check complete','pager','ops-lead', now());"
output_owner=$(bin/signal-bell high ops "System check complete" pager ops-lead)

if [[ "$output_owner" != "$expected_owner" ]]; then
  echo "Unexpected output: $output_owner"
  exit 1
fi

echo "OK"
