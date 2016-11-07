library("rvest")

#paste and prints the string argument
pprint <- function(...,seperator=" ") {
  print(paste(...),sep=separator)
}

defineOutFileName <- function() {
  outfile <- gsub("\\W","_",paste("hacker_news_titles_",Sys.time(),sep = ""),perl=TRUE)
  outfile <- paste(outfile,".txt",sep="")
  return (outfile)
}

sampleArticleOrdering <- function(t,articles,previousSamples=NA) {
  articleLength <- length(articles)
  timeVector <- rep(t,times=articleLength)
  sample <- data.frame(retrievalTime=timeVector,title=articles,ordering=1:articleLength)
  
  if (!is.na(previousSamples)) {
    sample<-rbind(previousSamples,sample)
  }
  return(sample)
}

i<-0;

fileNameForTitle <- function(title) {
  newTitle <- gsub("\\W+",replacement=".",title,perl=TRUE)
  newTitle <- paste(newTitle,".txt",sep = "")
  return (newTitle)
}

downloadArticles <- function(articles) {
   rowLength<-dim(articles)[1]
   
   for (i in 1:rowLength) {
     tryCatch({
       i<-i+1
       link <- articles$link[i]
       title <- articles$title[i]
       if (!is.na(link)) {
         pprint("finding whether article ",title," on link should be retrieved",link)
         destinationFile <- fileNameForTitle(title)
         destinationFile <- paste("articles/article_",destinationFile,sep = "")
         if (!file.exists(destinationFile)) {
           pprint("the article ",link,"has not been retrieved yet. Will now retrieve...")
           article_text <- read_html(as.character(link))%>%html_text()
           print("article retrieved")
           pprint("writing article with title'",title,"' to ",destinationFile)
           write(article_text,destinationFile)
         } else {
            pprint("file ",destinationFile,"already exists")
         }
       }
     },error=function(e) {
       print(paste("error: ",e))
     })
     
  }
}

extractArcticleOrdering <- function(previousSample=NA) {
  t <- Sys.time()
  hackerNews <- read_html("https://news.ycombinator.com/")
  
  storyLinks <- hackerNews %>% html_nodes(".storylink")
  
  titles <- trimws(storyLinks %>% html_text())
  titleLinks <- storyLinks %>% html_attr("href")
  
  articles <-data.frame(titles,titleLinks)
  colnames(articles) <- c("title","link")
  
  downloadArticles(articles)
  sample<-sampleArticleOrdering(t,articles$title,previousSamples = previousSample)
  
  return (sample)
}

outCsv <- defineOutFileName()
pprint("samples to be written to",outCsv)
samples=NA
while (TRUE) {
  samples <- extractArcticleOrdering(samples);
  write.csv(file=outCsv,x=samples)
  Sys.sleep(300)
}

xyplot(samples$ordering~samples$retrievalTime,group=samples$title,type=c('l'),
       data=samples,auto.key=list(columns=4,title="Titles"))


