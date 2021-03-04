#!/bin/bash


work_dir = "/workdir/hcm59/Ecoli/raw_data/PRJNA324565"
mkdir ${workdir}
cd ${workdir}

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/PRJNA324565_acc_list.txt | xargs -n 1 bash get_SRR_data.sh
