#!/bin/bash


mkdir /workdir/hcm59/Ecoli/raw_data/PRJNA318591
cd /workdir/hcm59/Ecoli/raw_data/PRJNA318591

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/Ecoli/PRJNA318591_SraAccList.txt | xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
