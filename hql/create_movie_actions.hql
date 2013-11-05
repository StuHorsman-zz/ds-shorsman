-- The create_movieactionss.hql script perform the following:
--   * creates MOVIE_ACTIONS table over the movie JSON log file 
--   * inserts data into MOVIE_ACTIONS

-- Create the moviework database
use movies;
drop table movie_actions;

-- Create table over source JSON   
CREATE TABLE movie_actions (
  user_id INT,
  created_at TIMESTAMP,
  action STRING,
  movie_id STRING,
  session_id STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/outgoing/type/movieactions/'
OVERWRITE INTO TABLE movie_actions;
