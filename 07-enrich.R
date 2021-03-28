# 20180608 arb
# read in null distribution per gene set id and compare to observed
# calculate p-value

options(stringsAsFactors=F)

inFile1 = 'intermediate/04.txt'
inFile2 = 'intermediate/06.txt'
outFile1 = 'intermediate/07.txt'

load = T
if(load) {
  data1 = read.delim(inFile1)
  data2 = read.delim(inFile2)
}

data2a = data2
rownames(data2a) = data2a$id
data2a$id = NULL
data2a = data.matrix(data2a)

ids = data1$id  # [1:10] # testing
#ids = 'hsa05224'  # testing
data1$expected = data1$pval = data1$n = data1$numPatients
for(c1 in 1:length(ids)) { 
  id = ids[c1]       
  print(paste0(c1, ' of ', length(ids)))
  null = data2a[id,]

  observed = data1$numPatients[data1$id == id]
  data1$expected[data1$id == id] = mean(null)
  data1$pval[data1$id == id] = sum(null >= observed)/length(null)  
  data1$n[data1$id == id] = length(null)
}

data1 = data1[order(data1$pval,-data1$numPatients),]

header = colnames(data1)
header = c(header[1:7],'pval','expected','n')
data1 = data1[,header]
write.table(data1,outFile1,quote=F,row.names=F,sep="\t")
