#!/bin/bash

# Copy data into incoming for job 05
echo "Setting up data directories for mapreduce 05..."
hadoop fs -rm -r -skipTrash ds-shorsman/outgoing/user/movie_counts
hadoop fs -rm -r -skipTrash ds-shorsman/incoming/user/movie_counts

# Run job05
echo "Running job mapreduce 05: Extracting movie_counts users..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-D stream.num.map.output.key.fields=1 \
-D stream.num.reduce.output.key.fields=2 \
-input ds-shorsman/incoming/weblog.log \
-output ds-shorsman/outgoing/user/movie_counts \
-mapper ../lib/map_extract_movie_counts.py \
-reducer ../lib/reduce_extract_movie_counts.py \
-file ../lib/map_extract_movie_counts.py \
-file ../lib/reduce_extract_movie_counts.py \
-numReduceTasks 1

echo "Moving results to ds-shorsman/incoming/user/movie_counts..."
hadoop fs -mkdir ds-shorsman/incoming/user/movie_counts
hadoop fs -mv ds-shorsman/outgoing/user/movie_counts/part-* ds-shorsman/incoming/user/movie_counts
