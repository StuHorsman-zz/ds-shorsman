rm(list=ls())

###
# Initial exploration of distribution of which movies have been watched
# and how many times
###

movie_counts <- read.csv("~/ds-shorsman/data/movie_counts.csv", header=F, stringsAsFactors=T)
names(movie_counts) <- c("MovieId", "Count")
movie_counts <- transform(movie_counts, MovieId=reorder(MovieId, -Count) ) 
ggplot(movie_counts[1:30, ], aes(x=MovieId,y=Count)) + geom_bar(stat="identity") + theme_bw()

tc <- nrow(movie_counts)
ss <- round(seq(from = 1, to = nrow(movie_counts), length.out=20))
ggplot(movie_counts[ss, ], aes(x=MovieId,y=Count)) + geom_bar(stat="identity") + theme_bw()
movie_counts[ss, ]
str(movie_counts)

PerCent <- function(x, y) {
  # Computes x as a percentage of y
  #
  # Args:
  #   x: a number
  #   y: a number
  # Returns:
  #   The count of targets per observation
  result <- round(x / y, digits=2)
  return(result)
}

movie_counts$Percent <- movie_counts$Count / sum(movie_counts$Count) # 5796894
movie_counts$Cumsum <- cumsum(movie_counts[1:nrow(movie_counts), 3])
ggplot(movie_counts[ss, ], aes(x=MovieId,y=Cumsum)) + 
  geom_bar(stat="identity") + 
  theme_bw() + 
  scale_x_discrete(labels=(round(ss/nrow(movie_counts), digits=2)))

