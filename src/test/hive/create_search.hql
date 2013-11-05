-- The create_search.hql script perform the following:
--   * creates SEARCH table over the movie JSON log file 
--   * inserts data into SEARCH

-- Create the moviework database
use movies;
drop table search;

-- Create table over source JSON   
CREATE TABLE search (
  created_at TIMESTAMP,
  session_id STRING,
  user_id INT,
  V1 STRING,
  V2 STRING,
  V3 STRING,
  V4 STRING,
  V5 STRING,
  V6 STRING,
  V7 STRING,
  V8 STRING,
  V9 STRING,
  V10 STRING,
  V11 STRING,
  V12 STRING,
  V13 STRING,
  V14 STRING,
  V15 STRING,
  V16 STRING,
  V17 STRING,
  V18 STRING,
  V19 STRING,
  V20 STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/incoming/type/search/'
OVERWRITE INTO TABLE search;
