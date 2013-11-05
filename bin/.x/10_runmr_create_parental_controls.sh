#!/bin/bash

# Copy data into incoming for job 00
echo "Setting up data directories for mapreduce..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/type/parental_controls

# Run ExtractPlay job to dump all user play data
hadoop jar ../lib/CreateParentalControls.jar \
ds.shorsman.CreateParentalControls \
-libjars ../libjars/json-simple-1.1.1.jar \
ds-shorsman/incoming/weblog.log \
ds-shorsman/outgoing/type/parental_controls
