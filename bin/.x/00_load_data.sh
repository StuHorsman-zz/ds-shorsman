#!/bin/bash

echo "Extracting weblog data..."
tar -xvzf ../data/heckle.tar.gz -C ../data
tar -xvzf ../data/jeckle.tar.gz -C ../data

#echo "Merging weblog data..."
#cat ../data/heckle/* >> ../data/weblog.log
#cat ../data/jeckle/* >> ../data/weblog.log

echo "Upload weblog data..."
hadoop fs -rm -f -r -skipTrash ds-shorsman/incoming
hadoop fs -rm -f -r -skipTrash ds-shorsman/outgoing
hadoop fs -mkdir ds-shorsman/incoming
hadoop fs -mkdir ds-shorsman/outgoing
#hadoop fs -put ../data/weblog.log ds-shorsman/incoming
hadoop fs -put ../data/heckle ds-shorsman/incoming
hadoop fs -put ../data/jeckle ds-shorsman/incoming

echo "Cleaning up..."
rm -rf ../data/heckle
rm -rf ../data/jeckle
#rm -rf ../data/heckle.log
#rm -rf ../data/jeckle.log
#rm -rf ../data/weblog.log
