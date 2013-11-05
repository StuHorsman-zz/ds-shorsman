#!/bin/bash

# Copy data into incoming for job 05
echo "Setting up data directories for mapreduce 05..."
hadoop fs -rm -r -skipTrash ds-shorsman/outgoing/count/movies
hadoop fs -rm -r -skipTrash ds-shorsman/incoming/count/movies

# Run job05
echo "Running job mapreduce 05: Counting movies..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-D stream.num.map.output.key.fields=1 \
-D stream.num.reduce.output.key.fields=1 \
-input ds-shorsman/incoming/weblog.log \
-output ds-shorsman/outgoing/count/movies \
-mapper ../lib/map_count_movies.py \
-reducer ../lib/reduce_count_movies.py \
-file ../lib/map_count_movies.py \
-file ../lib/reduce_count_movies.py \
-numReduceTasks 4

echo "Moving results to incoming for hive processing..."
hadoop fs -mkdir ds-shorsman/incoming/count/movies
hadoop fs -mv ds-shorsman/outgoing/count/movies/part-* ds-shorsman/incoming/count/movies

