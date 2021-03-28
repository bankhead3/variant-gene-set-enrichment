# 20170201 arb
# fdr adjust pvalues
# adjust p-values for multiple testing

options(stringsAsFactors = FALSE)
inFile1 = 'intermediate/07.txt' # enrichments
outFile1 = 'intermediate/08.txt'

data1 = read.delim(inFile1)
threshold = 0.01

data1$qval = data1$pval

sources = unique(sort((data1$source)))
for(source in sources) { 
  # gather pvalues, fdr adjust and save them to fdr matrix
  idx = which(data1$source == source)    
  pvals = data1$pval[idx]
  data1$qval[idx] = p.adjust(pvals,method='fdr')
}

data1 = data1[order(data1$qval,-data1$numPatients),]
data1a = data.frame(isSig = ifelse(data1$qval < threshold, 'Y','N'),data1)

write.table(data1a,file=outFile1,sep="\t",quote=F,row.names=F)

