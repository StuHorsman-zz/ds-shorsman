rm(list=ls())

# Task3Analysis.R (stuart.horsman@gmail.com)


# Exploration of the movie ratings recorded in the Cloudera Movie logfiles
# Initial benchmark of rmse with predictions of average user ratings and
# average movie ratings.  This also plots the rmse scores from the ALS-WR 
# mahout job which predicts the movie ratings.

# This is information from 2 extracts of the movie data, one which includes
# TV shows and the other without:
#   24337  users (22880 without tv data)
#   4829	items (3833 without tv data)
#   117523373	possible ratings
#   87808	actual ratings (73473 without tv data)
#   0.07%	percent of the dataset (0.08% without tv data)

# Load required libraries
library(Matrix)
library(recommenderlab)
library(caret)
library(hydroGOF)

# Set data directories
data.dir <- "~/ds-shorsman/data/"
output.dir <- "~/ds-shorsman/output/"

# Load data from ExtractMovieRatings MR job
# Also load rmse scores from ALS-WR mahout job for graphing.
train.data.file <- paste0(data.dir, 'Task3Data.csv')
rmse.data.file <- paste0(data.dir, 'task3_rmse_testing.csv')
results.data.file <- paste0(output.dir, 'Task3Solution.csv')

# Create movies ratings data frame
train.df <- read.csv(train.data.file, header=FALSE, colClasses = "character")
rmse.df <- read.csv(rmse.data.file, header=TRUE)
results.df <- read.csv(results.data.file, header=FALSE, colClasses = "character")
names(train.df) <- c("userid", "movieid", "rating")
names(results.df) <- c("userid", "movieid", "rating")

# Create train and test dataframes
# set.seed(3456)
# train.index <- createDataPartition(train.df$userid, times=1, p=0.8, list=FALSE)
# train.df <- train.df[train.index, ]
# test.df <- train.df[-train.index, ]

# Create train df.  This contains all known ratings and reviews
train.df$userfactor <- as.factor(train.df$userid)
train.df$moviefactor <- as.factor(train.df$movieid)
train.df$userindex <- as.numeric(train.df$userfactor)
train.df$movieindex <- as.numeric(train.df$moviefactor)
train.df$userid <- as.character(train.df$userid)
train.df$movieid <- as.character(train.df$movieid)
train.df$rating <- as.numeric(train.df$rating)
train.df <- train.df[order(train.df$userindex, 
                                 train.df$movieindex), ]
x.train <- length(unique(train.df$userid)) 
y.train <- length(unique(train.df$movieid))

# Create results df
results.df$userfactor <- as.factor(results.df$userid)
results.df$moviefactor <- as.factor(results.df$movieid)
results.df$userindex <- as.numeric(results.df$userfactor)
results.df$movieindex <- as.numeric(results.df$moviefactor)
results.df$userid <- as.character(results.df$userid)
results.df$movieid <- as.character(results.df$movieid)
results.df$rating <- as.numeric(results.df$rating)
results.df <- results.df[order(results.df$userindex, 
                            results.df$movieindex), ]
x.results <- length(unique(results.df$userid)) 
y.results <- length(unique(results.df$movieid))

# Create train sparse matrix
train.movie.names <- train.df[, c("movieid", "movieindex")]
train.user.names <- train.df[, c("userid", "userindex")]
train.movie.names <- train.movie.names[with(train.movie.names, 
                                                  order(train.movie.names$movieindex)), ]
train.user.names <- train.user.names[with(train.user.names, 
                                                order(train.user.names$userindex)), ]
train.movie.ids <- unique(train.movie.names$movieid)
train.user.ids <- unique(train.user.names$userid)
z.train <- c(length(train.user.ids), length(train.movie.ids))

# Create a sparse Matrix for train data
train.matrix <- sparseMatrix(i=train.df$userindex,
                             j=train.df$movieindex,
                             x=train.df$rating,
                             dims=z.train,
                             dimnames=list(train.user.ids, train.movie.ids))

# Create results sparse matrix
results.movie.names <- results.df[, c("movieid", "movieindex")]
results.user.names <- results.df[, c("userid", "userindex")]
results.movie.names <- results.movie.names[with(results.movie.names, 
                                            order(results.movie.names$movieindex)), ]
results.user.names <- results.user.names[with(results.user.names, 
                                          order(results.user.names$userindex)), ]
results.movie.ids <- unique(results.movie.names$movieid)
results.user.ids <- unique(results.user.names$userid)
z.results <- c(length(results.user.ids), length(results.movie.ids))

# Create a sparse Matrix for test data
results.matrix <- sparseMatrix(i=results.df$userindex,
                             j=results.df$movieindex,
                             x=results.df$rating,
                             dims=z.results,
                             dimnames=list(results.user.ids, results.movie.ids))

# Transform into recommenderLab RatingMatrix
train.rate <- new("realRatingMatrix", data=train.matrix)
train.norm <- normalize(train.rate)
results.rate <- new("realRatingMatrix", data=results.matrix)
results.norm <- normalize(results.rate)



# Mean rating for all users is 4.112296
# Rmse is 1.101202
avg.user.rating <- mean(rowMeans(train.rate))
train.df$preduser <- avg.user.rating
avg.user.rmse <- rmse(train.df$preduser, train.df$rating)

#rowCounts(train.rate[1, ])
#as(train.rate[1, ], "list")

###
# This section performs some analysis on whether using the predicted data
# from Task1 improves the RMSE
### 

# Load the predicted account type (adult/kid) data to check whether adults
# rate differently than kids
task1.data.file <- paste0(data.dir, 'Task1Solution.csv')
users.df <- read.csv(task1.data.file, header=FALSE, colClasses = "character")
names(users.df) <- c("userid", "type")
users.df$type <- as.factor(users.df$type)
new.df <- merge(train.df, users.df, by="userid")
adults.df <- new.df[new.df$type==0, ]
kids.df <- new.df[new.df$type==1, ]

# Create kids sparse matrix
kids.df$userfactor <- as.factor(kids.df$userid)
kids.df$moviefactor <- as.factor(kids.df$movieid)
kids.df$userindex <- as.numeric(kids.df$userfactor)
kids.df$movieindex <- as.numeric(kids.df$moviefactor)
kids.df$userid <- as.character(kids.df$userid)
kids.df$movieid <- as.character(kids.df$movieid)
kids.df$rating <- as.numeric(kids.df$rating)
kids.movie.names <- kids.df[, c("movieid", "movieindex")]
kids.user.names <- kids.df[, c("userid", "userindex")]
kids.movie.names <- kids.movie.names[with(kids.movie.names, 
                                           order(kids.movie.names$movieindex)), ]
kids.user.names <- kids.user.names[with(kids.user.names, 
                                         order(kids.user.names$userindex)), ]
kids.movie.ids <- unique(kids.movie.names$movieid)
kids.user.ids <- unique(kids.user.names$userid)
z.kids <- c(length(kids.user.ids), length(kids.movie.ids))

# Create a sparse Matrix for kids data
kids.matrix <- sparseMatrix(i=kids.df$userindex,
                            j=kids.df$movieindex,
                            x=kids.df$rating,
                            dims=z.kids,
                            dimnames=list(kids.user.ids, kids.movie.ids))

# Create kids rating matrix
kids.rate <- new("realRatingMatrix", data=kids.matrix)
kids.norm <- normalize(kids.rate)
avg.kid.user.rating <- mean(rowMeans(kids.rate))
hist(getRatings(kids.rate))
hist(getRatings(kids.norm))

# Create adults sparse matrix
adults.df$userfactor <- as.factor(adults.df$userid)
adults.df$moviefactor <- as.factor(adults.df$movieid)
adults.df$userindex <- as.numeric(adults.df$userfactor)
adults.df$movieindex <- as.numeric(adults.df$moviefactor)
adults.df$userid <- as.character(adults.df$userid)
adults.df$movieid <- as.character(adults.df$movieid)
adults.df$rating <- as.numeric(adults.df$rating)
adults.movie.names <- adults.df[, c("movieid", "movieindex")]
adults.user.names <- adults.df[, c("userid", "userindex")]
adults.movie.names <- adults.movie.names[with(adults.movie.names, 
                                          order(adults.movie.names$movieindex)), ]
adults.user.names <- adults.user.names[with(adults.user.names, 
                                        order(adults.user.names$userindex)), ]
adults.movie.ids <- unique(adults.movie.names$movieid)
adults.user.ids <- unique(adults.user.names$userid)
z.adults <- c(length(adults.user.ids), length(adults.movie.ids))

# Create a sparse Matrix for adults data
adults.matrix <- sparseMatrix(i=adults.df$userindex,
                            j=adults.df$movieindex,
                            x=adults.df$rating,
                            dims=z.adults,
                            dimnames=list(adults.user.ids, adults.movie.ids))

# Create adults rating matrix
adults.rate <- new("realRatingMatrix", data=adults.matrix)
adults.norm <- normalize(adults.rate)
avg.adult.user.rating <- mean(rowMeans(adults.rate))
hist(getRatings(adults.rate))
hist(getRatings(adults.norm))

# Calculate rmse
new.df[new.df$type==0, ]$preduser <- avg.adult.user.rating
new.df[new.df$type==1, ]$preduser <- avg.kid.user.rating

kid.rmse <- rmse(new.df[new.df$type==1, ]$preduser, 
                 new.df[new.df$type==1, ]$rating)
adult.rmse <- rmse(new.df[new.df$type==0, ]$preduser, 
                   new.df[new.df$type==0, ]$rating)
all.rmse <- (kid.rmse * nrow(new.df[new.df$type==1, ])) + (adult.rmse * nrow(new.df[new.df$type==0, ]))
all.rmse <- all.rmse / nrow(new.df)

cat("RMSE of all average user ratings is: ", avg.user.rmse)
cat("RMSE of all weighted user ratings is: ", all.rmse)
cat("RMSE of all adult ratings is: ", adult.rmse)
cat("RMSE of all kid ratings is: ", kid.rmse)

# Plot histograms of training data
opar <- par(no.readonly=TRUE)
par(mfrow=c(1,2))
hist(rowMeans(train.rate), breaks=20, main="Row Means Training Data", xlab="Rating")
hist(rowMeans(results.rate), breaks=20, xlim=c(1,5), 
     main="Row Means Predicted Data", xlab="Rating")
par(opar)

par(mfrow=c(1,2))
hist(getRatings(normalize(train.rate, method="Z-score")), breaks=100, 
     main="Row Means Training Data (Z)", xlab="Normalized Rating")
hist(getRatings(normalize(results.rate, method="Z-score")), breaks=100,
     main="Row Means Predicted Data(Z)", xlab="Normalized Rating")
par(opar)

# Analysis of training data
hist(rowCounts(train.rate), breaks=20)
hist(rowMeans(train.rate), breaks=20)
hist(colMeans(train.rate), breaks=20)

# Plot RMSE of ALS-WR 
ggplot(rmse.df, aes(x=X.iterations, y=rmse, group=lambda, col=lambda, 
                    linetype=as.factor(lambda))) + 
  geom_line() +
  theme_bw() +
  scale_colour_gradient(high="red") +
  xlab("Iterations") +
  ylab("RMSE") +
  geom_line(aes(y=all.rmse))

