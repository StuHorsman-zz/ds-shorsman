USE movies;
DROP TABLE task1_user_data;
CREATE TABLE task1_user_data (
 user_id STRING,
 movie_id STRING,
 count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t,';
INSERT INTO TABLE task1_user_data
SELECT user_id, movie_id, count(*)
FROM play
GROUP BY user_id, movie_id;
