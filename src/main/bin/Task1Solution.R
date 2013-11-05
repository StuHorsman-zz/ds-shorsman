rm(list=ls())

# Task1Solution.R (stuart.horsman@gmail.com)
#
# Build a glm binomial predictive model based on a training set then predict
# the category of a user (adult or kid) based on viewing history.
#
# So we first create a dataframe from training, convert to sparse matrix and
# build a predictive model using glmnet.
#
# Then we build a sparse matrix for all users, score them, then reset those
# users back to the known values in our training set and finally write the 
# results.

# Load required libraries
library(Matrix)
library(glmnet)
library(caret)

# Read in files for 
#   training_data.file:- contains our training data
#   scoring_data.file:- contains all user movie play counts to be scored
#   submission.file:- will contain our results
data.dir <- "~/ds-shorsman/data/"
output.dir <- "~/ds-shorsman/output/"
train.data.file <- paste0(data.dir, 'task1_training_data.csv')
scoring.data.file <- paste0(data.dir, 'task1_scoring_data.csv')
kid.users.file <- paste0(data.dir, 'task1_kid_users.csv')
submission.file <- paste0(output.dir, 'Task1Solution.csv')


# Read in the training and scoring data 
training.df <- read.csv(train.data.file, header=FALSE, 
                        colClasses = "character")
all.user.df <- read.csv(scoring.data.file, header=FALSE, 
                        colClasses = "character")

# Set up the training dataframe.  For creating the spare matrix we need to
# create indexes for the users and movies
names(training.df) <- c("userId", "movieId", "count")
training.df$userFactor <- as.factor(training.df$userId)
training.df$movieFactor <- as.factor(training.df$movieId)
training.df$userIndex <- as.numeric(training.df$userFactor)
training.df$movieIndex <- as.numeric(training.df$movieFactor)
training.df$userId <- as.character(training.df$userId)
training.df$movieId <- as.character(training.df$movieId)
training.df$count <- as.integer(training.df$count)
training.df <- training.df[order(training.df$userIndex, 
                                           training.df$movieIndex), ]

# Set up the scoring dataframe.  For creating the spare matrix we need to
# create indexes for the users and movies
names(all.user.df) <- c("userId", "movieId", "count")
all.user.df$userFactor <- as.factor(all.user.df$userId)
all.user.df$movieFactor <- as.factor(all.user.df$movieId)
all.user.df$userIndex <- as.numeric(all.user.df$userFactor)
all.user.df$movieIndex <- as.numeric(all.user.df$movieFactor)
all.user.df$userId <- as.character(all.user.df$userId)
all.user.df$movieId <- as.character(all.user.df$movieId)
all.user.df$count <- as.integer(all.user.df$count)
all.user.df <- all.user.df[order(all.user.df$userIndex, 
                                     all.user.df$movieIndex), ]

# Set the dimensions of the matrix
x.train <- length(unique(training.df$userId)) # 16984
y.train <- length(unique(training.df$movieId)) # 4966
x.all.user <- length(unique(all.user.df$userId)) # 25000
y.all.user <- length(unique(all.user.df$movieId)) # 5000

# Set the rownames and colnames of the training matrix
train.movie.names <- training.df[, c("movieId", "movieIndex")]
train.user.names <- training.df[, c("userId", "userIndex")]
train.movie.names <- train.movie.names[with(train.movie.names, 
                                                  order(train.movie.names$movieIndex)), ]
train.user.names <- train.user.names[with(train.user.names, 
                                                order(train.user.names$userIndex)), ]
train.movie.ids <- unique(train.movie.names$movieId)
train.user.ids <- unique(train.user.names$userId)
z.train <- c(length(train.user.ids), length(train.movie.ids))

# Create a sparse Matrix for training data
train.mat <- sparseMatrix(i=training.df$userIndex,
                          j=training.df$movieIndex,
                          x=training.df$count,
                          dims=z.train,
                          dimnames=list(train.user.ids, train.movie.ids))

# Set the rownames and colnames of the scoring matrix
all.movie.names <- all.user.df[, c("movieId", "movieIndex")]
all.user.names <- all.user.df[, c("userId", "userIndex")]
all.movie.names <- all.movie.names[with(all.movie.names, 
                                                  order(all.movie.names$movieIndex)), ]
all.user.names <- all.user.names[with(all.user.names, 
                                                order(all.user.names$userIndex)), ]
all.movie.ids <- unique(all.movie.names$movieId)
all.user.ids <- unique(all.user.names$userId)
z.all.user <- c(length(all.user.ids), length(all.movie.ids))
  
# Create a sparse Matrix for all user data.
all.data.mat <- sparseMatrix(i=all.user.df$userIndex,
                             j=all.user.df$movieIndex,
                             x=all.user.df$count,
                             dims=z.all.user,
                             dimnames=list(all.user.ids, all.movie.ids))

# Remove the movies that we know nothing about.  For example, our training
# set contains 4966 movies but all_data contains 5000 movies, therefore we 
# need to remove the movies that aren't in our training model.  We do this so
# the users we're trying to score fits the dimensions of our training model.
all.data.mat <- all.data.mat[, colnames(train.mat)]

# Create the user type vector for training
# adults = 0
# kids = 1
train.nm <- rownames(train.mat)
train.users <- rep(0, length(train.nm))
names(train.users) <- train.nm
train.kids <- train.nm %in% grep("^K", train.nm, value=TRUE)
train.users[train.kids] <- 1
train.users <- as.factor(train.users)

# Read in known kids from parental controls.
# Update our predicted results.  The problem is some kids will be misclassified
# because they'll have viewing history as an adult
kid.users <- read.table(kid.users.file, header=FALSE, colClasses = "character", 
                        as.is=TRUE)
kid.users <- unlist(kid.users)

# For production we have 16984 records.  There is:
# 8781 kids (length(grep("^K", nm, value=TRUE)))
# 8203 adults (length(grep("^A", nm, value=TRUE)))
# Setup predictors and targets for glmnet
train.predictors <- train.mat
train.targets <- train.users
all.predictors <- all.data.mat

# Fit the glm model
glm.model <- glmnet(x=train.predictors, y=train.targets, family="binomial",
                    nlambda=100)

# Score all users
all.predict <- predict(glm.model, all.predictors, type="class")
all.results <- all.predict[, 100]

# Plot the responses (used for visualising the data)
#all.predict.resp <- predict(glm.model, all.predictors, type="response")
#plot(all.predict.resp[, 100])

# Set back known kid users and write the results.  We reset kids because these
# id's contain data when the kid was an adult, so could get missclassified
all.results[kid.users] <- 1
cat ("Writing results to ", submission.file, "\n")
write.table(all.results, file=submission.file, quote=FALSE, sep=",", 
            col.names=FALSE, row.names=TRUE)

