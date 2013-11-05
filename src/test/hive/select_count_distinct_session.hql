use movies;
select count(distinct session_id), user_id
from session
group by session_id;
