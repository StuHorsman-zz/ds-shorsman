#!/bin/bash

# Copy data into incoming for job 05
echo "Setting up data directories for mapreduce 05..."
hadoop fs -rm -r -skipTrash ds-shorsman/outgoing/type/writereview

# Run job05
echo "Running job mapreduce 05: Extracting writereview types..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-D stream.num.map.output.key.fields=3 \
-D stream.num.reduce.output.key.fields=3 \
-input ds-shorsman/incoming/weblog.log \
-output ds-shorsman/outgoing/type/writereview \
-mapper ../lib/map_extract_writereview.py \
-reducer ../lib/reduce_type.py \
-file ../lib/map_extract_writereview.py \
-file ../lib/reduce_type.py \
-numReduceTasks 1
