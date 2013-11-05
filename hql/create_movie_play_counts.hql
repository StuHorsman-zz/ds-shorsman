USE movies;
DROP TABLE movie_play_counts;
CREATE TABLE movie_play_counts (
 movie_id STRING,
 count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE movie_play_counts
SELECT movie_id, count(*) as count
from play_tv
group by movie_id
order by count desc;
