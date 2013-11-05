-- The create_user.hql script perform the following:
--   * creates USER table over the movie JSON log file 
--   * inserts data into USER

-- Create the moviework database
use movies;
drop table users;

-- Create table over source JSON   
CREATE TABLE users (
  user_id INT,
  user_type INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/incoming/type/users/'
OVERWRITE INTO TABLE users;
