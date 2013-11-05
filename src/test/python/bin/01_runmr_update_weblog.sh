#!/bin/bash

# Copy data into incoming for job 01
echo "Setting up data directories for mapreduce 00..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/00-update-weblog
hadoop fs -rm -r -f -skipTrash ds-shorsman/incoming/00-raw-weblog


# Run job01
echo "Running job mapreduce 00: Creating updated weblog.log..."
hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.3.0.jar \
-input ds-shorsman/incoming/heckle \
-input ds-shorsman/incoming/jeckle \
-output ds-shorsman/outgoing/00-update-weblog \
-mapper ../lib/map_update_weblog.py \
-reducer ../lib/reduce_update_weblog.py \
-file ../lib/map_update_weblog.py \
-file ../lib/reduce_update_weblog.py \
-numReduceTasks 1

# Move our new formatted file to the incoming folder.  This new file will be
# used for input to all future MR jobs
echo "Moving output data to incoming folder..."
hadoop fs -mkdir ds-shorsman/incoming/00-raw-weblog
hadoop fs -mv ds-shorsman/incoming/weblog.log ds-shorsman/incoming/00-raw-weblog
hadoop fs -mv ds-shorsman/outgoing/00-update-weblog/part-00000 ds-shorsman/incoming/weblog.log
