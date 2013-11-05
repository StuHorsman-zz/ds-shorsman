#!/bin/bash
#===============================================================================
# task1_workflow.sh
#
# stuart.horsman@gmail.com for CCP Web Analytics Challenge
#
# A series of MapReduce and Hive jobs to create a data set which is then
# executed by R using packages Matrix and glmnet to predict whether a user on
# the website is an adult(0) or kid(1).

# The training set we construct uses the information held in action
# parental controls.  This setting indicates whether an user account switched
# from an adult account to a kid account.  Therefore we can construct a matrix
# containing rows of movies watched when the account was an adult and rows
# which contains movies watched when the account became a kid.
#
# The Task1Solution.R is derived from the Task1SolutionTrain.R which was used
# for testing.  This can be found in the src/test/R/ccp/shorsman/task1
# folder.
# 
#===============================================================================

#===============================================================================
# Create the play table which contains all play information.  We aggregate
# tv shows (those ids that contain an "e" representing "episode" into 1 item.
# Therefore, item ids e.g 999e1 and 999e2 becoming the dependent variable 999e.  
#===============================================================================
echo "Running task1 workflow..."
echo "Creating play data..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/type/play
hadoop jar ../lib/task1.jar ccp.shorsman.task1.CreatePlay \
-libjars ../libjars/json-simple-1.1.1.jar \
ds-shorsman/incoming/weblog.log \
ds-shorsman/outgoing/type/play

#===============================================================================
# Create the parental control data, which contains a known list of user ids 
# that became kids.
#===============================================================================
echo "Creating parental_controls data..."
hadoop fs -rm -r -f -skipTrash ds-shorsman/outgoing/type/parental_controls
hadoop jar ../lib/task1.jar ccp.shorsman.task1.CreateParentalControls \
-libjars ../libjars/json-simple-1.1.1.jar \
ds-shorsman/incoming/weblog.log \
ds-shorsman/outgoing/type/parental_controls

#===============================================================================
# Create a series of tables using Hive.  This joins parental controls with play
# to get a list of known adults users and movie list and a list of known
# kids users and movie list.
#===============================================================================
echo "Creating play hive table..."
hive -f ../hql/create_play.hql

echo "Creating parental_controls hive table..."
hive -f ../hql/create_parental_controls.hql 

echo "Creating adult play data from parental_controls..."
hive -f ../hql/create_adult_play_data.hql

echo "Creating kid play data from parental_controls..."
hive -f ../hql/create_kid_play_data.hql

echo "Creating combined training set for glmnet..."
hive -f ../hql/create_task1_training_data.hql

echo "Creating user data for glm scoring..."
hive -f ../hql/create_task1_scoring_data.hql

#===============================================================================
# Download the training data and data to be scored, which is all known users.
# TODO exclude known kids users from the scoring set
#===============================================================================
echo "Downloading training set for glmnet..."
hadoop fs -getmerge /user/hive/warehouse/movies.db/task1_training_data/* ../data/task1_training_data.csv

echo "Downloading scoring set for glmnet..."
hadoop fs -getmerge /user/hive/warehouse/movies.db/task1_scoring_data/* ../data/task1_scoring_data.csv

#===============================================================================
# Run the R jobs which:
# o Builds sparse Matrices for training and scoring data
# o Builds a binomial prediction model using glmnet (generalized linear model
#   with regularization)
# o Scores all users
# o Writes a solution file to ../output
#===============================================================================
echo "Running Task1Solution.R..."
/usr/bin/env Rscript ../bin/Task1Solution.R
