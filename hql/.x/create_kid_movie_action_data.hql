USE movies;
DROP TABLE kid_movie_action_data;
CREATE TABLE kid_movie_action_data (
 user_id INT,
 movie_id STRING,
 count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE kid_movie_action_data
SELECT p.user_id, p.movie_id, count(*)
FROM movie_actions p JOIN parental_controls c on p.user_id = c.user_id
WHERE unix_timestamp(p.created_at) > unix_timestamp(c.created_at)
GROUP BY p.user_id, p.movie_id; 
