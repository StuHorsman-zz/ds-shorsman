#!/bin/bash

# Copy data into incoming for job 05
echo "Setting up data directories for mapreduce 05..."
hadoop fs -rm -r -skipTrash ds-shorsman/outgoing/type/movieactions
hadoop fs -rm -r -skipTrash ds-shorsman/incoming/type/movieactions

# Run job05
echo "Running job mapreduce 05: Extracting movieactions types..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-input ds-shorsman/incoming/weblog.log \
-output ds-shorsman/outgoing/type/movieactions \
-mapper ../lib/map_extract_movieactions.py \
-reducer ../lib/reduce_extract_movieactions.py \
-file ../lib/map_extract_movieactions.py \
-file ../lib/reduce_extract_movieactions.py \
-numReduceTasks 1

echo "Moving results to incoming for hive processing..."
#hadoop fs -mkdir ds-shorsman/incoming/type/movieactions
#hadoop fs -mv ds-shorsman/outgoing/type/movieactions/part-* ds-shorsman/incoming/type/movieactions
