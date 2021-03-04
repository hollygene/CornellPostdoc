#!/bin/bash


mkdir /workdir/hcm59/Ecoli/raw_data/PRJNA481346
cd /workdir/hcm59/Ecoli/raw_data/PRJNA481346

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/Ecoli/PRJNA481346_SraAccList.txt | xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
