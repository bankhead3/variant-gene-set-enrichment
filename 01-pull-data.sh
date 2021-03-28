#!/bin/bash
# link to external data

# patient variants
inFile1=details20180607.txt
outFile1=details.txt
cmd="cd input; ln -sf $inFile1 $outFile1; cd -"
echo $cmd; eval $cmd

# kegg pathway definitions
inFile1=go20180210.txt
outFile1=go.txt
cmd="cd input; ln -sf $inFile1 $outFile1; cd -"
echo $cmd; eval $cmd

