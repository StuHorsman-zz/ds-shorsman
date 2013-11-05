USE movies;
DROP TABLE session_data;
CREATE TABLE session_data (
 session_id STRING,
 action STRING,
 count INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE session_data
SELECT session_id, action, count(*)
FROM session
GROUP BY session_id, action;
