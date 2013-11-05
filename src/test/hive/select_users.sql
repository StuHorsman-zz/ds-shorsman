use movies;
select all.user_id, all.user_type
from (
  select users.user_id, users.user_type
  from users
  left outer join parental_controls
  on (parental_controls.user_id = users.user_id)
  where parental_controls.user_id is null
union all
  select parental_controls.user_id, "1" as parental_controls.user_type
  from parental_controls
) all;

SELECT all.user_id, all.user_type
  FROM (
    SELECT l1.ymd, l1.level,
      l1.message, 'Log1' AS source
    FROM all1 l1
  UNION ALL
    SELECT l2.ymd, l2.level,
      l2.message, 'Log2' AS source
    FROM all1 l2
  ) all
SORT BY all.ymd ASC;
