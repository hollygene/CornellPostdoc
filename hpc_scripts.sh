#!/bin/bash


# work_dir = "/workdir/hcm59/Ecoli/raw_data/PRJNA318591"


fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/SRR_Acc_List_PRJNA318591.txt | xargs -n 1 bash get_SRR_data.sh

# command to run QC
export PATH=/workdir/miniconda3/bin:$PATH
source activate bacWGS
bacWGS_readQC.py --threads 4 *.fastq > PRJNA324573_readQC.tsv


# command to run snp-sites
export PATH=/workdir/miniconda3/bin:$PATH
source activate snippy
# mkdir /workdir/hcm59/Ecoli/SNPs/snp_sites
snp-sites -mvp -o /workdir/hcm59/Ecoli/SNPs/snp_sites/Ecoli_snpsGblocks /workdir/hcm59/Ecoli/SNPs/core_gene_alignment.aln-gb.fasta


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
iqtree -s /workdir/hcm59/Ecoli/SNPs/Ecoli_snps.subset.aln -m GTR+G+ASC -nt AUTO
  # nt is number of threads
  # s specifies alignment file to use
  # m specifies what model to use
  # GTR: most general substitution model
  # G: allows different sites to have different substitution rates
  # ASC: want IQTree to run ascertainment bias correction (necessary because SNP data)

workdir="/workdir/hcm59/Ecoli/SNPs"
### To use fasta FetchSeqs perl script
perl ${workdir}/Fasta_fetchseqs.pl -in ${workdir}/Ecoli_snps.snp_sites.aln \
  -m ${workdir}/samples_wanted.txt -file -out ${workdir}/Ecoli_snps.subset.aln \
  -regex -v


#Gblocks commands

export PATH=/programs/Gblocks_0.91b:$PATH

Gblocks /workdir/hcm59/Ecoli/SNPs/core_gene_alignment.aln -t=d
