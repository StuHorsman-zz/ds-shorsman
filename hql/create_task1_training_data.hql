USE movies;
DROP TABLE task1_training_data;
CREATE TABLE task1_training_data (
 user_id STRING,
 movie_id STRING,
 count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE task1_training_data
SELECT *
  FROM (
    SELECT concat("K", k.user_id), k.movie_id, k.count
    FROM kid_play_data k
  UNION ALL
    SELECT concat("A", a.user_id), a.movie_id, a.count
    FROM adult_play_data a
  ) FINAL;
