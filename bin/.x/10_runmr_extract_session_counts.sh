#!/bin/bash

# Copy data into incoming for job 00
echo "Setting up data directories for mapreduce..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/count/session

# Run ExtractPlay job to dump all user play data
echo "Running job mapreduce 00: Creating updated weblog.log..."
hadoop jar ../lib/ExtractSessionCounts.jar ds.shorsman.test.ExtractSessionCounts \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/outgoing/type/session \
ds-shorsman/outgoing/count/session
