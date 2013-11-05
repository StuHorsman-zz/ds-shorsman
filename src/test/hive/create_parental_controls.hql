-- The create_parental_controls.hql script perform the following:
--   * creates PARENTAL_CONTROLS table over the movie JSON log file 
--   * inserts data into PARENTAL_CONTROLS

-- Create the moviework database
use movies;
drop table parental_controls;

-- Create table over source 
CREATE TABLE parental_controls (
  created_at TIMESTAMP,
  session_id STRING,
  user_id INT,
  old STRING,
  new STRING,
  user_type INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/outgoing/type/parental_controls/'
OVERWRITE INTO TABLE parental_controls;
