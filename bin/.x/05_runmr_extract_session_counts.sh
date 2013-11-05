#!/bin/bash

# Copy data into incoming for job 05
echo "Setting up data directories for mapreduce 05..."
hadoop fs -rm -r -skipTrash ds-shorsman/outgoing/type/session_counts
hadoop fs -rm -r -skipTrash ds-shorsman/incoming/type/session_counts

# Run job05
echo "Running job mapreduce 05: Extracting session_counts types..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-D stream.num.map.output.key.fields=1 \
-D stream.num.reduce.output.key.fields=1 \
-input ds-shorsman/incoming/weblog.log \
-output ds-shorsman/outgoing/type/session_counts \
-mapper ../lib/map_extract_session_counts.py \
-reducer ../lib/reduce_extract_session_counts.py \
-file ../lib/map_extract_session_counts.py \
-file ../lib/reduce_extract_session_counts.py \
-numReduceTasks 1

echo "Moving results to incoming for hive processing..."
hadoop fs -mkdir ds-shorsman/incoming/type/session_counts
hadoop fs -mv ds-shorsman/outgoing/type/session_counts/part-* ds-shorsman/incoming/type/session_counts
