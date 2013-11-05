USE movies;
DROP TABLE session_times;
CREATE TABLE session_times (
 session_id STRING,
 session_time INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE session_times
SELECT session_id, max(unix_timestamp(created_at)) - min(unix_timestamp(created_at))
FROM session
GROUP BY session_id;
