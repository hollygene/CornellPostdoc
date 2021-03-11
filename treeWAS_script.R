### Script for running treeWAS on the AHDC server

## First need to load in/install treeWAS
## install devtools, if necessary:
install.packages("devtools", dep=TRUE)
library(devtools)

## install treeWAS from github:
install_github("caitiecollins/treeWAS", build_vignettes = TRUE)
library(treeWAS)

## Need files: phenotypic file, SNP file, tree file
phen_Ami <- read.table("/local/workdir/hcm59/CornellPostdoc/phen_Amikacin.txt")
SNPs <- read.table("/local/workdir/hcm59/CornellPostdoc/subsetEcoliSNPs.txt")
Tree <- read.tree("/local/workdir/hcm59/CornellPostdoc/Ecoli_snps.snp_sites.aln.treefile")

my.out <- treeWAS(snps = SNPs,
                  phen = phen_Ami,
                  tree = Tree,
                  seed = 1)
