#!/bin/bash


cd /workdir/hcm59/Ecoli/raw_data/rest_of_601

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/Ecoli/missingfrom601.txt | xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
