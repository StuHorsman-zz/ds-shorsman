-- The create_session.hql script perform the following:
--   * creates SESSION table over the movie JSON log file 
--   * inserts data into SESSION

-- Create the moviework database
use movies;
drop table session;

-- Create table over source JSON   
CREATE TABLE session (
  session_id STRING,
  user_id INT,
  created_at TIMESTAMP,
  action STRING,
  movie_id STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/outgoing/session/part-*'
OVERWRITE INTO TABLE session;
