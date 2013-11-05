use movies;
select * from account_actions
where unix_timestamp(created_at) >= unix_timestamp('2013-06-03 06:00:00')
