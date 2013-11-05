-- The create_user.hql script perform the following:
--   * creates HOME table over the movie JSON log file 
--   * inserts data into HOME

-- Create the moviework database
use movies;
drop table home;

-- Create table over source JSON   
CREATE TABLE home (
  created_at TIMESTAMP,
  session_id STRING,
  user_id INT,
  p1 STRING,
  p2 STRING,
  p3 STRING,
  p4 STRING,
  p5 STRING,
  r1 STRING,
  r2 STRING,
  r3 STRING,
  r4 STRING,
  r5 STRING,
  recent_item STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/incoming/type/home/'
OVERWRITE INTO TABLE home;
