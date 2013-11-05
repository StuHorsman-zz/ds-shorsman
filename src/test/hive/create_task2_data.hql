USE movies;
DROP TABLE task2_data;
CREATE TABLE task2_data (
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
 wri INT,
 duration INT,
 session_id STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

INSERT INTO TABLE task2_data
SELECT s.acc, s.addto, s.adv, s.home, s.hov, s.item, s.login, s.logout, s.pause, s.play, s.pos, s.que, s.rate, s.rec, s.res, s.search, s.stop, s.ver, s.wri, t.session_time, t.session_id
FROM session_counts s JOIN session_times t on s.session_id = t.session_id;
