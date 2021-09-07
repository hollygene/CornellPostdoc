## Random useful shell scripts for analyses

## To extract headers from fasta file:
grep "^>" myfile.fasta

## To compare if two fasta files have the same headers:
awk '/^>/{if (a[$1]>=1){print $1}a[$1]++}' file1 file2


# to compare two files and print matches
awk 'NR==FNR {end[$1]; next} ($1 in end)' gene_presence_absence_roary.csv  allSamples.txt > phenoDataSamplesAcc.txt

awk 'NR==FNR {end[$1]; next} !($1 in end)' sigAssocGenesIDs.txt sigAssocGenesScoary.txt > missing.txt

# print column 2 which is the "Contig" column
awk '{ print $2 }' FS='\t' CARD_amca.fasta.txt > contigs_amca.txt

# need to trim whitespace from end of lines
awk '{ gsub(/ /,""); print }' contigs_amca.txt > contigs_amca_trim.txt

# need to eliminate "_1" from end of lines also
awk '{ print substr( $0, 1, length($0)-2 ) }' FS='\t' contigs_amca_trim.txt > CARD_contigs_amca_corr.txt


  workdir="/workdir/hcm59/Ecoli/Scoary_analyses"
  ### To use fasta FetchSeqs perl script
  perl /workdir/hcm59/CornellPostdoc/Fasta_fetchseqs.pl -in ${workdir}/amca.fasta \
    -m ${workdir}/CARD_contigs_amca_corr.txt -file -out ${workdir}/CARD_amca.fasta \
    -regex -v




#Extract sequences with names in file name.list, one sequence name per line:
seqtk subseq amp.fasta CARD_amp.txt$2 > output.fasta




# grep a gff3 file
for file in /Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gff\ files/ST131/*.gff

do

FBASE=$(basename $file .gff)
BASE=${FBASE%.gff}
grep -F -f /Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gff\ files/ST131/contigs_to_grep_IncFIIB.txt /Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gff\ files/ST131/${BASE}.gff > ${BASE}_plasmidContigs_IncFIIB.gff

done
