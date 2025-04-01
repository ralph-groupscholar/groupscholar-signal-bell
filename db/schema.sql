create schema if not exists groupscholar_signal_bell;

create table if not exists groupscholar_signal_bell.signals (
  id bigserial primary key,
  severity text not null,
  category text not null,
  note text not null,
  source text not null default 'manual',
  owner text not null default 'unassigned',
  created_at timestamptz not null default now()
);

alter table groupscholar_signal_bell.signals
  add column if not exists source text not null default 'manual';

alter table groupscholar_signal_bell.signals
  add column if not exists owner text not null default 'unassigned';
