#!/bin/bash
#===============================================================================
# task2_workflow.sh
#
# stuart.horsman@gmail.com for CCP Web Analytics Challenge
# 
# A series of MapReduce jobs which sessionizes the weblog output and then runs
# Cloudera ML tools which run the kmeans Lloyds algorithm to find clusters in 
# the sessions.
# TODO move the outgoing data to incoming rather than copy (duplication of data)
# TODO comine MR jobs 1 & 2
#===============================================================================
export HADOOP_PREFIX=/usr
export JAVA_LIBRARY_PATH=/usr/lib/hadoop/lib/native

#===============================================================================
# Create the initial session table.  This cleans up the data and splits the play
# data between those actions which watch a movie and those actions which watch
# a TV show.
#===============================================================================
echo "Running task2 workflow..."
echo "Creating task2 session data..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/incoming/task2
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/task2
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/session

hadoop jar ../lib/task2.jar ccp.shorsman.task2.CreateSession \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/weblog.log \
ds-shorsman/outgoing/session

#===============================================================================
# Create the session durations spent on each action.  This adds a "seconds" 
# duration field to each session entry from the session table. 
# TODO combine these 2 jobs together
#===============================================================================
echo "Creating task2 session_duration data..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/incoming/session_duration
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/session_duration
hadoop fs -mkdir ds-shorsman/incoming/session_duration
hadoop fs -cp ds-shorsman/outgoing/session/part-r-* ds-shorsman/incoming/session_duration

hadoop jar ../lib/task2.jar ccp.shorsman.task2.CreateSessionDuration \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/session_duration/ \
ds-shorsman/outgoing/session_duration

#===============================================================================
# Extract the session durations and construct a csv for import into the 
# Cloudera ML summary command.  
#===============================================================================
echo "Extracting task2 session count data..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/incoming/session_counts
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/session_counts
hadoop fs -mkdir ds-shorsman/incoming/session_counts
hadoop fs -cp ds-shorsman/outgoing/session_duration/part-r-* ds-shorsman/incoming/session_counts

hadoop jar ../lib/task2.jar ccp.shorsman.task2.ExtractSessionCounts \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/session_counts/ \
ds-shorsman/outgoing/session_counts

#===============================================================================
# Finally copy the data into incoming/task2 for Cloudera ML processing
# Cloudera ML summary command.
#===============================================================================
hadoop fs -mkdir ds-shorsman/incoming/task2
hadoop fs -cp ds-shorsman/outgoing/session_counts/part-r-* ds-shorsman/incoming/task2

#===============================================================================
# Finally copy the data into incoming/task2 for Cloudera ML processing
# Cloudera ML summary command.  Compute stats for all input fields.
#===============================================================================
../client/bin/ml summary --input-paths ds-shorsman/incoming/task2/ --format text --header-file ../data/task2_header.csv --summary-file ../data/task2.json

#===============================================================================
# Normalize all the data and write avro vectors to outgoing. 
#===============================================================================
../client/bin/ml normalize --input-paths ds-shorsman/incoming/task2/ --format text --summary-file ../data/task2.json --transform Z --output-path ds-shorsman/outgoing/task2/ --output-type avro --id-column sessionid

#===============================================================================
# Show some vectors just so I know it's working
#===============================================================================
../client/bin/ml showvec --input-paths ds-shorsman/outgoing/task2/ --format avro --count 20

#===============================================================================
# Run ksketch.  Run a sketch of the dataset and write an Avro container file 
# made up of MLWeightedVector records (task2_wc.avro).
#===============================================================================
../client/bin/ml ksketch --input-paths ds-shorsman/outgoing/task2/ --format avro --points-per-iteration 1000 --output-file ../data/task2_wc.avro --seed 1234 --iterations 10 --cross-folds 2 

#===============================================================================
# Runs Lloyd's algorithm locally on the output of the ksketch command and 
# reports statistics about the quality and stability of the clusters that are 
# found.  
#===============================================================================
../client/bin/ml kmeans --input-file ../data/task2_wc.avro --centers-file ../data/task2_centers.avro --seed 19 --clusters 1,2,3,4,5,6,7,8,9,10,15,20,25 --best-of 5 --num-threads 8 --eval-stats-file ../data/task2_kmeans_stats.csv --eval-details-file ../data/task2_kmeans_details.csv

#===============================================================================
# Run kassign.  This assigns the sessions to the centers of our chosen cluster.
# From the above we find center id 15 (4 clusters) is a good fit.
# PredStrength > 0.8 and StableClusters and StablePoints == 1
#===============================================================================
../client/bin/ml kassign --input-paths ds-shorsman/outgoing/task2 --format avro --centers-file ../data/task2_centers.avro --center-ids 18 --output-path ds-shorsman/outgoing/task2/assigned --output-type csv

#===============================================================================
# Download the file to the local drive and write the solution file.
#===============================================================================
hadoop fs -getmerge ds-shorsman/outgoing/task2/assigned/part-m-* ../data/Task2Results.csv
cat ../data/Task2Results.csv | awk -F',' '{print $1","$3}' > ../output/Task2Solution.csv

#===============================================================================
# Runs the sample command to dump out extreme points for analytics
#===============================================================================
../client/bin/ml sample --input-paths ds-shorsman/outgoing/task2/assigned --format text --header-file ../data/kassign_header.csv --output-type csv --size 50 --weight-field squared_distance --group-fields clustering_id,closest_center_id --output-path ds-shorsman/outgoing/task2/extremal
hadoop fs -getmerge ds-shorsman/outgoing/task2/extremal/* ../data/Task2Extremal.csv

#===============================================================================
# Create some Hive tables for analysis
#===============================================================================
hive -f ../hql/create_session_duration.hql
hive -f ../hql/create_assigned.hql
