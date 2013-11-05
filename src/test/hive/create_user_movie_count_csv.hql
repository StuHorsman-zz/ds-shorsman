-- The create_moviecount.hql script perform the following:
--   * creates MOVIE_COUNT table over the movie JSON log file 
--   * inserts data into MOVIE_COUNT

-- Create the moviework database
use movies;
drop table user_movie_count_csv;

-- Create table over source JSON   
CREATE TABLE user_movie_count_csv (
  user_id INT,
  movie_id STRING,
  count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE user_movie_count_csv
SELECT * from user_movie_counts
ORDER BY user_id, movie_id, count;
