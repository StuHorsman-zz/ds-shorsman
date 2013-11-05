use movies;
select count(*) from parental_controls t1
join (
  select user_id, max(created_at) max_created_at
  from parental_controls
  group by user_id) s1
on t1.user_id = s1.user_id and t1.created_at = s1.max_created_at;
