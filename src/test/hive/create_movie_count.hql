-- The create_moviecount.hql script perform the following:
--   * creates MOVIE_COUNT table over the movie JSON log file 
--   * inserts data into MOVIE_COUNT

-- Create the moviework database
use movies;
drop table movie_count;

-- Create table over source JSON   
CREATE TABLE movie_count (
  movie_id STRING,
  count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/incoming/count/movies/'
OVERWRITE INTO TABLE movie_count;
