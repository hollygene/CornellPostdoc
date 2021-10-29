# mafft commands

# append fasta headers with filenames
for file in /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/*.fasta

do
FBASE=$(basename $file .fasta)
BASE=${FBASE%.fasta}

awk '/>/{sub(">","&"FILENAME"_");sub(/\.fasta/,x)}1' ${BASE}.fasta > ${BASE}_renamedHeader.fasta

done


/programs/mafft/bin/mafft /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/renamed/all_sp_16S_renamed.fasta > /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_3.fasta
