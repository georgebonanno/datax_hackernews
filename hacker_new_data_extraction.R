library(ggplot2)
library(lattice)

hackerNewArticleStandings <- read.csv('sample_readings.txt')
hackerNewArticleStandings$retrievalTime <- as.POSIXct(hackerNewArticleStandings$retrievalTime,"%Y-%m-%d %H:%M:%S")
hackerNewArticleStandings$ordering <- as.numeric(hackerNewArticleStandings$ordering)


samples <- hackerNewArticleStandings

sampleCount <- samples[samples$ordering==1,]
noOfTimesInPlacing <- aggregate(x=sampleCount[,"title"],list(unique.values = sampleCount$title),FUN=length)

plotOrderingsOfAll <- function () {
  xyplot(samples$ordering~samples$retrievalTime,group=samples$title,type=c('l'),
         data=samples,auto.key=list(columns=4,title="Titles"),xlab = "retrieval time",
         ylab = "ordering")
}


 barplotForOrdering <- function(placing) {
  sampleCount <- samples[samples$ordering==placing,]
  noOfTimesInPlacing <- aggregate(x=sampleCount[,"title"],list(unique.values = sampleCount$title),FUN=length)
  noOfTimesInPlacing<-noOfTimesInPlacing[noOfTimesInPlacing$x > 0,]
  counts <- table(noOfTimesInPlacing$x,noOfTimesInPlacing$unique.values)
  barplot(noOfTimesInPlacing$x,names=noOfTimesInPlacing$unique.values,xlab="title",ylab="number of placings")
}

barplotForOrdering(1)
#plotOrderingsOfAll()
