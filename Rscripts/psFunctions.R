## File psFunctions*.txt.
## Authors: Moira Regelson, Tao Shi, Steve Horvath
## see "General prediction strength methods for estimating the
## number of clusters with an application to gene co-expression networks"
## http://www.genetics.ucla.edu/labs/horvath/GeneralPredictionStrength

## please contact mregelson@mednet.ucla.edu or shorvath@mednet.ucla.edu
## with any questions/problems

predictNo <- function(myVec, myCutoff) {
  myMax = 0
  for (i in 1:length(myVec)) {
    if (myVec[i] > myCutoff) { myMax = i }
  }
  return(myMax)
}

##============================================================================

rm(choosenew)
choosenew <- function(n,k){
  n <- c(n)
  out1 <- rep(0,length(n))
  for (i in c(1:length(n)) ){
    if (n[i]<k) {out1[i] <- 0}
    else {out1[i] <- choose(n[i], k)}}
  out1
}
##===========================================================================

rm(minnew)
minnew <- function(x,k) {  
  out1 <- 0
  if(length(x)<k) {
    out1 <- mean(x)
  } else {  
    xnew <- sort(x)
    for (i in 1:k ) { out1 <- out1+xnew[i]}
    out1 <- out1/k
  }
  out1
}
##=============================================================================
## this function computes the standard error
rm(stderr1)
stderr1 <- function(x){ sqrt( var(x)/length(x) ) }


##=============================================================================
## Function pamPsClNo computes prediction strength and returns the estimated
## number of clusters based on PAM clustering
rm(pamPsClNo)
pamPsClNo <- function(original.data,
                      klimit=5, # max no. of clusters
                      cvFold=2, # how many fold cross validation
                      cvCount=10, # how many cross validations
                      m=2,      # number of points (vector or single integer)
                      diss=FALSE,
                      cut1=1){

  
  clustlearn <- list(NULL);
  clusttest  <- list(NULL);
  
  nData <- nrow(original.data);
  if (diss) {
    alldist <- as.matrix(original.data)
  } else {
    alldist <- as.matrix(dist(original.data))
  }
  alldist <- signif(alldist,10)

  if (length(m) == 1) {
    cps1 <- matrix(1,nrow=klimit,ncol=cvCount)
    criterion1 <- matrix(1,nrow=klimit,ncol=cvCount)
    mList <- c(m)
  } else {
    cps1 <- array(data=rep(1,klimit*cvCount*length(m)),
                  dim=c(klimit,cvCount,length(m)))
    criterion1 <- array(data=rep(1,klimit*cvCount*length(m)),
                        dim=c(klimit,cvCount,length(m)))
    mList <- m
  }
  mLen <- length(mList)

  ## for each cross-validation set
  for (cc in 1:cvCount) {
    ## two matrices used to store prediction strength calculated by
    ## four kinds of metrics
    if (mLen == 1) {
      ps1 <- matrix(1, nrow=klimit, ncol=cvFold)
    } else {
      ps1 <- array(data=rep(1,klimit*cvFold*mLen),dim=c(klimit,cvFold,mLen))
    }

    ## utility vector indicating split of data set into cvFold sets 
    rest1 <- nData-as.integer(nData/cvFold)*cvFold
    sam1 <-  sample(c(rep(c(1:cvFold), as.integer(nData/cvFold)),
                      sample(1:cvFold, rest1)))

    ## for each possible number of clusters,
    for (kk in 2:klimit){
      ## cvFold fold splitting for cross validation
      for (vv in 1:cvFold){

        ## indices of test and training sets
        test.index <- c(1:nData)[sam1==vv]
        learn.index <- c(1:nData)[sam1!=vv]
        no.test <- length(test.index)
        no.learn <- length(learn.index)

        for (mm in 1:mLen) {
          if (no.test <= kk || no.learn <= kk) {
            ## clustering too few points into too many clusters
            if (mLen == 1) {
              ps1[kk,vv] <- 0
            } else {
              ps1[kk,vv,mm] <- 0
            }
            next
          }
        }
        ## distances between points in test and training sets
        test.dist <- alldist[test.index, test.index]
        learn.dist <- alldist[learn.index, learn.index]
        
        ## perform clusterings on test and training sets
        clustlearn[[kk]] <- pam(as.dist(learn.dist), kk, diss=T)
        clusttest[[kk]] <-  pam(as.dist(test.dist), kk, diss=T)
        
        ## this assigns a cluster to each test set observation, based on the
        ## clustering of the training set.
        Cl <- rep(0, no.test)
        d <- rep(10000000, kk) #difference matrix for assigning Cl
        
        ## determine which medoid each test set point is closest to/i.e.,
        ## which cluster it belongs to according to the training set
        ## clustering
        index1 <-  clustlearn[[kk]]$medoids # length is kk
        for (i in 1:no.test){
          for (j in 1:kk){
            d[j] <- alldist[index1[[j]], test.index[i]]
            ## note: this assumes that the medoids are in the original dataset
          }
          mincluster <- c(1:kk)[rank(d) == min(rank(d))]
          if (length(mincluster) == 1) {
            Cl[i] <- mincluster
          }
          else if (length(mincluster)>1) {
            Cl[i] <- sample(mincluster, 1)
          }
        }  # end for for over i in 1:no.test
        
        ## now we compute how often m samples are co-clustered
        tab0 <- table(Cl, clusttest[[kk]]$clustering)
        tab1 <- tab0
        tab1[tab0<cut1] <- 0
        if (mLen == 1) {
          pshelp <- rep(10000000, kk)
        } else {
          pshelp <- matrix(1e7, nrow=kk, ncol=mLen)
        }
        for (l in 1:kk){
          ## marginals
          nkl <- sum(tab1[,l])
          if (mLen == 1) {
            myM <- mList[1]
            if (nkl < myM)  {
              pshelp[l] <- 0
            } else { 
              pshelp[l] <- sum(choosenew(tab1[,l], myM))/choosenew(nkl,myM) 
            }
          } else {
            for (mm in 1:mLen) {
              myM <- mList[mm]
              if (nkl < myM)  {
                pshelp[l,mm] <- 0
              } else { 
                pshelp[l,mm] <-
                  sum(choosenew( tab1[,l], myM))/choosenew(nkl,myM) 
              }
            }
          } # end of  for l in 1:kk
          if (mLen == 1) {
            ps1[kk,vv] <- min(pshelp)
          } else {
            ps1[kk,vv,] <- apply(pshelp, 2, min)
          }
        }
      } # end of vv in 1:cvFold
    } # end of kk in 2:klimit
    if (mLen == 1) {
      cps1[,cc] <- apply(ps1,1,mean)
      ## gives max over vv for cvFold=2
      criterion1[,cc] <-  cps1[, cc] + apply(ps1, 1, stderr1)
    } else {
      for (mm in 1:mLen) {
        cps1[,cc,mm] <- apply(ps1[,,mm],1,mean)
        ## gives max over vv for cvFold=2
        criterion1[,cc,mm] <-  cps1[, cc,mm] + apply(ps1[,,mm], 1, stderr1)
      }
    }
  } # end of for cc in 1:cvCount
  if (mLen == 1) {
    psse <- signif(apply(criterion1, 1, mean), 3)
    names(psse) <- paste(sep="", "k=", 1:klimit)
  } else {
    psse <- matrix(-1, nrow=klimit, ncol=mLen)
    for (mm in 1:mLen) {
      psse[,mm] <- signif(apply(criterion1[,,mm], 1, mean), 3)
    }
    dimnames(psse) <- list(paste(sep="", "k=", 1:klimit),
                           paste(sep="", "m=", mList))
  }

  return(psse)
} # end of function pamPsClNo

## function to compute value of ps from input clusterings or contingency table
rm(psIndex)
psIndex <- function(clustering1=NULL,
                    clustering2=NULL,
                    myTable=NULL,
                    m=2,
                    cut1=1){

  if (is.null(myTable)) {
    if (is.null(clustering1) || is.null(clustering2)) {
      print("Error: please input two clusterings or a contingency table")
      return
    }
    myClus1 <- clustering1
    myClus2 <- clustering2
    
    tab0 <- table(myClus1, myClus2)
  } else {
    tab0 <- myTable
  }
  tab1 <- tab0
  tab1[tab0 < cut1] <- 0
  
  myMax <- dim(tab1)[1]
  pshelp <- rep(-1, myMax)
  ## compute how often m samples are co-clustered for each cluster in myClus1
  for (s in 1:myMax){
    ## marginals
    n.s <- sum(tab1[,s])
    if (n.s < m)  {
      pshelp[s] <- 0
    } else { 
      pshelp[s] <- sum(choosenew(tab1[,s], m))/ choosenew(n.s, m)     
    }
  }
  print("column values")
  print(pshelp)
  ps1 <- min(pshelp) # minimizes ratio 

  return(ps1)
} # end of function psIndex

library(cclust)
library(scatterplot3d)
library(cluster)
library(MASS)
library(class)
