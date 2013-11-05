-- The create_session_duration.hql script perform the following:
--   * creates SESSION_DURATION table over the movie JSON log file 
--   * inserts data into SESSION_DURATION

-- Create the moviework database
use movies;
drop table session_duration;

-- Create table over source JSON   
CREATE TABLE session_duration (
  session_id STRING,
  user_id INT,
  created_at TIMESTAMP,
  action STRING,
  movie_id STRING,
  duration INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/outgoing/session_duration/part-*'
OVERWRITE INTO TABLE session_duration;
