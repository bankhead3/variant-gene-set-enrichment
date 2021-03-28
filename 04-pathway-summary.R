# 20180516 arb
# create a per gene summary of the number of samples per gene geneset

options(stringsAsFactors=F)

library(dplyr)

inFile1 = 'intermediate/03.txt'
outFile1 = 'intermediate/04.txt'

data1 = read.delim(inFile1)

# get patient pathways
data1a = unique(select(data1,patient,id,name)) 

# get frequencies
data1b = table(data1a$id)                  
data1c = data.frame(id=names(data1b),numPatients=as.vector(data1b)) 

# get pathway annotations
data1d = unique(select(data1,name,id,source,subtype))

data1e = merge(data1c,data1d,by='id')
stopifnot(nrow(data1c) == nrow(data1d))
stopifnot(nrow(data1c) == nrow(data1b))

data1e = data1e[order(data1e$numPatients,decreasing=T),]

# add in patients and genes mutated in each pathway
data1e$patients = data1e$mutGenes = data1e$source
for(c1 in 1:nrow(data1e)) { 
  id = data1e$id[c1]       

  patients = paste(sort(unique(data1$patient[data1$id == id])),collapse=',')
  mutGenes = paste(sort(unique(data1$gene[data1$id == id])),collapse=',')

  data1e$patients[c1] = patients
  data1e$mutGenes[c1] = mutGenes
}

write.table(data1e,outFile1,quote=F,row.names=F,sep="\t")
