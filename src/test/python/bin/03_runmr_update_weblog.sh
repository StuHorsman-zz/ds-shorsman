#!/bin/bash

# Copy data into incoming for job 00
echo "Setting up data directories for mapreduce 00..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/00-update-weblog

# Run job01
echo "Running job mapreduce 00: Creating updated weblog.log..."
hadoop jar ../lib/ds-shorsman.jar ds.shorsman.UpdateWeblog \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/heckle \
ds-shorsman/incoming/jeckle \
ds-shorsman/outgoing/00-update-weblog

# Move our new formatted file to the incoming folder.  This new file will be
# used for input to all future MR jobs
#echo "Moving output data to ds-shorsman/incoming/weblog.log..."
#hadoop fs -mv ds-shorsman/outgoing/00-update-weblog/part-00000 ds-shorsman/incoming/weblog.log
