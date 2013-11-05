-- The create_accountactions.hql script perform the following:
--   * creates ACCOUNT_ACTIONS table over the movie JSON log file 
--   * inserts data into ACCOUNT_ACTIONS

-- Create the moviework database
use movies;
drop table account_actions;

-- Create table over source JSON   
CREATE TABLE account_actions (
  user_id INT,
  created_at TIMESTAMP,
  action STRING,
  session_id STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/incoming/type/account_actions/'
OVERWRITE INTO TABLE account_actions;
