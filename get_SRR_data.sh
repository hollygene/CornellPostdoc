#!/bin/bash


mkdir /workdir/hcm59/Ecoli/raw_data/PRJNA324565
cd /workdir/hcm59/Ecoli/raw_data/PRJNA324565

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/PRJNA324565_acc_list.txt | xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
