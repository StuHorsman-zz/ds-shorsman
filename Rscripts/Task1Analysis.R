rm(list=ls())

###
# Task1Analysis of adult/kid movie data and testing of glmnet.
# Objects can be loaded by load("~/ds-shorsman/data/Task1Solution.RData")
###

# Load required libraries
library(Matrix)
library(glmnet)
library(caret)

# Read in the file and munge the df
# task1.file contains our training data
# all_user.file contains all user movie play counts to be scored
# scores.file will contain the user_id and class
data.dir <- "~/Cloudera/ds-shorsman/data/"
task1.file <- paste0(data.dir, 'task1_training_data.csv')

# Read in the training data
user_movie_counts <- read.csv(task1.file, header=FALSE, colClasses = "character")
names(user_movie_counts) <- c("user_id", "movie_id", "count")
user_movie_counts$user_factor <- as.factor(user_movie_counts$user_id)
user_movie_counts$movie_factor <- as.factor(user_movie_counts$movie_id)
user_movie_counts$user_index <- as.numeric(user_movie_counts$user_factor)
user_movie_counts$movie_index <- as.numeric(user_movie_counts$movie_factor)
user_movie_counts$user_id <- as.character(user_movie_counts$user_id)
user_movie_counts$movie_id <- as.character(user_movie_counts$movie_id)
user_movie_counts$count <- as.integer(user_movie_counts$count)
user_movie_counts <- user_movie_counts[order(user_movie_counts$user_index, 
                                             user_movie_counts$movie_index), ]

# Set the dimensions of the matrix
x <- length(unique(user_movie_counts$user_id)) # 16984
y <- length(unique(user_movie_counts$movie_id)) # 4966

# Set the rownames and colnames of the matrix
movie_names <- user_movie_counts[, c("movie_id", "movie_index")]
user_names <- user_movie_counts[, c("user_id", "user_index")]
movie_names <- movie_names[with(movie_names, order(movie_names$movie_index)), ]
user_names <- user_names[with(user_names, order(user_names$user_index)), ]
movie_ids <- unique(movie_names$movie_id)
user_ids <- unique(user_names$user_id)
z <- c(length(user_ids), length(movie_ids))

# Create a sparse Matrix
umc.mat <- sparseMatrix(i=user_movie_counts$user_index,
                        j=user_movie_counts$movie_index,
                        x=user_movie_counts$count,
                        dims=z,
                        dimnames=list(user_ids, movie_ids))

# Create the user type vector
# adults = 0
# kids = 1
nm <- rownames(umc.mat)

# Set all values to adult initially
users <- rep(0, length(nm))
kids <- nm %in% grep("^K", nm, value=TRUE)
users[kids] <- 1
users <- as.factor(users)

# Split the data into training, test and validation
# 1650 records are split training (70%=1155),
# test (20%=330), validation (10%=165)
# TODO calculate the splits automatically

# train.df <- train.df[train.index, ]
# test.df <- train.df[-train.index, ]

# For production we have 16984 records.  There is:
# 8781 kids (length(grep("^K", nm, value=TRUE)))
# 8203 adults (length(grep("^A", nm, value=TRUE)))
# train - 11888 records
# test - 3398
# val - 1698
all.predictors <- umc.mat
#train.index <- createDataPartition(nm, times=2, p=0.8, list=TRUE)
test.predictors <- rBind(umc.mat[1:1699, ], umc.mat[15285:16984, ])
validate.predictors <- rBind(umc.mat[1700:2549, ], umc.mat[14436:15284, ])
train.predictors <- umc.mat[2550:14435, ]

# Split out the targets
# NB when combining factor vectors we need to do it as character vectors
# first before transforming back
all.targets <- users
train.targets <- users[2550:14435]
test.targets <- c(as.character(users[1:1699]), as.character(users[15285:16984]))
validate.targets <- c(as.character(users[1700:2549]), as.character(users[14436:15284]))
test.targets <- as.factor(test.targets)
validate.targets <- as.factor(validate.targets)

# Fit the glm model
glm.model.all <- glmnet(x=all.predictors, y=all.targets, family="binomial",
                        nlambda=100)

glm.model.train <- glmnet(x=train.predictors, y=train.targets, family="binomial",
                          nlambda=100)

# Make predictions based on test data
all.predict <- predict(glm.model.all, all.predictors, type="class")
train.predict <- predict(glm.model.train, train.predictors, type="class")
test.predict <- predict(glm.model.train, test.predictors, type="class")
validate.predict <- predict(glm.model.train, validate.predictors, type="class")

# Test the glm model
plot(glm.model.all)
plot(glm.model.all, xvar="lambda")
plot(glm.model.all, xvar="dev")
cvglm.model.a <- cv.glmnet(x=train.predictors, y=train.targets, 
                           family="binomial")
plot(cvglm.model.a)
cvglm.model.b <- cv.glmnet(x=train.predictors, y=train.targets, 
                           family="binomial", type.measure="class")
plot(cvglm.model.b)
cvglm.model.c <- cv.glmnet(x=train.predictors, y=train.targets, 
                           family="binomial", type.measure="auc")
plot(cvglm.model.c)

# Test the glm model against all data
cvglm.model.all.a <- cv.glmnet(x=all.predictors, y=all.targets, 
                               family="binomial")
plot(cvglm.model.all.a)

cvglm.model.all.b <- cv.glmnet(x=all.predictors, y=all.targets, 
                               family="binomial", type.measure="class")
plot(cvglm.model.all.b)

cvglm.model.all.c <- cv.glmnet(x=all.predictors, y=all.targets, 
                               family="binomial", type.measure="auc")
plot(cvglm.model.all.c)

# Plot coefficiant deviances, 1418 coeffs
plot(glm.model.all)
plot(glm.model.all, xvar="lambda")
plot(glm.model.all, xvar="dev")

# Check confusion matrix
confusionMatrix(as.factor(train.predict[, 100]), train.targets)
confusionMatrix(as.factor(test.predict[, 100]), test.targets)
confusionMatrix(as.factor(validate.predict[, 100]), validate.targets)

# Plot the response
test.predict.resp <- predict(glm.model.train, test.predictors, type="response")
plot(test.predict.resp[, 100])
validate.predict.resp <- predict(glm.model.train, validate.predictors, type="response")
plot(validate.predict.resp[, 100])

# Save the model
save.image("~/Cloudera/ds-shorsman/data/Task1Solution.RData")