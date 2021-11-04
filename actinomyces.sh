# actinomyces pipeline

###############################################################################################################################
# fastQC
for file in /workdir/hcm59/actinomyces/*_001.fastq

do
FBASE=$(basename $file _001.fastq)
BASE=${FBASE%_001.fastq}

fastqc /workdir/hcm59/actinomyces/${BASE}_001.fastq

done


###############################################################################################################################
export LC_ALL=en_US.UTF-8
export PYTHONPATH=/programs/multiqc-1.10.1/lib64/python3.6/site-packages:/programs/multiqc-1.10.1/lib/python3.6/site-packages
export PATH=/programs/multiqc-1.10.1/bin:$PATH

multiqc /workdir/hcm59/actinomyces/*


###############################################################################################################################
# trimmomatic
java -jar /programs/trimmomatic/trimmomatic-0.39.jar PE -phred33 186855-17_S15_L001_R1_001.fastq 186855-17_S15_L001_R2_001.fastq 186855_R1_001_paired.fastq 186855_R1_001_unpaired.fastq 186855_R2_001_paired.fastq 186855_R2_001_unpaired.fastq ILLUMINACLIP:/programs/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:200

java -jar /programs/trimmomatic/trimmomatic-0.39.jar PE -phred33 187325-19-1-1A_S18_L001_R1_001.fastq 187325-19-1-1A_S18_L001_R2_001.fastq 187325_R1_001_paired.fastq 187325_R1_001_unpaired.fastq 187325_R2_001_paired.fastq 187325_R2_001_unpaired.fastq ILLUMINACLIP:/programs/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:200

java -jar /programs/trimmomatic/trimmomatic-0.39.jar PE -phred33 217892-18-1_S19_L001_R1_001.fastq 217892-18-1_S19_L001_R2_001.fastq 217892_R1_001_paired.fastq 217892_R1_001_unpaired.fastq 217892_R2_001_paired.fastq 217892_R2_001_unpaired.fastq ILLUMINACLIP:/programs/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:200

###############################################################################################################################
# fastQC again on trimmed reads
for file in /workdir/hcm59/actinomyces/*paired.fastq

do
FBASE=$(basename $file paired.fastq)
BASE=${FBASE%paired.fastq}

fastqc /workdir/hcm59/actinomyces/${BASE}paired.fastq

done

###############################################################################################################################
export LC_ALL=en_US.UTF-8
export PYTHONPATH=/programs/multiqc-1.10.1/lib64/python3.6/site-packages:/programs/multiqc-1.10.1/lib/python3.6/site-packages
export PATH=/programs/multiqc-1.10.1/bin:$PATH

multiqc /workdir/hcm59/actinomyces/*

###############################################################################################################################
# assemble with SPAdes
# Before running SPAdes, execute the following command (once per session, or somewhere in the beginning of a script that launches SPADES):
export OMP_NUM_THREADS=16
# (if you use the -t option of SPADES, change '16' to the number greater or equal to the one specified with that option).
parentDir="/workdir/hcm59/actinomyces"
/programs/spades/bin/spades.py -o /workdir/hcm59/actinomyces/assembled \
-1 /workdir/hcm59/actinomyces/186855_R1_001_paired.fastq \
-2 /workdir/hcm59/actinomyces/186855_R2_001_paired.fastq

/programs/spades/bin/spades.py -o /workdir/hcm59/actinomyces/assembled/187325 \
-1 /workdir/hcm59/actinomyces/187325_R1_001_paired.fastq \
-2 /workdir/hcm59/actinomyces/187325_R2_001_paired.fastq

/programs/spades/bin/spades.py -o /workdir/hcm59/actinomyces/assembled/217892 \
-1 /workdir/hcm59/actinomyces/217892_R1_001_paired.fastq \
-2 /workdir/hcm59/actinomyces/217892_R2_001_paired.fastq

###############################################################################################################################
# QC assemblies with QUAST
export PATH=/programs/quast-5.1.0rc1:$PATH

quast.py contigs_217892.fasta \
               -g contigs_217892.gff

###############################################################################################################################
# isolate 16S sequences with RNAmmer

16S_dir="/workdir/hcm59/actinomyces/16S_species_seqs"

for file in /workdir/hcm59/actinomyces/16S_species_seqs/*.fna

do
FBASE=$(basename $file .fna)
BASE=${FBASE%.fna}

perl /programs/rnammer-1.2/rnammer -S bac -m ssu -gff /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}.gff < /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}.fna

export PATH=/programs/bedtools2-2.29.2/bin:$PATH
bedtools getfasta -fi /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}.fna -fo /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}_16S.fasta -bed /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}.gff

done


###############################################################################################################################

# need to rename fasta headers
# append fasta headers with filenames
for file in /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/type_strains_16S/*.fasta

do
FBASE=$(basename $file .fasta)
BASE=${FBASE%.fasta}

awk '/>/{sub(">","&"FILENAME"_");sub(/\.fasta/,x)}1' ${BASE}.fasta > ${BASE}_renamedHeader.fasta

done

# remove colons
for file in /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/type_strains_16S/*_renamedHeader.fasta

do
FBASE=$(basename $file _renamedHeader.fasta)
BASE=${FBASE%_renamedHeader.fasta}

sed s/://g ${BASE}_renamedHeader.fasta > ${BASE}_noCols.fasta

done

###############################################################################################################################
# align sequences with MAFFT
export PATH=/programs/mafft/bin:$PATH

# L-INS-i: prob most accurate, recommended for less than 200 sequences
mafft --localpair --maxiterate 1000 /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/renamed/all_sp_16S_renamed.fasta > /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_linsi.fasta

# G-INS-i: suitable for sequences of similar length, iterative refinement method incorporating global pairwise alignment information
mafft --globalpair --maxiterate 1000 /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/renamed/all_sp_16S_renamed.fasta > /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_ginsi.fasta

# *E-INS-i (suitable for sequences containing large unalignable regions; recommended for <200 sequences):
mafft --ep 0 --genafpair --maxiterate 1000 /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/renamed/all_sp_16S_renamed.fasta > /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_einsi.fasta

# For E-INS-i, the --ep 0 option is recommended to allow large gaps
mafft --ep 0 --genafpair --maxiterate 1000 /workdir/hcm59/actinomyces/assembled/all_3_seqs.fasta > /workdir/hcm59/actinomyces/assembled/all_3_seqs_einsi.fasta

###############################################################################################################################
# clean up alignment with Gblocks
export PATH=/programs/Gblocks_0.91b:$PATH

Gblocks /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_linsi.fasta -t=d -n=y -u=y -d=y
# Gblocks alignment:  945 positions (49 %) in 37 selected block(s)

Gblocks /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_ginsi.fasta -t=d -n=y -u=y -d=y
# Gblocks alignment:  1008 positions (53 %) in 36 selected block(s)

Gblocks /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/all_for_16S_aln_mafft_einsi.fasta -t=d -n=y -u=y -d=y
# Gblocks alignment:  934 positions (48 %) in 37 selected block(s)

# t=d: type is DNA
# n=y: nonconserved blocks
# u=y: ungapped alignment
# d=y: postscript file with the selected blocks

###############################################################################################################################
# raxML-ng for tree building
# add to your path
export PATH=/programs/raxml-ng_v1.0.1:$PATH

# check your MSA is good
raxml-ng --check --msa all_for_16S_aln_mafft_ginsi.fasta-gb --model GTR+G+I --prefix ginsi

raxml-ng --parse --msa all_for_16S_aln_mafft_ginsi.fasta-gb --model GTR+G+I --prefix ginsi_gb2

raxml-ng --all --msa all_for_16S_aln_mafft_ginsi.fasta-gb --model GTR+G+I --tree pars{10} --bs-trees 1000
