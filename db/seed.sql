insert into groupscholar_signal_bell.signals (severity, category, note, source, owner, created_at) values
  ('high', 'ops', 'Mentor availability drop detected for coastal cohort', 'pager', 'ops-lead', now() - interval '6 days'),
  ('medium', 'program', 'Scholar response cadence slowed after midterm week', 'manual', 'program-director', now() - interval '4 days'),
  ('low', 'data', 'Weekly roster sync succeeded with 2 minor warnings', 'pipeline', 'data-ops', now() - interval '3 days'),
  ('high', 'partner', 'Partner renewal risk flagged for STEM bridge program', 'review', 'partnerships', now() - interval '2 days'),
  ('medium', 'engagement', 'Office hours attendance spiked following reminder push', 'ops', 'student-success', now() - interval '1 day');
