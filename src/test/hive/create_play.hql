-- The create_play.hql script perform the following:
--   * creates PLAY table over the movie JSON log file 
--   * inserts data into PLAY

-- Create the moviework database
use movies;
drop table play;

-- Create table over source JSON   
CREATE TABLE play (
  user_id INT,
  session_id STRING,
  created_at TIMESTAMP,
  action STRING,
  movie_id STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/outgoing/type/play/'
OVERWRITE INTO TABLE play;
