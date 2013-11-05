#!/bin/bash
#===============================================================================
# task2_workflow.sh
#
# stuart.horsman@gmail.com for CCP Web Analytics Challenge
# 
# A series of MapReduce jobs which:
#   Extracts the movie ratings for the weblogs and writes them in 
#   user,item,rating format.
#   Runs the mahout ALS-WR collaborative filtering alogorithm to make
#   predictions about specific user,item pairs.
#
# TODO making separate predictions for ~500 users split between adult and kid
# yields a small bump in RMSE.  Need to implement loading the Task1 output
# into the distributed cache for processing.
#===============================================================================
export JAVA_LIBRARY_PATH=/usr/lib/hadoop/lib/native

#===============================================================================
# Cleanup from previous jobs
#===============================================================================
echo "Running task3 workflow..."
echo "Creating task3 rating data..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/incoming/task3
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/task3
hadoop fs -mkdir ds-shorsman/incoming/task3
hadoop fs -mkdir ds-shorsman/outgoing/task3
rm -rf ../mahout/work
mkdir -p ../mahout/work/cloudera

#===============================================================================
# Extract the movie ratings from actions "Rate" and "WriteReview".  For TV
# episodes, we generalise the episode to the TV series, such that a rating for
# 1234e1 becomes 1234.
#===============================================================================
hadoop jar ../lib/task3.jar ccp.shorsman.task3.ExtractMovieRatings \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/weblog.log \
ds-shorsman/incoming/task3/data
hadoop fs -getmerge ds-shorsman/incoming/task3/data/part-* ../data/Task3Data.csv

#===============================================================================
# Run the mahout ALS-WR as described in the paper "Large-scale Parallel
# Collabaritive Filtering for the NetFlix Prize".  Details of this 
# algorithm can be found in:
# http://www.hpl.hp.com/personal/Robert_Schreiber/papers/ \
# 2008%20AAIM%20Netflix/netflix_aaim08(submitted).pdf
#
# The mahout implementation is described here:
# https://cwiki.apache.org/confluence/display/MAHOUT/ \
# Collaborative+Filtering+with+ALS-WR  
#
# The settings for numFeatures, numIterations and lambda were found by running
# multiple holdout tests against various combinations of these inputs.  It
# was found that numFeatures=30, numIterations=25 and lambda=0.065 yielded
# the lowest RMSE.
#===============================================================================
export MAHOUT_LOCAL="../mahout"
unset JAVA_LIBRARY_PATH

../mahout/bin/mahout parallelALS --input ../data/Task3Data.csv \
--output ../mahout/work/als/out --tempDir ../mahout/work/als/tmp \
--numFeatures 30 --numIterations 25 --lambda 0.065

#===============================================================================
# Compute predictions using the User and Item matrices created by the 
# parallelALS job.
#===============================================================================
../mahout/bin/mahout evaluatePrediction --input ../data/rateme.csv \
--output ../mahout/work/als/predict \
--userFeatures ../mahout/work/als/out/U/ \
--itemFeatures ../mahout/work/als/out/M/ \
--tempDir ../mahout/work/als/predictTmp

#===============================================================================
# Finally copy the results to the output directory.
#===============================================================================
cp ../mahout/work/als/predictTmp/predict/part* ../output/Task3Solution.csv
