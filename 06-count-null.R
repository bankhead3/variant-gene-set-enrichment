# 20180608 arb
# create a table with the number of observed shuffled gene set memberships

options(stringsAsFactors=F)
library(dplyr)

inDir = 'intermediate/null/'
inFile1 = 'intermediate/02.txt'  # patient table
outFile1 = 'intermediate/06.txt'
parallel = T
n = 10000
n = 1000 

sources = list()
sources[['go']] = 'input/go.txt'
nulls = list()

data1 = read.delim(inFile1)  # patient measures
data1 = select(data1,entrez,patient)

header = c('name','id','source','subtype','observed','pval','n')
out = data.frame(matrix(NA,0,length(header)))

# map patients to pathway data
processIteration = function(c2,sourceDir, data, data1, ids)  {
  library(dplyr)

  print(c2)

  # map to shuffled data
  inFile = paste0(sourceDir,c2,'.txt')
  mapping = read.delim(inFile)
  data.shuf = merge(data,mapping,by='entrez')
  data.shuf$entrez = data.shuf$new
  data.shuf$new = NULL

  # join to patients
  data1a = merge(data1,data.shuf,by='entrez')
  data1b = unique(select(data1a,id,patient))  # we use unique to allow a patient to contribute only once

  # count yo occurences
  data1c = data.frame(table(data1b$id))
  colnames(data1c) = c('id',c2)

  # add to the matrix
  counts = merge(ids,data1c,by='id',all.x = T)
  idx = match(counts$id,ids$id)
  counts = counts[idx,]
  counts$id = NULL

  # return count vector
  return(counts)
}

for(c1 in seq_along(sources)) {

  # figure out source, files directories, etc
  source = names(sources)[c1]
  sourceDir = paste0(inDir,source,'/')
  data = read.delim(sources[[source]])

  if(source == 'kegg') { data$id = paste0(data$organism,sprintf('%05d', data$id)) } 

  ids = sort(unique(data$id))
  print(source)

  ids = data.frame(id=ids)
  # ** non-parallel **
  if(!parallel) { 
    # read and gather null distrubtion mutations 
    results = do.call(cbind,lapply(1:n, processIteration, sourceDir, data, data1,ids))
    results = data.frame(ids,results)
    colnames(results) = c('id',1:n)
    results[is.na(results)] = 0
  }
  else { 
    # ** parallel ** 
    library(parallel) 
    numCores = detectCores() - 1
    myCluster = makeCluster(numCores)

    # read and gather null distrubtion mutations 
    results = do.call(cbind,parLapply(myCluster,1:n, processIteration, sourceDir, data, data1,ids))
    results = data.frame(ids,results)
    colnames(results) = c('id',1:n)
    results[is.na(results)] = 0

    stopCluster(myCluster)
  }
  # *** 

  out = rbind(out,results)
} 

write.table(out,outFile1,quote=F,sep="\t",row.names=F)