REGISTER /home/oracle/movie/lib_3rdparty/simple_json_loader.jar; 

REGISTER 'sessionize.py' USING jython AS sessionize; 

rmf /user/oracle/moviework/session;

applogs = LOAD '/user/oracle/moviework/applog' USING com.oracle.pig.storage.SimpleJsonLoader('custId', 'movieId', 'genreId','time','recommended','activity', 'rating') AS (custId:int, movieId:chararray, genreId:chararray, time:chararray, recommended:chararray, activity:chararray,rating:chararray);


translated_time = FOREACH applogs GENERATE sessionize.to_unix_timestamp(time), *;

-- <-- TO DO:   Group by customer ID -->;

sessions = FOREACH views GENERATE translated_time.custId, sessionize.accumulate(20,translated_time);

result = foreach sessions generate flatten($1);

<-- TO DO:  STORE SESSIONIZED INFO INTO /user/oracle/moviework/session -->;
