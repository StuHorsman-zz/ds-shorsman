-- The create_moviecount.hql script perform the following:
--   * creates MOVIE_COUNT table over the movie JSON log file 
--   * inserts data into MOVIE_COUNT

-- Create the moviework database
use movies;
drop table adult_users;

-- Create table over source JSON   
CREATE TABLE adult_users (
  user_id INT,
  user_type INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE adult_users
SELECT DISTINCT(user_id), user_type
FROM payment_info
ORDER BY user_id;
