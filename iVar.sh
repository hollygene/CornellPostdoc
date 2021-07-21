# iVar script
# installed iVar in a conda environment
source $HOME/miniconda3/bin/activate
###########################################################################################################################################

horse_ref="/workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/gi|145588175|gb|EF446615.1|_Equine_coronavirus_strain_NC99_complete_genome.fasta"
cat_ref_type_1="/workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/KP143508.1_Feline_coronavirus_isolate_28O__complete_genome_2.fasta"
# cat_ref_type_2="/workdir/hcm59/panCoV/iVar/PrimalScheme_FCoVtype2_LG_refseq/FCoV1_LG_refseq.reference.fasta"
fastqs="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/016252-18horserep1_L001-ds.e60f908352f24281bddf8f91cdb072ca"
rep1F="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/016252-18horserep1_L001-ds.e60f908352f24281bddf8f91cdb072ca/016252-18horserep1_S1_L001_R1_001.fastq.gz"
rep1R="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/016252-18horserep1_L001-ds.e60f908352f24281bddf8f91cdb072ca/016252-18horserep1_S1_L001_R2_001.fastq.gz"
rep2F="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/016252-18horserep2_L001-ds.20c5dde31e4146a3acf8d2655f83dd32/016252-18horserep2_S2_L001_R1_001.fastq.gz"
rep2R="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/016252-18horserep2_L001-ds.20c5dde31e4146a3acf8d2655f83dd32/016252-18horserep2_S2_L001_R2_001.fastq.gz"

###########################################################################################################################################
###########################################################################################################################################

# * NOTE: Due to a bug in conda interacting with samtools, have to reinstall samtools to update to version 1.9 with the following command:
conda install -c bioconda samtools=1.9 --force-reinstall
###########################################################################################################################################
conda activate ivar
conda update --all --name ivar
# First need to index the reference sequence
bwa index ${horse_ref}
###########################################################################################################################################

# Map to reference, convert to bam files, and sort the bam files
# need one for cats and one for horses
mkdir ${fastqs}/horses/bams
# #Horses
bwa mem -t 32 ${horse_ref} ${rep1F} ${rep1R} | samtools view -b -F 4 -F 2048 | samtools sort -o ${fastqs}/horses/bams/016252Rep1.sorted.bam
bwa mem -t 32 ${horse_ref} ${rep2F} ${rep2R} | samtools view -b -F 4 -F 2048 | samtools sort -o ${fastqs}/horses/bams/016252Rep2.sorted.bam

###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################

# From the iVar cookbook:
# https://github.com/andersen-lab/paper_2018_primalseq-ivar/blob/master/cookbook/CookBook.ipynb

#PrimalScheme already gave us primer sequences in BED format
eq_primers="/workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/EquineCoV.primer.bed"
# cat_type1_primers="/workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/FCoVtype1.primer.bed"
# cat_type2_primers="/workdir/hcm59/panCoV/iVar/PrimalScheme_FCoVtype2_LG_refseq/FCoV1_LG_refseq.primer.bed"

# however, we need to align this to the reference genome so we need to get it back into a fasta format
# first, because our primers were generated with primalScheme, we need to get the primer bed files into a fasta file
# using bedtools getfasta
# bedtools getfasta -fi /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/EquineCoV.reference.fasta \
#   -fo /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.fasta \
#   -bed /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/EquineCoV.primer.bed
#
# # align to reference genome
# bwa mem -k 5 -T 16 /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/EquineCoV.reference.fasta \
#   /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.fasta | samtools view -b -F 4 > /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.bam
#
# # change back into bed file
# bedtools bamtobed -i /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.bam > /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.bed

# now we need to use this BED file to trim primers
# equine
# mkdir ${fastqs}/horses/bams/trimmed

ivar trim -b /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.bed -p ${fastqs}/horses/bams/trimmed/016252Rep1.trimmed -i ${fastqs}/horses/bams/016252Rep1.sorted.bam
ivar trim -b /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.bed -p ${fastqs}/horses/bams/trimmed/016252Rep2.trimmed -i ${fastqs}/horses/bams/016252Rep2.sorted.bam

###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
# Sort and index trimmed BAM file.

samtools sort -o ${fastqs}/horses/bams/trimmed/016252Rep1.trimmed.sorted.bam ${fastqs}/horses/bams/trimmed/016252Rep1.trimmed.bam
samtools index ${fastqs}/horses/bams/trimmed/016252Rep1.trimmed.sorted.bam

samtools sort -o ${fastqs}/horses/bams/trimmed/016252Rep2.trimmed.sorted.bam ${fastqs}/horses/bams/trimmed/016252Rep2.trimmed.bam
samtools index ${fastqs}/horses/bams/trimmed/016252Rep2.trimmed.sorted.bam


###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
# quickly look at depth of trimmed vs untrimmed bam files

# Trimmed
samtools depth -a ${fastqs}/horses/bams/trimmed/016252Rep1.trimmed.sorted.bam \
  ${fastqs}/horses/bams/trimmed/016252Rep2.trimmed.sorted.bam > ${fastqs}/horses/bams/trimmed/016252Rep1_horserep1_2.trimmed.sorted.depth

# untrimmed
samtools depth -a ${fastqs}/horses/bams/016252Rep1.sorted.bam \
  ${fastqs}/horses/bams/016252Rep2.sorted.bam > ${fastqs}/horses/bams/trimmed/016252Rep1_2.sorted.depth

#
# python
python
import pandas as pd
import matplotlib.pyplot as plt

df_trimmed = pd.read_table("016252Rep1_2.trimmed.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])
df_untrimmed = pd.read_table("016252Rep1_2.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])

ax = df_trimmed["depth_a"].plot(logy=True, label = "Trimmed", figsize = (15,5))
df_untrimmed["depth_a"].plot(logy=True, ax = ax, label ="Untrimmed")
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('depth_016252_horse_rep1.png')

plt.clf()
ax = df_trimmed["depth_b"].plot(logy=True, label = "Trimmed", figsize = (15,5))
df_untrimmed["depth_b"].plot(logy=True, ax = ax, label ="Untrimmed")
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('depth_016252_horse_rep2.png')

exit()


###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################

# Now we need to identify primer sequences that might have a mismatch with the consensus sequence to ensure that we remove reads from any amplicon that might bias the iSNV frequency due to varying primer binding effeciency.

# To do this, we do this following steps,
#
# Merge the two replicates A and B.
# Call consensus on merged BAM file.
# Align primer sequences to consensus after creating a bwa index from the consensus sequence called.

# If you are re-running this step, you might have to delete the Z52.merged.bam file or specify a -f option to overwrite an existing BAM
# horses

samtools merge -f ${fastqs}/horses/bams/trimmed/016252_horse.merged.bam \
  ${fastqs}/horses/bams/trimmed/016252Rep1.trimmed.sorted.bam \
  ${fastqs}/horses/bams/trimmed/016252Rep2.trimmed.sorted.bam
samtools mpileup -A -d 0 -Q 0 ${fastqs}/horses/bams/trimmed/016252_horse.merged.bam | ivar consensus -p \
  ${fastqs}/horses/bams/trimmed/016252_horse.consensus
bwa index -p ${fastqs}/horses/bams/trimmed/016252_horse.consensus ${fastqs}/horses/bams/trimmed/016252_horse.consensus.fa
bwa mem -k 5 -T 16 ${fastqs}/horses/bams/trimmed/016252_horse.consensus \
  /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.fasta \
  | samtools view -bS -F 4 | samtools sort -o ${fastqs}/horses/bams/trimmed/016252_horse_primers_consensus.bam

###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################


# Let's now call iSNVs on this BAM file at a minimum threshold of 3% and the default minimum quality threshold of 20.

samtools mpileup -A -d 0 --reference ${fastqs}/horses/bams/trimmed/016252_horse.consensus.fa \
  -Q 0 ${fastqs}/horses/bams/trimmed/016252_horse_primers_consensus.bam \
  | ivar variants -p ${fastqs}/horses/bams/trimmed/016252_horse_primers_consensus -t 0.03

#Let's now get the indices of primers with mismtaches and their respective pairs. To get the pair information, we need a tsv file with two columns to represent the pairs of primers.
# I used the file in the PrimalScheme folder titled *_primer.tsv

bedtools bamtobed -i ${fastqs}/horses/bams/trimmed/016252_horse_primers_consensus.bam \
  > ${fastqs}/horses/bams/trimmed/016252_horse_primers_consensus.bed

ivar getmasked -i ${fastqs}/horses/bams/trimmed/016252_horse_primers_consensus.tsv \
  -b ${fastqs}/horses/bams/trimmed/016252_horse_primers_consensus.bed \
  -f /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/eq_primer_pair_info.tsv \
  -p ${fastqs}/horses/bams/trimmed/016252_horse_primer_mismatchers_indices

ivar removereads -i ${fastqs}/horses/bams/trimmed/016252Rep1.trimmed.sorted.bam \
  -p ${fastqs}/horses/016252Rep1.masked.bam -t ${fastqs}/horses/bams/trimmed/016252_horse_primer_mismatchers_indices.txt \
  -b /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.bed
ivar removereads -i ${fastqs}/horses/bams/trimmed/016252Rep2.trimmed.sorted.bam \
  -p ${fastqs}/horses/016252Rep2.masked.bam -t ${fastqs}/horses/bams/trimmed/016252_horse_primer_mismatchers_indices.txt \
  -b /workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/horse_primers.bed

samtools sort -o ${fastqs}/horses/016252Rep1.masked.sorted.bam ${fastqs}/horses/016252Rep1.masked.bam
samtools sort -o ${fastqs}/horses/016252Rep2.masked.sorted.bam ${fastqs}/horses/016252Rep2.masked.bam

samtools depth -a ${fastqs}/horses/016252Rep1.masked.sorted.bam ${fastqs}/horses/016252Rep2.masked.sorted.bam \
  > ${fastqs}/horses/016252.masked.sorted.depth
samtools depth -a ${fastqs}/horses/bams/trimmed/016252Rep1.trimmed.sorted.bam \
  ${fastqs}/horses/bams/trimmed/016252Rep2.trimmed.sorted.bam > ${fastqs}/horses/016252.sorted.depth

python
import pandas as pd
import matplotlib.pyplot as plt

df_unmasked = pd.read_table("016252.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])
df_masked = pd.read_table("016252.masked.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])

ax = df_masked["depth_a"].plot(logy=True, label = "Masked", figsize = (15,5), alpha = 0.5)
df_unmasked["depth_a"].plot(logy=True, ax = ax, label ="Unmasked", alpha=0.5)
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('masked_vs_unmasked_rep1_016252.png')

plt.clf()
ax = df_masked["depth_b"].plot(logy=True, label = "Masked", figsize = (15,5), alpha = 0.5)
df_unmasked["depth_b"].plot(logy=True, ax = ax, label ="Unmasked", alpha=0.5)
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('masked_vs_unmasked_rep2_016252.png')
exit()

###########################################################################################################################################
###########################################################################################################################################

# Let's now call iSNVs from the BAMS without reads from the masked amplicons.
#


samtools mpileup -A -d 0 --reference ${horse_ref} -Q 0 ${fastqs}/horses/016252Rep1.masked.bam | ivar variants -p 016252Rep1 -t 0.03
samtools mpileup -A -d 0 --reference ${horse_ref} -Q 0 ${fastqs}/horses/016252Rep2.masked.bam | ivar variants -p 016252Rep2 -t 0.03


# Let's now filter the iSNVs to get the ones called across both the replicates.
ivar filtervariants -p 016252 016252Rep1.tsv 016252Rep2.tsv


# Let's now plot iSNVs from each replicate.
python
import pandas as pd
import matplotlib.pyplot as plt

rep_a = pd.read_table("016252Rep1.tsv", sep="\t")
rep_b = pd.read_table("016252Rep2.tsv", sep="\t")

filtered = pd.read_table("016252.tsv", sep="\t")

f, ax = plt.subplots(figsize=(15,5))
rep_a.plot(x="POS", y="ALT_FREQ", label="A", ax =ax, kind="scatter", color="red", alpha = 0.3)
rep_b.plot(x="POS", y="ALT_FREQ", label="B", ax = ax, kind="scatter", color="blue", alpha=0.3)
ax.set_xlim([0, 11000])
ax.set_ylim([0, 1.1])
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('iSNVs_horse016252.png')

plt.clf()
ax = filtered.plot(x="POS", y=["ALT_FREQ_016252Rep1.tsv", "ALT_FREQ_016252Rep2.tsv"], marker='o', ls='', figsize=(15,5))
ax.set_xlim([0, 11000])
ax.set_ylim([0, 1.1])
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('iSNVs_left_horse016252.png')


exit()
