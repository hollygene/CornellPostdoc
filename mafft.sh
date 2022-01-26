# mafft commands

# append fasta headers with filenames
for file in /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/*.fasta

do
FBASE=$(basename $file .fasta)
BASE=${FBASE%.fasta}

awk '/>/{sub(">","&"FILENAME"_");sub(/\.fasta/,x)}1' ${BASE}.fasta > ${BASE}_renamedHeader.fasta

done


cat *.fna > all_dog_ecoli_nov2021.fna

/programs/mafft/bin/mafft --auto /workdir/hcm59/Ecoli/panaroo_isolates/fastas/fastas/all_dog_ecoli_nov2021.fna  > /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_dog_ecoli_nov2021_mafft.fasta


export PATH=/programs/mafft/bin:$PATH

# L-INS-i: prob most accurate, recommended for less than 200 sequences
mafft --localpair --maxiterate 1000 /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/renamed/all_sp_16S_renamed.fasta > /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_linsi.fasta

linsi input [> output]


# G-INS-i: suitable for sequences of similar length, iterative refinement method incorporating global pairwise alignment information
mafft --globalpair --maxiterate 1000 /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/renamed/all_sp_16S_renamed.fasta > /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_ginsi.fasta

ginsi input [> output]

# *E-INS-i (suitable for sequences containing large unalignable regions; recommended for <200 sequences):
mafft --ep 0 --genafpair --maxiterate 1000 /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/renamed/all_sp_16S_renamed.fasta > /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_einsi.fasta

einsi input [> output]
# For E-INS-i, the --ep 0 option is recommended to allow large gaps

mafft --ep 0 --genafpair --maxiterate 1000 /workdir/hcm59/actinomyces/assembled/all_3_seqs.fasta > /workdir/hcm59/actinomyces/assembled/all_3_seqs_einsi.fasta
