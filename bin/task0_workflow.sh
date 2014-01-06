#!/bin/bash

#===============================================================================
# task0_workflow.sh
#
# stuart.horsman@gmail.com for CCP Web Analytics Challenge
#
# A series of jobs which:
#   1. Extracts the heckle and jeckle logs to the local fs.
#   2. Uploads the data to hdfs.
#   3. Runs UpdateWeblog to format, clean and standardise the logfile.
#   4. Creates a ds-shorsman/incoming/weblog.log to be used by all other jobs.
#   5. Installs R packages required for the challenge.
# 
#===============================================================================
if [ ! -f ../data/heckle.tar.gz ]
then
  echo "Please copy heckle.tar.gz into ../data"
  exit 1
fi

if [ ! -f ../data/jeckle.tar.gz ]
then
  echo "Please copy jeckle.tar.gz into ../data"
fi

echo "Extracting weblog data to ../data..."
tar -xvzf ../data/heckle.tar.gz -C ../data
tar -xvzf ../data/jeckle.tar.gz -C ../data

echo "Upload weblog data to hdfs ds-shorsman/incoming..."
hadoop fs -rm -f -r -skipTrash ds-shorsman/incoming
hadoop fs -rm -f -r -skipTrash ds-shorsman/outgoing
hadoop fs -mkdir ds-shorsman
hadoop fs -mkdir ds-shorsman/incoming
hadoop fs -mkdir ds-shorsman/outgoing
hadoop fs -put ../data/heckle ds-shorsman/incoming
hadoop fs -put ../data/jeckle ds-shorsman/incoming

echo "Cleaning up..."
rm -rf ../data/heckle
rm -rf ../data/jeckle

echo "Updating and cleaning up source files..."
hadoop jar ../lib/task0.jar ccp.shorsman.task0.UpdateWeblog \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/heckle \
ds-shorsman/incoming/jeckle \
ds-shorsman/outgoing/00-update-weblog

echo "Moving output data to ds-shorsman/incoming/weblog.log..."
hadoop fs -mv ds-shorsman/outgoing/00-update-weblog/part-r-00000 ds-shorsman/incoming/weblog.log

echo "Creating hive movies database..."
hive -f ../hql/create_movies.hql

while true; do
  read -p "Do you want to install the required R packages? [Y|n]" answer
    case $answer in
        [Yy]* ) ./install_R_libs.sh; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer [Y|n]";;
    esac
done
