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
