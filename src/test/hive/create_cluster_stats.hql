use movies;
DROP TABLE cluster_stats;
CREATE TABLE cluster_stats (
 session_id STRING,
 cluster_id INT,
 center_id INT,
 distance DECIMAL
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
LOAD DATA INPATH 'assigned/'
OVERWRITE INTO TABLE cluster_stats;

