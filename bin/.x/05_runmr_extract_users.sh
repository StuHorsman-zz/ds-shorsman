#!/bin/bash

# Copy data into incoming for job 05
echo "Setting up data directories for mapreduce 05..."
hadoop fs -rm -r -skipTrash ds-shorsman/outgoing/type/users
hadoop fs -rm -r -skipTrash ds-shorsman/incoming/type/users

# Run job05
echo "Running job mapreduce 05: Extracting users types..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-D stream.num.map.output.key.fields=1 \
-D stream.num.reduce.output.key.fields=1 \
-input ds-shorsman/incoming/weblog.log \
-output ds-shorsman/outgoing/type/users \
-mapper ../lib/map_extract_users.py \
-reducer ../lib/reduce_users.py \
-file ../lib/map_extract_users.py \
-file ../lib/reduce_users.py \
-numReduceTasks 1

echo "Moving results to incoming for hive processing..."
hadoop fs -mkdir ds-shorsman/incoming/type/users
hadoop fs -mv ds-shorsman/outgoing/type/users/part-* ds-shorsman/incoming/type/users
