#!/bin/bash

echo "Extracting weblog data..."
tar -xvzf ../data/heckle.tar.gz -C ../data
tar -xvzf ../data/jeckle.tar.gz -C ../data

echo "Merging weblog data..."
cat ../data/heckle/* >> ../data/heckle.log
cat ../data/jeckle/* >> ../data/jeckle.log
cat ../data/heckle.log ../data/jeckle.log >> ../data/weblog.log

echo "Sampling weblog data..."
cat ../data/weblog.log | perl -n -e 'print if (rand() < .01)' > ../data/weblog.sample
#cat ../data/weblog.log | perl -n -e 'print if (rand() < .1)' > ../data/weblog.sample

echo "Upload weblog data..."
hadoop fs -rm -f -r -skipTrash ds-shorsman/incoming
hadoop fs -mkdir ds-shorsman/incoming
hadoop fs -put ../data/weblog.sample ds-shorsman/incoming/weblog.log

echo "Cleaning up..."
rm -rf ../data/heckle
rm -rf ../data/jeckle
rm -rf ../data/heckle.log
rm -rf ../data/jeckle.log
rm -rf ../data/weblog.log
