use movies;
select p.user_id, p.created_at, p.movie_id
from play p join payment_info i on p.user_id = i.user_id
where p.movie_id = '10375';
--where p.movie_id in ('10375','11108','19550','25276','26355','27370','30887','33898','38725');
