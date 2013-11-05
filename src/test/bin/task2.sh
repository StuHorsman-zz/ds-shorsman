#!/bin/bash
echo "Running task2 workflow..."
echo "Creating session count data..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/count/session
hadoop jar ../lib/ds-shorsman.jar ds.shorsman.ExtractSessionCounts \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/weblog.log \
ds-shorsman/outgoing/count/session
