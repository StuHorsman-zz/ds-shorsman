#!/bin/bash

# Copy data into incoming for job 02
echo "Setting up data directories for mapreduce 02..."
hadoop fs -rm -r -skipTrash ds-shorsman/outgoing/02-check-json

# Run job02
echo "Running job mapreduce 02: Checking JSON log format..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-input ds-shorsman/incoming/weblog.log \
-output ds-shorsman/outgoing/02-check-json \
-mapper ../lib/map_check_json.py \
-reducer ../lib/reduce_check_json.py \
-file ../lib/map_check_json.py \
-file ../lib/reduce_check_json.py
