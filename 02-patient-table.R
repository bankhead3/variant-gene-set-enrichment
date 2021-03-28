# 20180516 arb
# create patient oriented table of variants

options(stringsAsFactors=F)

library(dplyr)
source('utils/merge.R')

inFile1 = 'input/details.txt'
outFile1 = 'intermediate/02.txt'

data1 = read.delim(inFile1)

data1a = unique(select(data1,patient,gene,entrez,isSig,cluster))
data1a = unique(data1a[data1a$isSig == 'Y',])

data1b = myMerge(data1a,c('patient','gene'))

write.table(data1b,outFile1,quote=F,row.names=F,sep="\t")
