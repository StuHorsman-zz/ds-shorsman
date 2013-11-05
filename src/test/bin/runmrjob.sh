hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-input /user/stuart/ds-shorsman/incoming/heckle/* \
-output /user/stuart/ds-shorsman/outgoing/heckle \
-mapper mapper.py \
-reducer reducer.py \
-file mapper.py \
-file reducer.py
