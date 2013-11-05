USE movies;
SELECT a.user_id, a.user_type, 
       b.p1, b.p2, b.p3, b.p4, b.p5, 
       b.r1, b.r2, b.r3, b.r4, b.r5, 
       b.recent_item
FROM test_users a JOIN home b ON a.user_id = b.user_id;

