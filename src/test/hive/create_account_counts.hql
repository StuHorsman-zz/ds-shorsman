-- The create_account_counts.hql script perform the following:
--   * creates SESSION table over the movie JSON log file 
--   * inserts data into SESSION

-- Create the moviework database
use movies;
drop table account_counts;

-- Create table over source JSON   
CREATE TABLE account_counts (
  session_id STRING,
  action STRING,
  count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE account_counts
SELECT session_id, action, count(*)
FROM account_actions
group by session_id, action;
