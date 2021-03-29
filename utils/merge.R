# 20180323 arb
# combine together rows that map to the same original gene

options(stringsAsFactors=F)

# a slow way to combine rows common unique fields
myMerge = function(data1,uniques) {
  # construct unique data frame
  data1a = NULL
  for(myUnique in uniques) { 
    data1a = cbind(data1a,data1[[myUnique]])
  }
  data1a = unique(data.frame(data1a))
  colnames(data1a) = uniques

  # columns that need to be pasted
  nonUniques = colnames(data1)[!colnames(data1) %in% uniques]

  # reorder data1 such that unique columns are first	
  data1 = data1[,c(uniques,nonUniques)]

  # create a new data frame
  data1c = data.frame(matrix(NA,nrow(data1a),ncol(data1)))
  colnames(data1c) = colnames(data1)

  # iterate through unique rows and construct a new version of original data frame
  for(c1 in 1:nrow(data1a)) {
    row = data1a[c1,]
    data1b = merge(row,data1)  # join back to original

    # add in merged columns
    for(field in nonUniques) { 
      result = paste0(data1b[[field]],collapse=',')
      row[[field]] = result
    }

    # add to updated data frame
    data1c[c1,] = row
  }

  data1c = data.frame(data1c)
  return(data1c)
}

# example call:
# uniques = c('gene','entrez','hgnc_id')
# result = myMerge(data1,uniques)



