#!/bin/bash

myDate=$(date +%Y%m%d)
mkdir -p intermediate
mkdir -p output
mkdir -p input

if [ 1 == 1 ]; then 

# link to external input files
cmd="./01-pull-data.sh"
echo $cmd; eval $cmd

# get gene level patient mutations
cmd="Rscript 02-patient-table.R > intermediate/02.ROut"
echo $cmd; eval $cmd
utils/qc.sh intermediate/02.txt 1,2

cmd="./03-map-pathways.py"
echo $cmd; eval $cmd
utils/qc.sh intermediate/03.txt 1,3,7

# map to gene sets
cmd="Rscript 04-pathway-summary.R > intermediate/04.ROut"
echo $cmd; eval $cmd
utils/qc.sh intermediate/04.txt 1

# create a null distribution by shuffling gene labels
cmd="Rscript 05-create-null.R > intermediate/05.rout"
echo $cmd; eval $cmd

# count #'s of patients in null distribution 
cmd="Rscript 06-count-null.R > intermediate/06.rout"
echo $cmd; eval $cmd
utils/qc.sh intermediate/06.txt 1
fi
# calculate p-value
cmd="Rscript 07-enrich.R > intermediate/07.ROut"
echo $cmd; eval $cmd
utils/qc.sh intermediate/07.txt 1

cmd="Rscript 08-adjust.R > intermediate/08.ROut"
echo $cmd; eval $cmd
utils/qc.sh intermediate/08.txt 2

cmd="cp intermediate/08.txt output/resistantGenesetEnrichment$myDate.txt; utils/txt2excel.py output/resistantGenesetEnrichment$myDate.txt"
echo $cmd; eval $cmd
