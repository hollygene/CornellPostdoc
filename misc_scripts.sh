## Random useful shell scripts for analyses

## To extract headers from fasta file:
grep "^>" myfile.fasta

## To compare if two fasta files have the same headers:
awk '/^>/{if (a[$1]>=1){print $1}a[$1]++}' file1 file2


# to compare two files and print matches
awk 'NR==FNR {end[$1]; next} ($1 in end)' gene_presence_absence_roary.csv  allSamples.txt > phenoDataSamplesAcc.txt
