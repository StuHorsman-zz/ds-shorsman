#!/bin/bash

echo "Extracting weblog data to ../data..."
tar -xvzf ../data/heckle.tar.gz -C ../data
tar -xvzf ../data/jeckle.tar.gz -C ../data

echo "Upload weblog data to hdfs ds-shorsman/incoming..."
hadoop fs -rm -f -r -skipTrash ds-shorsman/incoming
hadoop fs -rm -f -r -skipTrash ds-shorsman/outgoing
hadoop fs -mkdir ds-shorsman/incoming
hadoop fs -mkdir ds-shorsman/outgoing
hadoop fs -put ../data/heckle ds-shorsman/incoming
hadoop fs -put ../data/jeckle ds-shorsman/incoming

echo "Cleaning up..."
rm -rf ../data/heckle
rm -rf ../data/jeckle

echo "Updating and cleaning up source files..."
hadoop jar ../lib/UpdateWeblog.jar ds.shorsman.UpdateWeblog \
-libjars ../libjars/json-simple-1.1.1.jar,../libjars/joda-time-2.3.jar \
ds-shorsman/incoming/heckle \
ds-shorsman/incoming/jeckle \
ds-shorsman/outgoing/00-update-weblog

echo "Moving output data to ds-shorsman/incoming/weblog.log..."
hadoop fs -mv ds-shorsman/outgoing/00-update-weblog/part-r-00000 ds-shorsman/incoming/weblog.log

echo "Creating hive movies database..."
hadoop fs -rm -f -r -skipTrash /user/hive/warehouse/movies.db
hive -f ../hql/create_movies.hql

while true; do
  read -p "Do you want to install the required R packages? [Y|n]" answer
    case $answer in
        [Yy]* ) ./install_R_libs.sh; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer [Y|n]";;
    esac
done
