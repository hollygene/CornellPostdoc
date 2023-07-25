#!/bin/bash


cd /workdir/hcm59/staphPseud/2022/SRA_data

fastq-dump --split-3 $1

# to run:
  # cat /workdir/hcm59/staphPseud/2022/SRR_accessionsStaphPseudToAssemble.txt /workdir/hcm59/staphPseud/2022/SRA_data | xargs -n 1 bash /workdir/hcm59/CornellPostdoc/get_SRR_data.sh
