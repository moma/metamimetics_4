

igraphFunctions<-function(g,filename)
{
#load("/Users/Diana/Documents/StageData/R/reachFunctions.rdata")
#library(igraph)
#previous steps
ind1<-which(V(g)$MY.RULE==1)
ind2<-which(V(g)$MY.RULE==2)
ind3<-which(V(g)$MY.RULE==3)
ind4<-which(V(g)$MY.RULE==4)
closeness<-centralization.closeness (g)
knn<-graph.knn(g)
triangles<-adjacent.triangles(g)
between<-centralization.betweenness (g,directed=FALSE)
degrees<-degree(g)
degreesNormal<-degree(g,normalized=TRUE)
NumAgents<-vcount(g)
eigen<-centralization.evcent(g)

run.info<-unlist(strsplit(V(g)$RUN.INFO[1],"*",fixed=TRUE))
dilemma<-as.numeric(run.info[2])
inicoop<-as.numeric(run.info[3])

cultural.constant<-as.numeric(run.info[5])
rewiring.prob<-as.numeric(run.info[6])
init.neighbors<-as.numeric(run.info[7])
connection.prob<-as.numeric(run.info[8])
sf.exponent<-as.numeric(run.info[9])
num.agents<-as.numeric(run.info[12])

random.init<-run.info[10]
load.topo<-run.info[11]
replacement<-run.info[4]
topology<-run.info[1]
runInfo<-paste(random.init,load.topo,replacement,topology,sep=".")

#LOCAL
#proportions
maxi<-length(ind1)*100/NumAgents
mini<-length(ind2)*100/NumAgents
conf<-length(ind3)*100/NumAgents
anti<-length(ind4)*100/NumAgents

#age 
ages<-V(g)$AGE
meanages<-mean(V(g)$AGE)
SDages<-sd(V(g)$AGE)
ageMaxi<-mean(ages[ind1])
ageMini<-mean(ages[ind2]) 
ageConf<-mean(ages[ind3])  
ageAnti<-mean(ages[ind4])  
SDageMaxi<-sd(ages[ind1])
SDageMini<-sd(ages[ind2]) 
SDageConf<-sd(ages[ind3])  
SDageAnti<-sd(ages[ind4])  


#cooperation
ind<-which(V(g)$COOPERATE==TRUE)
cooperationRate<- length(ind) *100/ NumAgents
coopMaxi<-length(intersect(ind,ind1))*100/length(ind1)
coopMini<-length(intersect(ind,ind2))*100/length(ind2)
coopConf<-length(intersect(ind,ind3))*100/length(ind3)
coopAnti<-length(intersect(ind,ind4))*100/length(ind4)
gcoopMaxi<-length(intersect(ind,ind1))*100/NumAgents
gcoopMini<-length(intersect(ind,ind2))*100/NumAgents
gcoopConf<-length(intersect(ind,ind3))*100/NumAgents
gcoopAnti<-length(intersect(ind,ind4))*100/NumAgents

#satisfaction 
satisfactionRate<-mean(V(g)$SATISFACTION2)*100
satMaxi<-mean(V(g)$SATISFACTION2[ind1])*100 
satMini<-mean(V(g)$SATISFACTION2[ind2]) *100 
satConf<-mean(V(g)$SATISFACTION2[ind3])*100  
satAnti<-mean(V(g)$SATISFACTION2[ind4])*100  

#degree 
degreeMaxi<-mean(degrees[ind1]) 
degreeMini<-mean(degrees[ind2]) 
degreeConf<-mean(degrees[ind3]) 
degreeAnti<-mean(degrees[ind4]) 
NdegreeMaxi<-mean(degreesNormal[ind1]) 
NdegreeMini<-mean(degreesNormal[ind2]) 
NdegreeConf<-mean(degreesNormal[ind3]) 
NdegreeAnti<-mean(degreesNormal[ind4]) 


#cluster 
clustering<-transitivity(g,type="local",isolates="zero")
clusterMaxi<-mean(clustering[ind1]) 
clusterMini<-mean(clustering[ind2]) 
clusterConf<-mean(clustering[ind3]) 
clusterAnti<-mean(clustering[ind4]) 



#betweeness 
betweenvertex<-between$res
betweenMaxi<-mean(betweenvertex[ind1]) 
betweenMini<-mean(betweenvertex[ind2]) 
betweenConf<-mean(betweenvertex[ind3]) 
betweenAnti<-mean(betweenvertex[ind4]) 

#prank
pagerank<-page.rank(g,directed=FALSE)$vector
prMaxi<-mean(pagerank[ind1]) 
prMini<-mean(pagerank[ind2]) 
prConf<-mean(pagerank[ind3]) 
prAnti<-mean(pagerank[ind4]) 


#eigen
eigenvertex<-eigen$vector
eigenMaxi<-mean(eigenvertex[ind1]) 
eigenMini<-mean(eigenvertex[ind2]) 
eigenConf<-mean(eigenvertex[ind3]) 
eigenAnti<-mean(eigenvertex[ind4]) 

#close
closenessvertex<-closeness$res
closeMaxi<-mean(closenessvertex[ind1]) 
closeMini<-mean(closenessvertex[ind2]) 
closeConf<-mean(closenessvertex[ind3]) 
closeAnti<-mean(closenessvertex[ind4]) 

#changes
changes<-V(g)$N.CHANGES
changesMaxi<-mean(changes[ind1]) 
changesMini<-mean(changes[ind2]) 
changesConf<-mean(changes[ind3]) 
changesAnti<-mean(changes[ind4]) 

#timerule
timerule<-V(g)$TIME.RULE
timeruleMaxi<-mean(timerule[ind1]) 
timeruleMini<-mean(timerule[ind2]) 
timeruleConf<-mean(timerule[ind3]) 
timeruleAnti<-mean(timerule[ind4]) 

#timebehavior
timebehavior<-V(g)$TIME.BEHAVIOR
timebehaviorMaxi<-mean(timebehavior[ind1]) 
timebehaviorMini<-mean(timebehavior[ind2]) 
timebehaviorConf<-mean(timebehavior[ind3]) 
timebehaviorAnti<-mean(timebehavior[ind4]) 


#bonacich
bonacich<-bonpow(g)
bonacichMaxi<-mean(bonacich[ind1]) 
bonacichMini<-mean(bonacich[ind2]) 
bonacichConf<-mean(bonacich[ind3]) 
bonacichAnti<-mean(bonacich[ind4]) 

#eccentricity
eccentricity<-eccentricity(g)
eccentricityMaxi<-mean(eccentricity[ind1]) 
eccentricityMini<-mean(eccentricity[ind2]) 
eccentricityConf<-mean(eccentricity[ind3]) 
eccentricityAnti<-mean(eccentricity[ind4]) 

#authority
authority<-authority.score(g)$vector
authorityMaxi<-mean(authority[ind1]) 
authorityMini<-mean(authority[ind2]) 
authorityConf<-mean(authority[ind3]) 
authorityAnti<-mean(authority[ind4]) 

#hub for undirected matrices equals the authority score 
#hub<-hub.score(g)$vector
#hubMaxi<-mean(hub[ind1]) 
#hubMini<-mean(hub[ind2]) 
#hubConf<-mean(hub[ind3]) 
#hubAnti<-mean(hub[ind4]) 

#Reach2
Reach2<-reach2(g)
Reach2Maxi<-mean(Reach2[ind1]) 
Reach2Mini<-mean(Reach2[ind2]) 
Reach2Conf<-mean(Reach2[ind3]) 
Reach2Anti<-mean(Reach2[ind4]) 

#Reach3
Reach3<-reach3(g)
Reach3Maxi<-mean(Reach3[ind1]) 
Reach3Mini<-mean(Reach3[ind2]) 
Reach3Conf<-mean(Reach3[ind3]) 
Reach3Anti<-mean(Reach3[ind4]) 

#DReach
DWreach<-dwreach(g)
dwreachMaxi<-mean(DWreach[ind1]) 
dwreachMini<-mean(DWreach[ind2]) 
dwreachConf<-mean(DWreach[ind3]) 
dwreachAnti<-mean(DWreach[ind4]) 


##neighbor stuff
allneighbors<-lapply( (1:NumAgents), function(x) neighbors(g,x))


#knn (degree of neighbors)
averageNNdegree<-knn$knn
averageNNdegreeMaxi<-mean(averageNNdegree[ind1]) 
averageNNdegreeMini<-mean(averageNNdegree[ind2]) 
averageNNdegreeConf<-mean(averageNNdegree[ind3]) 
averageNNdegreeAnti<-mean(averageNNdegree[ind4]) 
SDNNdegreeMaxi<-sd(averageNNdegree[ind1]) 
SDNNdegreeMini<-sd(averageNNdegree[ind2]) 
SDNNdegreeConf<-sd(averageNNdegree[ind3]) 
SDNNdegreeAnti<-sd(averageNNdegree[ind4]) 


#ec of neighbors
#eigenvertex<-eigen$vector
x<-unlist(lapply(allneighbors,function(x) mean(eigenvertex[x])))
eigenNNmaxi<-mean(x[ind1])
eigenNNmini<-mean(x[ind2])
eigenNNconf<-mean(x[ind3])
eigenNNanti<-mean(x[ind4])
SDeigenNNmaxi<-sd(x[ind1])
SDeigenNNmini<-sd(x[ind2])
SDeigenNNconf<-sd(x[ind3])
SDeigenNNanti<-sd(x[ind4])


#bc of neighbors
#betweenvertex<-between$res
x<-unlist(lapply(allneighbors,function(x) mean(betweenvertex[x])))
betweenNNmaxi<-mean(x[ind1])
betweenNNmini<-mean(x[ind2])
betweenNNconf<-mean(x[ind3])
betweenNNanti<-mean(x[ind4])
SDbetweenNNmaxi<-sd(x[ind1])
SDbetweenNNmini<-sd(x[ind2])
SDbetweenNNconf<-sd(x[ind3])
SDbetweenNNanti<-sd(x[ind4])

#cc of neighbors
#clustering<-transitivity(g,type="local",isolates="zero")
x<-unlist(lapply(allneighbors,function(x) mean(clustering[x])))
clusterNNmaxi<-mean(x[ind1])
clusterNNmini<-mean(x[ind2])
clusterNNconf<-mean(x[ind3])
clusterNNanti<-mean(x[ind4])
SDclusterNNmaxi<-sd(x[ind1])
SDclusterNNmini<-sd(x[ind2])
SDclusterNNconf<-sd(x[ind3])
SDclusterNNanti<-sd(x[ind4])


#pr of neighbors
#pagerank<-page.rank(g,directed=FALSE)$vector
x<-unlist(lapply(allneighbors,function(x) mean(pagerank[x])))
prNNmaxi<-mean(x[ind1])
prNNmini<-mean(x[ind2])
prNNconf<-mean(x[ind3])
prNNanti<-mean(x[ind4])
SDprNNmaxi<-sd(x[ind1])
SDprNNmini<-sd(x[ind2])
SDprNNconf<-sd(x[ind3])
SDprNNanti<-sd(x[ind4])


#closeness of neighbors
#closenessvertex<-closeness$res
x<-unlist(lapply(allneighbors,function(x) mean(closenessvertex[x])))
closeNNmaxi<-mean(x[ind1])
closeNNmini<-mean(x[ind2])
closeNNconf<-mean(x[ind3])
closeNNanti<-mean(x[ind4])
SDcloseNNmaxi<-sd(x[ind1])
SDcloseNNmini<-sd(x[ind2])
SDcloseNNconf<-sd(x[ind3])
SDcloseNNanti<-sd(x[ind4])


#bonacich neighbors
#bonacich<-bonpow(g)
x<-unlist(lapply(allneighbors,function(x) mean(bonacich[x])))
bonacichNNmaxi<-mean(x[ind1])
bonacichNNmini<-mean(x[ind2])
bonacichNNconf<-mean(x[ind3])
bonacichNNanti<-mean(x[ind4])
SDbonacichNNmaxi<-sd(x[ind1])
SDbonacichNNmini<-sd(x[ind2])
SDbonacichNNconf<-sd(x[ind3])
SDbonacichNNanti<-sd(x[ind4])

#eccentricity of neighbors
#eccentricity<-eccentricity(g)
x<-unlist(lapply(allneighbors,function(x) mean(eccentricity[x])))
eccentricityNNmaxi<-mean(x[ind1])
eccentricityNNmini<-mean(x[ind2])
eccentricityNNconf<-mean(x[ind3])
eccentricityNNanti<-mean(x[ind4])
SDeccentricityNNmaxi<-sd(x[ind1])
SDeccentricityNNmini<-sd(x[ind2])
SDeccentricityNNconf<-sd(x[ind3])
SDeccentricityNNanti<-sd(x[ind4])

#authority neighbors
#authority<-authority.score(g)$vector
x<-unlist(lapply(allneighbors,function(x) mean(authority[x])))
authorityNNmaxi<-mean(x[ind1])
authorityNNmini<-mean(x[ind2])
authorityNNconf<-mean(x[ind3])
authorityNNanti<-mean(x[ind4])
SDauthorityNNmaxi<-sd(x[ind1])
SDauthorityNNmini<-sd(x[ind2])
SDauthorityNNconf<-sd(x[ind3])
SDauthorityNNanti<-sd(x[ind4])


#hub neighbors
#hub<-hub.score(g)$vector
#x<-unlist(lapply(allneighbors,function(x) mean(hub[x])))
#hubNNmaxi<-mean(x[ind1])
#hubNNmini<-mean(x[ind2])
#hubNNconf<-mean(x[ind3])
#hubNNanti<-mean(x[ind4])
#SDhubNNmaxi<-sd(x[ind1])
#SDhubNNmini<-sd(x[ind2])
#SDhubNNconf<-sd(x[ind3])
#SDhubNNanti<-sd(x[ind4])



###GLOBAL PROPERTIES
assortativityg<-assortativity.degree(g,directed=FALSE)
diameter<-diameter(g, directed=FALSE)
radius<-radius(g)
girth<-girth(g)$girth
density<-graph.density(g)
meanPath<-average.path.length(g,directed=FALSE)
globalClustering<-transitivity(g,type="undirected")
closenessgraph<-closeness$centralization
betweengraph<-between$centralization
eigengraph<-eigen$centralization
pw<-power.law.fit(degrees)$alpha
assortCoop<-assortativity(g,V(g)$COOPERATE,directed=FALSE)
assortRule<-assortativity(g,V(g)$MY.RULE,directed=FALSE)
assortNomRule<-assortativity.nominal(g,V(g)$MY.RULE,directed=FALSE)

###in case of renovation of population

if ( max(V(g)$CHANCES.IMITATIONS) > 0) 
{
  #age at death 
  deathage<-V(g)$AGE.AT.DEATH.LIST
  deathage<-lapply(deathage,function(x) gsub("[","",x,fixed=TRUE))
  deathage<-lapply(deathage,function(x) gsub("]","",x,fixed=TRUE))
  deathage<-unlist(lapply(deathage,function(x) as.numeric(unlist(strsplit(x, " ", fixed=TRUE)))))
  #n.changes list 
  nchangeslist<-V(g)$N.CHANGES.LIST
  nchangeslist<-lapply(nchangeslist,function(x) gsub("[","",x,fixed=TRUE))
  nchangeslist<-lapply(nchangeslist,function(x) gsub("]","",x,fixed=TRUE))
  nchangeslist<-unlist(lapply(nchangeslist,function(x) as.numeric(unlist(strsplit(x, " ", fixed=TRUE)))))
  #rule at death list 
  deathrulelist<-V(g)$RULE.AT.DEATH.LIST
  deathrulelist<-lapply(deathrulelist,function(x) gsub("[","",x,fixed=TRUE))
  deathrulelist<-lapply(deathrulelist,function(x) gsub("]","",x,fixed=TRUE))
  deathrulelist<-unlist(lapply(deathrulelist,function(x) as.numeric(unlist(strsplit(x, " ", fixed=TRUE)))))
  
  
  #time.behavior list 
  timebehaviorlist<-V(g)$TIME.BEHAVIOR.LIST
  timebehaviorlist<-lapply(timebehaviorlist,function(x) gsub("[","",x,fixed=TRUE))
  timebehaviorlist<-lapply(timebehaviorlist,function(x) gsub("]","",x,fixed=TRUE))
  timebehaviorlist<-unlist(lapply(timebehaviorlist,function(x) as.numeric(unlist(strsplit(x, " ", fixed=TRUE)))))
  
  #time.rule list 
  timerulelist<-V(g)$TIME.RULE.LIST
  timerulelist<-lapply(timerulelist,function(x) gsub("[","",x,fixed=TRUE))
  timerulelist<-lapply(timerulelist,function(x) gsub("]","",x,fixed=TRUE))
  timerulelist<-unlist(lapply(timerulelist,function(x) as.numeric(unlist(strsplit(x, " ", fixed=TRUE)))))
  ind1<-which(deathrulelist==1)
  ind2<-which(deathrulelist==2)
  ind3<-which(deathrulelist==3)
  ind4<-which(deathrulelist==4)
  deathageMaxi<-mean(deathage[ind1])
  deathageMini<-mean(deathage[ind2])
  deathageConf<-mean(deathage[ind3])
  deathageAnti<-mean(deathage[ind4])
  nchangesMaxi<-mean(nchangeslist[ind1])
  nchangesMini<-mean(nchangeslist[ind2])
  nchangesConf<-mean(nchangeslist[ind3])
  nchangesAnti<-mean(nchangeslist[ind4])
  timebehaviorlMaxi<-mean(timebehaviorlist[ind1])
  timebehaviorlMini<-mean(timebehaviorlist[ind2])
  timebehaviorlConf<-mean(timebehaviorlist[ind3])
  timebehaviorlAnti<-mean(timebehaviorlist[ind4])
  timerulelMaxi<-mean(timerulelist[ind1])
  timerulelMini<-mean(timerulelist[ind2])
  timerulelConf<-mean(timerulelist[ind3])
  timerulelAnti<-mean(timerulelist[ind4])
  SDdeathageMaxi<-sd(deathage[ind1])
  SDdeathageMini<-sd(deathage[ind2])
  SDdeathageConf<-sd(deathage[ind3])
  SDdeathageAnti<-sd(deathage[ind4])
  SDnchangesMaxi<-sd(nchangeslist[ind1])
  SDnchangesMini<-sd(nchangeslist[ind2])
  SDnchangesConf<-sd(nchangeslist[ind3])
  SDnchangesAnti<-sd(nchangeslist[ind4])
  SDtimebehaviorlMaxi<-sd(timebehaviorlist[ind1])
  SDtimebehaviorlMini<-sd(timebehaviorlist[ind2])
  SDtimebehaviorlConf<-sd(timebehaviorlist[ind3])
  SDtimebehaviorlAnti<-sd(timebehaviorlist[ind4])
  SDtimerulelMaxi<-sd(timerulelist[ind1])
  SDtimerulelMini<-sd(timerulelist[ind2])
  SDtimerulelConf<-sd(timerulelist[ind3])
  SDtimerulelAnti<-sd(timerulelist[ind4])
}








###SHUFFLING
#suffling and retake measures (after looking at interesting measures)
V(g)$MY.RULE<-sample.int(4,NumAgents,replace=TRUE)
write.graph(g,paste(filename,"Shuffled", ".graphml",sep=""),format="graphml")




###create data.frame
lista<-ls()
index1<-which(unlist(lapply(lista,function(x) length(get(x))))==1)
index2<-which(unlist(lapply(lista,function(x) class(get(x))))=="numeric")
lista<-lista[intersect(index1,index2)]
data<-cbind(get(lista[1]),get(lista[2]))
for(i in 3:length(lista))
{
  data<-cbind(data,get(lista[i]))  
}
data<-cbind(data,runInfo)
data<-as.data.frame(data)
names(data)<-c(lista,"runInfo")

#tab<-read.table("/Users/Diana/Documents/StageData/R/outputs/dataFrames/dataIgraph.csv")
#tab<-rbind(tab,data)
write.csv(data,file=paste(filename,"dataIgraph.csv",sep=""))
}





SnaFunctions<-function(g,filename,y,ind1,ind2,ind3,ind4)
{  
#  library(sna)
#  library(qgraph)
  
  #another centrality 
  Acentral<-graphcent(as.matrix(y))
  AcentralMaxi<-mean(Acentral[ind1]) 
  AcentralMini<-mean(Acentral[ind2]) 
  AcentralConf<-mean(Acentral[ind3]) 
  AcentralAnti<-mean(Acentral[ind4]) 
  
  #load
  load<-loadcent(as.matrix(y))
  loadMaxi<-mean(load[ind1]) 
  loadMini<-mean(load[ind2]) 
  loadConf<-mean(load[ind3]) 
  loadAnti<-mean(load[ind4]) 
  
  #prestige
  prestige<-prestige(as.matrix(y))
  prestigeMaxi<-mean(prestige[ind1]) 
  prestigeMini<-mean(prestige[ind2]) 
  prestigeConf<-mean(prestige[ind3]) 
  prestigeAnti<-mean(prestige[ind4]) 
  
  
  #stress 
  stress<-stresscent(as.matrix(y))
  stressMaxi<-mean(stress[ind1]) 
  stressMini<-mean(stress[ind2]) 
  stressConf<-mean(stress[ind3]) 
  stressAnti<-mean(stress[ind4]) 
  
  
  #information
  information<-infocent(as.matrix(y))
  informationMaxi<-mean(information[ind1]) 
  informationMini<-mean(information[ind2]) 
  informationConf<-mean(information[ind3]) 
  informationAnti<-mean(information[ind4]) 
  
  
  
  smallworld<-smallworldness(g)
  smallworld<-smallworld[1]
  
  
  
  ###create data.frame
  lista<-ls()
  index1<-which(unlist(lapply(lista,function(x) length(get(x))))==1)
  index2<-which(unlist(lapply(lista,function(x) class(get(x))))=="numeric")
  lista<-lista[intersect(index1,index2)]
  data<-cbind(get(lista[1]),get(lista[2]))
  for(i in 3:length(lista))
  {
    data<-cbind(data,get(lista[i]))  
  }
  data<-as.data.frame(data)
  names(data)<-lista
  
#  tab<-read.table("/Users/Diana/Documents/StageData/R/outputs/dataFrames/dataSna.csv")
#  tab<-rbind(tab,data)
write.csv(data,file=paste(filename,"dataSNA.csv",sep=""))

}



# adapted from http://www.shizukalab.com/toolkits/sna/node-level-calculations
reach2=function(x){
  r=vcount(x)
  n=neighborhood(x,2)
  l=unlist(lapply(n,function(x) length(x)/r))
}

# adapted from http://www.shizukalab.com/toolkits/sna/node-level-calculations
reach3=function(x){
  r=vcount(x)
  n=neighborhood(x,3)
  l=unlist(lapply(n,function(x) length(x)/r))
}


# from http://www.shizukalab.com/toolkits/sna/node-level-calculations
dwreach=function(x){
  distances=shortest.paths(x) #create matrix of geodesic distances
  diag(distances)=1 # replace the diagonal with 1s
  weights=1/distances # take the reciprocal of distances
  apply(weights,1,sum) # sum for each node (row)
}


#########################################
#after generating multiple outputs:
#AUTOMATIZE: do dataframe and plotting functions with already done scripts 

#########################################
###for interseting measures do graph2ml analisis. after first results
###OTHER POSSIBLE MEASURES
###pairwise similarities 
#similarity among vertices depending on connections 
#s<-similarity.jaccard(g) ##comon neighbors divides by vertices of both 
#s<-similarity.dice(g) ##2x number of common neighbors over the sum of degrees of vertices 
#similarity.invlogweighted common neighbors weigthed by the inverse log of their degrees 
#SIR model and outputs summary for gra
#famous graphs?
###community stuff 
#edge.betweenness.community
#fast.greedy.community
#infomap community
#graph.complementer
#independent vertex set
#label.propagation.community
#leading-eigenvector.community
#modularity
#multilevel.community
#cliques
#communities
#modified versions of betweeness and clustering for flow of energy acc to fleischer and brenes although flow betweenness takes forever tocompute on 100 nodes.. flowbet(as.matrix(y))


createStats<-function(graphs,graphs2)
{
  for( i in 1:length(graphs))
  {
    library(igraph)
    g<-read.graph(graphs[i] , format="graphml")
    igraphFunctions(g,graphs2[i])

    y<-get.adjacency(g)
    ind1<-which(V(g)$MY.RULE==1)
    ind2<-which(V(g)$MY.RULE==2)
    ind3<-which(V(g)$MY.RULE==3)
    ind4<-which(V(g)$MY.RULE==4)
    
    detach(package:igraph)
    library(sna)
    library(qgraph)
    SnaFunctions(g,graphs2[i],y,ind1,ind2,ind3,ind4)
    detach(package:sna)
    detach(package:qgraph)
  }
}


save(createStats,file="createStats.rdata")
save(SnaFunctions,file="SnaFunctions.rdata")
save(igraphFunctions,file="igraphFunctions.rdata")
save(dwreach, reach2, reach3, file="reachFunctions.rdata")

