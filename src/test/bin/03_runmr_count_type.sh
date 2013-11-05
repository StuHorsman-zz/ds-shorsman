#!/bin/bash

# Copy data into incoming for job 03
echo "Setting up data directories for mapreduce 03..."
hadoop fs -rm -r -skipTrash ds-shorsman/outgoing/03-count-type

# Run job02
echo "Running job mapreduce 03: Counting JSON log types..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-input ds-shorsman/incoming/weblog.log \
-output ds-shorsman/outgoing/03-count-type \
-mapper ../lib/map_count_type.py \
-reducer ../lib/reduce_count_type.py \
-file ../lib/map_count_type.py \
-file ../lib/reduce_count_type.py \
-numReduceTasks 1
