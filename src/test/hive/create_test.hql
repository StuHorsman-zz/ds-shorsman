-- The create_heck.hql script perform the following:
--   * creates database movies
--   * creates HECKLE_LOG table over the movie JSON log file 
--   * inserts data into staging table 

-- Add serde jar
ADD JAR /home/stuart/ds-shorsman/libjars/json-serde-1.1.6.jar;

-- Create the moviework database
drop table test;

-- Create table over source JSON   
CREATE TABLE test (
  first_name STRING,
  last_name STRING
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/home/stuart/ds-shorsman/data/test.csv'
OVERWRITE INTO TABLE test;
