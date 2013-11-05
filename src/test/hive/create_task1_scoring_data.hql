USE movies;
DROP TABLE task1_scoring_data;
CREATE TABLE task1_scoring_data (
 user_id INT,
 movie_id STRING,
 count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
INSERT INTO TABLE task1_scoring_data
SELECT user_id, movie_id, count(*)
FROM play
GROUP BY user_id, movie_id;
