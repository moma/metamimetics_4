#create existing file, data frame with names 
#paste each df for libraries 

rm(list=ls(all=TRUE))


load("/Users/Diana/Documents/StageData/R/igraphFunctions.rdata")
load("/Users/Diana/Documents/StageData/R/SnaFunctions.rdata")
load("/Users/Diana/Documents/StageData/R/reachFunctions.rdata")
load("/Users/Diana/Documents/StageData/R/createStats.rdata")


library(compiler)
library(sna)
library(qgraph)
library(igraph)

reach2.pc<-reach2
reach3.pc<-reach3
dwreach.pc<-dwreach
igraphFunctions.pc<-igraphFunctions
SnaFunctions.pc<-SnaFunctions

createStats.pc<-createStats
reach2<-cmpfun(reach2.pc)
reach3<-cmpfun(reach3.pc)
dwreach<-cmpfun(dwreach.pc)
igraphFunctions<-cmpfun(igraphFunctions.pc)
SnaFunctions<-cmpfun(SnaFunctions.pc)
createStats<-cmpfun(createStats.pc)


graphs<-list.files("/Users/Diana/Documents/StageData/R/outputs/iscpif/users/sifuentes/output",all.files=FALSE,full.names=TRUE,pattern=".graphml")
graphs2<-unlist(lapply(list.files("/Users/Diana/Documents/StageData/R/outputs/iscpif/users/sifuentes/output",all.files=FALSE,full.names=FALSE,pattern=".graphml"),function(x) gsub(".graphml","", x,fixed=TRUE)))


createStats(graphs,graphs2)


dfSNALong<-list.files("/Users/Diana/Documents/StageData/R",all.files=FALSE,full.names=TRUE,pattern="dataSNA.csv")

dfIgraphLong<-list.files("/Users/Diana/Documents/StageData/R",all.files=FALSE,full.names=TRUE,pattern="dataIgraph.csv")


dfSNAShort<-unlist(lapply(list.files("/Users/Diana/Documents/StageData/R",all.files=FALSE,full.names=FALSE,pattern="dataSNA.csv"),function(x) gsub("dataSNA.csv","", x,fixed=TRUE)))
dfrIgraphShort<-unlist(lapply(list.files("/Users/Diana/Documents/StageData/R",all.files=FALSE,full.names=FALSE,pattern="dataIgraph.csv"),function(x) gsub("dataIgraph.csv","", x,fixed=TRUE)))


d1<-read.csv(dfSNALong[1])
d2<-read.csv(dfIgraphLong[1])
d3<-gsub("graph_","",dfSNAShort[1],fixed=TRUE)
data<-cbind(d1,d2,d3)
for( i in 2:length(dfSNAShort))
{
  d1<-read.csv(dfSNALong[i])
  d2<-read.csv(dfIgraphLong[i])
  d3<-gsub("graph_","",dfSNAShort[i],fixed=TRUE)
  temp<-cbind(d1,d2,d3)
  data<-rbind(data,temp)
}

write.csv(data,file="GraphData.csv")
#View(data)
