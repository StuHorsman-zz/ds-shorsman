use movies;
select count(*)
from users
left outer join parental_controls
on (parental_controls.user_id = users.user_id)
where parental_controls.user_id is null;
