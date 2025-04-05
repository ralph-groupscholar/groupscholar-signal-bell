# GroupScholar Signal Bell

Group Scholar ops signal logger that produces safe SQL insert statements from a tiny AArch64 assembly CLI. It is built for lightweight, repeatable logging of urgent signals into the production Postgres database.

## Features

- AArch64 assembly CLI that generates a ready-to-run SQL insert statement.
- Guardrails against single-quote inputs that would break SQL.
- Production database schema and seed data included.
- Simple record script that pipes the CLI output into `psql`.
- Optional `source` and `owner` tags for tracking origin and accountability.
- Daily summary view for quick signal rollups.

## Tech

- Assembly (AArch64, macOS)
- PostgreSQL (schema + seed scripts)
- Bash scripts for DB setup and recording

## Getting Started

Build the CLI:

```bash
make build
```

Generate SQL:

```bash
bin/signal-bell high ops "Mentor response lagging"

# with optional source tag
bin/signal-bell high ops "Mentor response lagging" pager

# with optional source + owner tags
bin/signal-bell high ops "Mentor response lagging" pager ops-lead
```

Record into production database:

```bash
export DATABASE_URL="postgres://USER:PASSWORD@HOST:PORT/postgres"
make build
scripts/record.sh high ops "Mentor response lagging"

# with optional source tag
scripts/record.sh high ops "Mentor response lagging" pager

# with optional source + owner tags
scripts/record.sh high ops "Mentor response lagging" pager ops-lead
```

Initialize schema + seed data in production:

```bash
export DATABASE_URL="postgres://USER:PASSWORD@HOST:PORT/postgres"
scripts/db_init.sh
```

Query the daily summary view:

```sql
select * from groupscholar_signal_bell.signal_summary_daily limit 10;
```

## Notes

- Inputs must not contain single quotes. Replace them with double quotes or remove them.
- Source defaults to `manual` when omitted.
- Owner defaults to `unassigned` when omitted.
- The production database credentials must be provided via `DATABASE_URL`.

## Testing

```bash
scripts/test.sh
```
