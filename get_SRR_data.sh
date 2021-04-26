#!/bin/bash


mkdir /workdir/hcm59/Ecoli/raw_data/PRJNA318589
cd /workdir/hcm59/Ecoli/raw_data/PRJNA318589

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/Ecoli/SraAccList_PRJNA318589.txt| xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
