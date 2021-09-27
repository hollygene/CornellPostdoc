#!/bin/bash


cd /workdir/hcm59/Ecoli/fastq_missing_assemblies

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/Ecoli/SRR_ids_missing_assemblies.txt | xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
