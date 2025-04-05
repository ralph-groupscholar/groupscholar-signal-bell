create or replace view groupscholar_signal_bell.signal_summary_daily as
select
  date_trunc('day', created_at) as day,
  severity,
  category,
  source,
  owner,
  count(*) as signal_count
from groupscholar_signal_bell.signals
group by 1, 2, 3, 4, 5
order by day desc, signal_count desc;
