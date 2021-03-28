# variant-gene-set-enrichment
Written by Armand Bankhead

This code takes as input rectal cancer patient variant calls from the paper "Rectal cancer sub-clones respond differentially to neoadjuvant therapy" https://pubmed.ncbi.nlm.nih.gov/31521947/ published in Neoplasia in 2019.  While we ended up publishing a different systems biology analysis using HotNet2, this earlier analysis provided insight to gene sets enriched for patients with resistant variant mutations.  

This code tests the null hypothesis that the number of patients with variants in 2,416 GO biological process gene sets occurs randomly by comparing the observed number of patient variant genes belonging within a gene set to a null distribution.  The null distribution is created by randomly shuffling genes in gene sets and counting the number of patients with variants in each gene set.  The resulting p-values were considered significant enough to reject the null hypothesis when after FDR multiple testing-correction the q-value was < 0.01.  27 gene sets were considered significantly enriched including GO:0007265 Ras protein signal transduction, GO:0071456 cellular response to hypoxia, and GO:0030330 DNA damage response, signal transduction by p53 class mediator.  

This permutation simulation approach is different from typical gene set enrichment in that it focuses on the enrichment of the number of patients with variants in a gene set instead of the enrichment of genes with variants in a gene set.  The motivation for this enrichment analysis was that for variants contributing to a pathway's dysfunction, we would expect only a single mutation variant to be necessary to disable a pathway for a given patient.

# input files
- rectal cancer patient variants
- GO biological process gene sets

# outputs
- excel spreadsheet with a list of enriched genesets, patients

# software requirements:
- linux environment with bash shell
- R
- R packages: dplyr, parallel
- python2 
