#!/bin/bash

# Copy data into incoming for job 00
echo "Setting up data directories for mapreduce..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/type/play_tv

# Run ExtractPlay job to dump all user play data
echo "Running job mapreduce 00: Creating updated weblog.log..."
hadoop jar ../lib/CreatePlayTV.jar ds.shorsman.CreatePlayTV \
-libjars ../libjars/json-simple-1.1.1.jar \
ds-shorsman/incoming/weblog.log \
ds-shorsman/outgoing/type/play_tv
