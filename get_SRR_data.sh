#!/bin/bash


mkdir /workdir/hcm59/Ecoli/raw_data/PRJNA503851
cd /workdir/hcm59/Ecoli/raw_data/PRJNA503851

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/Ecoli/PRJNA503851_SraAccList.txt | xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
