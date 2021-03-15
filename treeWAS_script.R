### Script for running treeWAS on the AHDC server

## First need to load in/install treeWAS
## install devtools, if necessary:
install.packages("devtools", dep=TRUE)
library(devtools)

## install treeWAS from github:
install_github("caitiecollins/treeWAS", build_vignettes = TRUE)
library(treeWAS)

## Read data from file:
eColiSNPs <- read.dna(file = "/local/workdir/hcm59/Ecoli/R_analyses/Ecoli_dog_core_snps.fasta", format = "fasta")
rownames(eColiSNPs)
colnames(eColiSNPs)
str(eColiSNPs)
## Convert: 
eColiMat <- DNAbin2genind(eColiSNPs)@tab


anno <- read.csv("/local/workdir/hcm59/Ecoli/R_analyses/ecoli_dog_200contigs_w_panaroo_tag.csv",header=TRUE)
header <- colnames(anno)
header.want <- c(grep("Strain",header),grep("Assembly",header))
anno.want <- anno[header.want]
View(anno.want)

phenAll <- read.table("/local/workdir/hcm59/Ecoli/R_analyses/phenAll.txt")
eColirnames <- rownames(eColiMat)
eColirnames
eColirnames.sub <- substr(eColirnames, 1, regexpr("\\.", eColirnames)-1)
str(eColirnames.sub)
typeof(eColirnames.sub)
eColiMat2 <- eColiMat
rownames(eColiMat2) <- eColirnames.sub

all(rownames(names(phenAll)) %in% rownames(eColiMat2))

Phen <- phenAll
headr <- colnames(Phen)
headr.want <- c(grep("sample.ID",headr),grep("Assembly",headr), grep("INT",headr))
headr.want
phen.sub <- Phen[headr.want]
head(phen.sub)
names(phen.sub)[2]
typeof(phen.sub[2])
typeof(phen.sub[1])

library(dplyr)
library(reshape2)
# phen.Melt <- melt(Phen, id.vars=c("Assembly"),variable.name = "antibiotic", value.name = "INT",na.rm = TRUE)


# find all instances of "SUSC" and replace with 0
library(tidyverse)
phen.sub.0 <- phen.sub %>% mutate_if(is.atomic,funs(str_replace(., "SUSC", "0")))
phen.sub.0
# worked! # now do that to RESIST and convert NOINTP
phen.sub.01 <- phen.sub.0 %>%  mutate_if(is.atomic,funs(str_replace(., "RESIST", "1")))
phen.sub.01.1 <- phen.sub.01 %>%  mutate_if(is.atomic,funs(str_replace(., "NOINTP", "")))
phen.sub.01.2 <- phen.sub.01.1 %>%  mutate_if(is.atomic,funs(str_replace(., "INTER", "")))
View(phen.sub.01.2)
phen.sub.01.3 <- phen.sub.01.2 %>% mutate_all(na_if,"")


rownames(phen.sub.01.3) <- phenAll$Assembly
rownames(phen.sub.01.3)
View(phen.sub.01.3)
phen.sub.01.4 <- phen.sub.01.3[,2:104]
View(phen.sub.01.4)
str(phen.sub.01.4)

# phen.melt <- melt(phen.sub.01.4, id.vars=c("Assembly"),variable.name = "antibiotic", value.name = "INT",na.rm = TRUE)
phen.Amikacin <- phen.sub.01.4[,2]
names(phen.Amikacin) <- rownames(phen.sub.01.4)
View(phen.Amikacin)
typeof(phen.Amikacin)

phen.Amikacin2 <- as.vector(unlist(phen.Amikacin))
names(phen.Amikacin2) <- names(phen.Amikacin)

## Need files: phenotypic file, SNP file, tree file
phen_Ami <- read.table("/local/workdir/hcm59/Ecoli/R_analyses/phen_Amikacin.txt")
phen.Ami <- as.vector(unlist(phen_Ami))
names(phen.Ami) <- rownames(phen_Ami)
SNPs <- eColiMat2
Tree <- read.tree("/local/workdir/hcm59/Ecoli/R_analyses/Ecoli_snps.snp_sites.aln.treefile")
Tree$tip.label
Tree2 <- Tree
Tree2$tip.label <- substr(Tree$tip.label, 1, regexpr("\\.", Tree$tip.label)-1)
Tree2$tip.label
names(phen.Ami)

my.out <- treeWAS(snps = SNPs,
                  phen = phen.Ami,
                  tree = Tree2,
                  seed = 1)

