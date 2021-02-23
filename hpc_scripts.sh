#!/bin/bash


# work_dir = "/workdir/hcm59/Ecoli/raw_data/PRJNA318591"


fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/SRR_Acc_List_PRJNA318591.txt | xargs -n 1 bash get_SRR_data.sh

# command to run QC
export PATH=/workdir/miniconda3/bin:$PATH
source activate bacWGS
bacWGS_readQC.py --threads 4 *.fastq > PRJNA318591_readQC.tsv


# command to run snp-sites
source activate snippy
snp-sites -mv -o Ecoli_snps core_gene_alignment.aln


# command to run assembly and screening program:
export PATH=/workdir/miniconda3/bin:$PATH
source activate bacWGS
bacWGS_pipeline.py  -l -n 3 -p 9 -m 60 --amr *_1.fastq &>bacWGS_pipeline.log &


# test on single sample
export PATH=/workdir/miniconda3/bin:$PATH
source activate bacWGS
bacWGS_pipeline.py -l -a SRR13450825_2.fastq


#### IQ tree
# put miniconda in your path
export PATH=/workdir/miniconda3/bin:$PATH
source activate iqtree #load in iqtree environment
iqtree -nt 4 -s /workdir/hcm59/Ecoli/SNPs/core_gene_alignment.aln
  # nt is number of threads
  # s specifies alignment file to use
