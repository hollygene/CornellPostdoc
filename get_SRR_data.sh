#!/bin/bash


cd /workdir/hcm59/Ecoli/SNPs/raw_fastqs

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/Ecoli/phenoDataSamplesAcc_short.txt| xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
