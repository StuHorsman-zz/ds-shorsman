#!/bin/bash

# Copy data into incoming for job 00
echo "Setting up data directories for mapreduce..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/type/session

# Run ExtractPlay job to dump all user play data
echo "Running job mapreduce 00: Creating updated weblog.log..."
hadoop jar ../lib/CreateSession.jar ds.shorsman.test.CreateSession \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/weblog.log \
ds-shorsman/outgoing/type/session
