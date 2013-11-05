-- The create_moviecount.hql script perform the following:
--   * creates MOVIE_COUNT table over the movie JSON log file 
--   * inserts data into MOVIE_COUNT

-- Create the moviework database
use movies;
drop table movie_count_test;

-- Create table over source JSON   
CREATE TABLE movie_count_test (
  movie_id INT,
  count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE movie_count_test
SELECT * from movie_count
ORDER BY count DESC;
