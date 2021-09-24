# use ncbi's datasets tool to download assemblies

# wget https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets
#
# chmod a+x datasets

# ./datasets

#for example, download gene with gene-id 672
# ./datasets download gene GCA_012348725.1


#!/bin/bash
# filename='/workdir/hcm59/Ecoli/200_contigs_or_less.txt'
# while read p; do
#     # echo "$p"
#     ./datasets download genome accession $p --dehydrated --filename $p.zip
# done < "$filename"

# datasets download genome accession GCF_000001405.39 --dehydrated --filename human_GRCh38_dataset.zip

# for file in /workdir/hcm59/Ecoli/assemblies/200_contigs_or_less/*.1.zip
#
# do
# FBASE=$(basename $file .1.zip)
# BASE=${FBASE%.1.zip}
#
# unzip /workdir/hcm59/Ecoli/assemblies/200_contigs_or_less/${BASE}.1.zip -d /workdir/hcm59/Ecoli/assemblies/200_contigs_or_less/${BASE}
#
# done


for d in /workdir/hcm59/Ecoli/assemblies/200_contigs_or_less/*/

do

datasets rehydrate --directory $d

done
