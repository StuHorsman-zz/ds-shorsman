use movies;
select session_id, action, movie_id, count(*)
from movie_actions 
group by session_id, action, movie_id;
