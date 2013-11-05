rm(list=ls())

###
# Task2 Analysis and Exploration
# Following the kmeans++ clustering on the ClouderaML tools, check and visualise
# the cluster results using the same methods to measure preduction strength
# used by the Cloudera ML tools.
# http://labs.genetics.ucla.edu/horvath/htdocs/GeneralPredictionStrength/
###

library(scatterplot3d)
library(rgl)
source('psFunctions.R')

data <- read.csv("/home/stuart/ds-shorsman/data/Task2Data.csv")
results <- read.csv("/home/stuart/ds-shorsman/data/Task2Results.csv", 
                    stringsAsFactors=FALSE)

names(results) <- c("sessionId", "id", "cluster", "distance")
rownames(results) <- results$sessionId
results <- results[order(results$cluster, results$distance), ]

dataNames <- c("sessionId", "login", "logout", "account", "rate", "queue", "resume", 
               "home", "hover", "pause", "stop", "recommendations", "search", 
               "tvduration", "tvcount","movieduration","moviecount")
names(data) <- dataNames
rownames(data) <- data$sessionId

# Create training df with a results from each cluster
train.df <- rbind(results[results$cluster==0, ][1:500, ],
                   results[results$cluster==1, ][1:500, ],
                   results[results$cluster==2, ][1:500, ],
                   results[results$cluster==3, ][1:500, ],
                   results[results$cluster==4, ][1:500, ]

)

# Finally create our test dataframe and convert to matrix
test.df <- data[train.df$sessionId, ]
rownames(test.df) <- test.df$sessionId
test.df$sessionId <- NULL
t2.m <- as.matrix(test.df)
t2.m <- scale(t2.m)

# Analysis
cmd1 <- cmdscale(dist(t2.m), 3)
scatterplot3d(cmd1, xlab="x", ylab="y", zlab="z")
maxK <- 10 # largest number of clusters to consider
mList <- c(2, 5, 10) # set of values for "m" (m-tuplets to co-cluster)
cvCount <- 5 # number of cross-validations to perform
myPSarray <- pamPsClNo(t2.m, klimit=maxK, cvCount=cvCount, m=mList)
print(myPSarray)

matplot(main="", ylab="", myPSarray,
        type="l",
        lty=1:dim(myPSarray)[2],
        lwd=3,
        col=gray((1:maxK)/(maxK + 1)))
lines(1:maxK, rep(.8, maxK))
title(ylab="PSE(m, k)", xlab="k")
legend(1,0.4,dimnames(myPSarray)[[2]],
       col=gray((1:maxK)/(maxK + 1)),
       lty=1:dim(myPSarray)[2], lwd=3, bty="n")

pamClus <- pam(t2.m, k=5)
scatterplot3d(cmd1, color=pamClus$clustering, xlab="x", ylab="y", zlab="z")
plot3d(cmd1, col=pamClus$clustering, xlab="x", ylab="y", zlab="z")

# Update train.df with cluster numbers
# train.df$cluster[1:500] <- 0
# train.df$cluster[501:1000] <- 1
# train.df$cluster[1001:1500] <- 2
# train.df$cluster[1501:2000] <- 3
# train.df$cluster[2001:2500] <- 4
#test.df$sessionId <- rownames(test.df)
test.df <- merge(data, results, by="sessionId")
test.df <- test.df[order(test.df$cluster, test.df$distance), ]

# Investigations into the different clusters
# Show 20 records to see if any trends emerge from the data

# Cluster 0 is all sessions which watch TV
test.df[test.df$cluster==0, ][1:20, -(1:4)]

# Cluster 1 is sessions which watch movies with a moviecount of 1
# and there are no ratings
test.df[test.df$cluster==1, ][1:20, -(1:4)]
nrow(test.df[test.df$cluster==1, ]) # 260807
min(test.df[test.df$cluster==1, "rate"])
max(test.df[test.df$cluster==1, "rate"])
table(test.df[test.df$cluster==1, "rate"]) # 241331 did not rate a movie
min(test.df[test.df$cluster==1, "moviecount"])
max(test.df[test.df$cluster==1, "moviecount"])
min(test.df[test.df$cluster==1, "recommendations"])
max(test.df[test.df$cluster==1, "recommendations"])
table(test.df[test.df$cluster==1, "moviecount"]) # 230270 sessions seen 1 movie
table(test.df[test.df$cluster==1, "recommendations"])

# Cluster 2 is sessions which watch movies with a moviecount of 1
# and the user also rates movies
test.df[test.df$cluster==2, ][1:20, -(1:4)]
nrow(test.df[test.df$cluster==2, ]) # 30411
min(test.df[test.df$cluster==2, "rate"])
max(test.df[test.df$cluster==2, "rate"])
sum(table(test.df[test.df$cluster==2, "rate"])) # 30411, all sessions rated a movie
min(test.df[test.df$cluster==2, "moviecount"])
max(test.df[test.df$cluster==2, "moviecount"])
table(test.df[test.df$cluster==2, "moviecount"]) # 24130 just 1 movie
sum(test.df[test.df$cluster==2, "rate"])
min(test.df[test.df$cluster==2, "recommendations"])
max(test.df[test.df$cluster==2, "recommendations"])
table(test.df[test.df$cluster==2, "recommendations"])

# Cluster 3 is sessions which watch movies but the moviecount
# represents multiple movies.  These sessions don't rate movies
# but do log onto recommendations
test.df[test.df$cluster==3, ][1:20, -(1:4)]
nrow(test.df[test.df$cluster==3, ]) # 21401
min(test.df[test.df$cluster==3, "rate"])
max(test.df[test.df$cluster==3, "rate"])
table(test.df[test.df$cluster==3, "rate"]) # 18134 zero rating
min(test.df[test.df$cluster==3, "moviecount"])
max(test.df[test.df$cluster==3, "moviecount"])
table(test.df[test.df$cluster==3, "moviecount"])
sum(test.df[test.df$cluster==3, "rate"])
min(test.df[test.df$cluster==3, "recommendations"])
max(test.df[test.df$cluster==3, "recommendations"])
table(test.df[test.df$cluster==3, "recommendations"])

# Cluster 4 is sessions which watch movies with a moviecount of 1
# don't rate and also ignore recommendations
test.df[test.df$cluster==4, ][1:20, -(1:4)]
nrow(test.df[test.df$cluster==4, ]) # 70423
min(test.df[test.df$cluster==4, "rate"])
max(test.df[test.df$cluster==4, "rate"])
table(test.df[test.df$cluster==4, "rate"]) # 18134 zero rating
min(test.df[test.df$cluster==4, "moviecount"])
max(test.df[test.df$cluster==4, "moviecount"])
table(test.df[test.df$cluster==4, "moviecount"]) # 63565 1 movie
sum(test.df[test.df$cluster==4, "rate"])
min(test.df[test.df$cluster==4, "recommendations"])
max(test.df[test.df$cluster==4, "recommendations"])
table(test.df[test.df$cluster==4, "recommendations"])

