use movies;
select s.*, t.session_time
from session_counts s join session_times t on s.session_id = t.session_id;
