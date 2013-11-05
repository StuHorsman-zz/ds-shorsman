use movies;
select s.user_id, s.created_at, s.action, p.movie_id, s.session_id
from session s join play p on s.user_id = p.user_id
and s.session_id = p.session_id
and s.created_at = p.created_at;

