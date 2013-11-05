-- The create_accountactions.hql script perform the following:
--   * creates PARENTAL_CONTROLS table over the movie JSON log file 
--   * inserts data into PARENTAL_CONTROLS

-- Create the moviework database
use movies;
drop table payment_info;

-- Create table over source JSON   
CREATE TABLE payment_info (
  created_at TIMESTAMP,
  session_id STRING,
  user_id INT,
  user_type INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/incoming/type/payment_info/'
OVERWRITE INTO TABLE payment_info;
