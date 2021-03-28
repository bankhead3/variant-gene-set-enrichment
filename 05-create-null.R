# 20180608 arb
# create null distribution to get a sense for what we would expect by chance.  shuffle genes

options(stringsAsFactors=F)

outDir = 'intermediate/null/'
n = 10000
n = 1000

sources = list()
sources[['go']] = 'input/go.txt'

# create output directories
if(!dir.exists(outDir)) { dir.create(outDir) }

for(c1 in seq_along(sources)) {
  set.seed(123)

  # figure out source, files directories, etc
  source = names(sources)[c1]
  file = sources[[c1]]
  sourceDir = paste0(outDir,source,'/')
  if(!dir.exists(sourceDir)) { dir.create(sourceDir) }

  print(source)

  data = read.delim(file)
  data = data[order(data$entrez,data$id),]
  universe = unique(data$entrez) 
  idx = match(data$entrez,universe)
  header = colnames(data)

  for(c1 in 1:n) { 
    print(c1)

    # shuffle yo universe
    universe.shuf = sample(universe)

    # create mapping
    mapping = data.frame(entrez=universe,new=universe.shuf)
    outFile = paste0(sourceDir,c1,'.txt')
    write.table(mapping,outFile,quote=F,sep="\t",row.names=F)    
  } 
}