#!/bin/bash


# work_dir = "/workdir/hcm59/Ecoli/raw_data/PRJNA318591"


fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/SRR_Acc_List_PRJNA318591.txt | xargs -n 1 bash get_SRR_data.sh
