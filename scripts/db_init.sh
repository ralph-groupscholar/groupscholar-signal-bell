#!/usr/bin/env bash
set -euo pipefail

: "${DATABASE_URL:?DATABASE_URL is required}"

psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f db/schema.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f db/seed.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f db/views.sql
