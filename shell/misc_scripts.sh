## Random useful shell scripts for analyses

# copy files that match a string in file to new directory
awk '{system("cp " $0 "* /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/")}' assemblies_for_panaroo_jan22_dog_Ecoli.txt

find -type f -name '*GCA_019204965.1*' -delete


mv GCA*/*/*/*/*.fna /workdir/hcm59/staphPseud/dogs

### To move all the files in a directory whose names match a string in a file:
nn=($(cat /Users/hcm59/Box/Holly/Dog_E_coli_project/Nov_Assembly_Download/assemblies_for_panaroo_Nov21_dog_Ecoli.txt))
for x in "${nn[@]}"
do
ls *_genomic.gff.gz|grep "$x"|xargs -I '{}' mv {} /Users/hcm59/Box/Holly/Dog_E_coli_project/Nov_Assembly_Download/panaroo_isolates/fastas
done

# print filename in first column followed by certain columns
for file in /Users/hcm59/Box/Holly/Dog_E_coli_project/Nov_Assembly_Download/AMRFinderResults/*.txt

do
FBASE=$(basename $file .txt)
BASE=${FBASE%.txt}

awk -F'\t' 'BEGIN { OFS = FS} ; {print FILENAME,$0}' ${BASE}.txt > ${BASE}_filename.txt

done

awk -F'\t' 'BEGIN { OFS = FS} ; {print FILENAME,$0}' GCA_007012305.1_ASM701230v1_genomic_AMRFinder.txt > GCA_007012305.1_ASM701230v1_genomic_AMRFinder_test.txt


awk FNR-1 *_short.txt > cat_test.txt


## To extract headers from fasta file:
grep "^>" myfile.fasta

## To compare if two fasta files have the same headers:
awk '/^>/{if (a[$1]>=1){print $1}a[$1]++}' file1 file2


# to compare two files and print matches
awk 'NR==FNR {end[$1]; next} ($1 in end)' assemblies_200_contigs_or_less_verified_host_species.txt  all_assemblies.txt > assemblies_for_panaroo_Nov21_dog_Ecoli.txt


awk 'NR==FNR {end[$1]; next} !($1 in end)' sigAssocGenesIDs.txt sigAssocGenesScoary.txt > missing.txt

# print column 2 which is the "Contig" column
awk '{ print $2 }' FS='\t' CARD_amca.fasta.txt > contigs_amca.txt

# need to trim whitespace from end of lines
awk '{ gsub(/ /,""); print }' contigs_amca.txt > contigs_amca_trim.txt

# need to eliminate "_1" from end of lines also
awk '{ print substr( $0, 1, length($0)-2 ) }' FS='\t' contigs_amca_trim.txt > CARD_contigs_amca_corr.txt

# to append fasta headers with file names:
 sed 's/^>/>Actinomyces_marimamalium/g' Actinomyces_marimamalium_partial_16S_rRNA_gene_strain_CCUG_41710.fasta > Actinomyces_marimamalium_partial_16S_rRNA_gene_strain_CCUG_41710.fasta

 for i in *.fna; do
     sed -i "s/^>/>${i}_/g" *.fna
 done

  workdir="/workdir/hcm59/Ecoli/Scoary_analyses"
  ### To use fasta FetchSeqs perl script
  perl /workdir/hcm59/CornellPostdoc/Fasta_fetchseqs.pl -in ${workdir}/amca.fasta \
    -m ${workdir}/CARD_contigs_amca_corr.txt -file -out ${workdir}/CARD_amca.fasta \
    -regex -v

    # append fasta headers with filenames
    for file in /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/*.fasta

    do
    FBASE=$(basename $file .fasta)
    BASE=${FBASE%.fasta}

    awk '/>/{sub(">","&"FILENAME"_");sub(/\.fasta/,x)}1' ${BASE}.fasta > ${BASE}_renamedHeader.fasta

    done

# bbmap to change spaces to underscores in fasta headers:
export PATH=/programs/bbmap-38.90:$PATH
reformat.sh in=all_for_16S_aln_mafft.fasta out=all_for_16S_aln_mafft_fixed.fasta addunderscore

#Extract sequences with names in file name.list, one sequence name per line:
seqtk subseq amp.fasta CARD_amp.txt$2 > output.fasta




# grep a gff3 file
for file in /Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gff\ files/ST131/*.gff

do

FBASE=$(basename $file .gff)
BASE=${FBASE%.gff}
grep -F -f /Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gff\ files/ST131/contigs_to_grep_IncFIIB.txt /Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gff\ files/ST131/${BASE}.gff > ${BASE}_plasmidContigs_IncFIIB.gff

done
