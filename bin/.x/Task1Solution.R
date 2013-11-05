rm(list=ls())

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
training_data.file <- paste0(data.dir, 'task1_training_data.csv')
scoring_data.file <- paste0(data.dir, 'task1_scoring_data.csv')
submission.file <- paste0(output.dir, 'Task1Solution.csv')

# Read in the training and scoring data 
training.df <- read.csv(training_data.file, header=FALSE, 
                        colClasses = "character")
all_user.df <- read.csv(scoring_data.file, header=FALSE, 
                        colClasses = "character")

# Set up the training dataframe.  For creating the spare matrix we need to
# create indexes for the users and movies
names(training.df) <- c("user_id", "movie_id", "count")
training.df$user_factor <- as.factor(training.df$user_id)
training.df$movie_factor <- as.factor(training.df$movie_id)
training.df$user_index <- as.numeric(training.df$user_factor)
training.df$movie_index <- as.numeric(training.df$movie_factor)
training.df$user_id <- as.character(training.df$user_id)
training.df$movie_id <- as.character(training.df$movie_id)
training.df$count <- as.integer(training.df$count)
training.df <- training.df[order(training.df$user_index, 
                                           training.df$movie_index), ]

# Set up the scoring dataframe.  For creating the spare matrix we need to
# create indexes for the users and movies
names(all_user.df) <- c("user_id", "movie_id", "count")
all_user.df$user_factor <- as.factor(all_user.df$user_id)
all_user.df$movie_factor <- as.factor(all_user.df$movie_id)
all_user.df$user_index <- as.numeric(all_user.df$user_factor)
all_user.df$movie_index <- as.numeric(all_user.df$movie_factor)
all_user.df$user_id <- as.character(all_user.df$user_id)
all_user.df$movie_id <- as.character(all_user.df$movie_id)
all_user.df$count <- as.integer(all_user.df$count)
all_user.df <- all_user.df[order(all_user.df$user_index, 
                                     all_user.df$movie_index), ]

# Set the dimensions of the matrix
x_train <- length(unique(training.df$user_id)) # 16984
y_train <- length(unique(training.df$movie_id)) # 4966
x_all_user <- length(unique(all_user.df$user_id)) # 25000
y_all_user <- length(unique(all_user.df$movie_id)) # 5000

# Set the rownames and colnames of the training matrix
training_movie_names <- training.df[, c("movie_id", "movie_index")]
training_user_names <- training.df[, c("user_id", "user_index")]
training_movie_names <- training_movie_names[with(training_movie_names, 
                                                  order(training_movie_names$movie_index)), ]
training_user_names <- training_user_names[with(training_user_names, 
                                                order(training_user_names$user_index)), ]
training_movie_ids <- unique(training_movie_names$movie_id)
training_user_ids <- unique(training_user_names$user_id)
z_train <- c(length(training_user_ids), length(training_movie_ids))

# Create a sparse Matrix for training data
training.mat <- sparseMatrix(i=training.df$user_index,
                             j=training.df$movie_index,
                             x=training.df$count,
                             dims=z_train,
                             dimnames=list(training_user_ids, training_movie_ids))

# Set the rownames and colnames of the scoring matrix
all_movie_names <- all_user.df[, c("movie_id", "movie_index")]
all_user_names <- all_user.df[, c("user_id", "user_index")]
all_movie_names <- all_movie_names[with(all_movie_names, 
                                                  order(all_movie_names$movie_index)), ]
all_user_names <- all_user_names[with(all_user_names, 
                                                order(all_user_names$user_index)), ]
all_movie_ids <- unique(all_movie_names$movie_id)
all_user_ids <- unique(all_user_names$user_id)
z_all_user <- c(length(all_user_ids), length(all_movie_ids))
  
# Create a sparse Matrix for user data.
all_data.mat <- sparseMatrix(i=all_user.df$user_index,
                                   j=all_user.df$movie_index,
                                   x=all_user.df$count,
                                   dims=z_all_user,
                                   dimnames=list(all_user_ids, all_movie_ids))

# Remove the movies that we know nothing about.  For example, our training
# set contains 4966 movies but all_data contains 5000 movies, therefore we 
# need to remove the movies that aren't in our training model.
all_data.mat <- all_data.mat[, colnames(training.mat)]

# Create the user type vector for training
# adults = 0
# kids = 1
train_nm <- rownames(training.mat)
train_users <- rep(0, length(train_nm))
names(train_users) <- train_nm
train_kids <- train_nm %in% grep("^K", train_nm, value=TRUE)
train_users[train_kids] <- 1
train_users <- as.factor(train_users)

# Create the user type vector
# adults = 0
# kids = 1
all_nm <- rownames(all_data.mat)
all_users <- rep(0, length(all_nm))
names(all_users) <- all_nm
kid_users <- names(train_users[train_users == 1])
kid_users <- sub("^K", "", kid_users)
all_users[kid_users] <- 1
all_users <- as.factor(all_users)

# For production we have 16984 records.  There is:
# 8781 kids (length(grep("^K", nm, value=TRUE)))
# 8203 adults (length(grep("^A", nm, value=TRUE)))
# Setup predictors and targets for glmnet
train.predictors <- training.mat
train.targets <- train_users
all.predictors <- all_data.mat

# Fit the glm model
glm.model <- glmnet(x=train.predictors, y=train.targets, family="binomial",
                    nlambda=100)

# Make predictions based on test data
# train.predict <- predict(glm.model, train.predictors, type="class")

# Score all users
all.predict <- predict(glm.model, all.predictors, type="class")
all.results <- all.predict[, 100]

# Plot the responses (used for visualising the data)
#all.predict.resp <- predict(glm.model, all.predictors, type="response")
#plot(all.predict.resp[, 100])

# Set back known kid users and write the results.  We reset kids because these
# id's contain data when the kid was an adult, so could get missclassified
all.results[kid_users] <- 1
cat ("Writing results to", submission.file, "...\n")
write.table(all.results, file=submission.file, quote=FALSE, sep=",", 
            col.names=FALSE, row.names=TRUE)

