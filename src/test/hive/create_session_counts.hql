USE movies;
DROP TABLE session_counts;
CREATE TABLE session_counts (
 session_id STRING,
 acc INT,
 addto INT,
 adv INT,
 home INT,
 hov INT,
 item INT,
 login INT,
 logout INT,
 pause INT,
 play INT,
 pos INT,
 que INT,
 rate INT,
 rec INT,
 res INT,
 search INT,
 stop INT,
 ver INT,
 wri INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
LOAD DATA INPATH 'ds-shorsman/incoming/type/session_counts/'
OVERWRITE INTO TABLE session_counts;
