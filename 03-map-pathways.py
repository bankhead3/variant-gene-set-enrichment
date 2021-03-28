#!/usr/bin/python
# map variant genes to gene sets

import sys
sys.path.append('utils')
import myUtils as mu

import os
import re

inFile1 = 'intermediate/02.txt'
inFiles = ['input/go.txt']
outFile1 = 'intermediate/03.txt'

(records1,header1,keys1) = mu.readRecords(inFile1,['patient','gene'])

# map entrez to genes
entrez2gene = dict(list(set([(records1[key]['entrez'],records1[key]['gene']) for key in keys1])))
entrez2keys = dict()
for key in keys1:
    entrez = records1[key]['entrez']
    if entrez in entrez2keys:
        entrez2keys[entrez].append(key)
    else:
        entrez2keys[entrez] = [key]

# open file
with open(outFile1,'w') as out1:
    header = ['patient','cluster','entrez','gene','source','subtype','id','name']
    out1.write('\t'.join(header) + '\n')

    # for each gene set source
    for inFile in inFiles:
        print inFile

        parse1 = inFile.split('/')
        source = parse1[-1].replace('.txt','')

        (records,Null,orderedKeys) = mu.readRecords(inFile,['id','entrez'])
        print 'reading %s gene set genes (%d)' % (source,len(orderedKeys))        

        # we only include entries that can be mapped to hgnc
        for myKey in orderedKeys:
            record = records[myKey]
            id = record['id']
            name = record['name']
            entrez = record['entrez']

            if entrez in entrez2keys:

                # only enrich for BP GO categories
                if source == 'go':
                    subtype = record['ontology']
                    if subtype != 'BP':
                        continue

                elif source == 'kegg':
                    id = record['organism'] + record['id']
                    subtype = 'kegg'

                for entrezKey in entrez2keys[entrez]:
                    gene = records1[entrezKey]['gene']
                    patient = records1[entrezKey]['patient']
                    cluster = records1[entrezKey]['cluster']

                    lineOut = [patient,cluster,entrez,gene,source,subtype,id,name]
                    out1.write('\t'.join(lineOut) + '\n')
