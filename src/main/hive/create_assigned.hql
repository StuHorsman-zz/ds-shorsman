-- The create_task1_output.hql script perform the following:
--   * creates TASK2_OUTPUT table over the movie JSON log file 
--   * inserts data into TASK2_OUTPUT

-- Create the moviework database
use movies;
drop table assigned;

-- Create table over source JSON   
CREATE TABLE assigned (
  session_id STRING,
  cluster_id INT,
  assigned_id INT,
  distance DOUBLE
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
LOAD DATA INPATH 'ds-shorsman/outgoing/task2/assigned/*'
OVERWRITE INTO TABLE assigned;
