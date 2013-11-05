-- The create_user_movie_counts.hql script perform the following:
--   * creates MOVIE_COUNT table over the movie JSON log file 
--   * inserts data into MOVIE_COUNT

-- Create the moviework database
use movies;
drop table user_movie_counts;

-- Create table over source JSON   
CREATE TABLE user_movie_counts (
  user_id INT,
  movie_id STRING,
  count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/incoming/user/movie_counts/'
OVERWRITE INTO TABLE user_movie_counts;
