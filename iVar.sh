# iVar script
# installed iVar in a conda environment
source $HOME/miniconda3/bin/activate
###########################################################################################################################################

horse_ref="/workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/gi|145588175|gb|EF446615.1|_Equine_coronavirus_strain_NC99_complete_genome.fasta"
# cat_ref_type_1="/workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/FCoVtype1.reference_2.fasta"
# cat_ref_type_2="/workdir/hcm59/panCoV/iVar/PrimalScheme_FCoVtype2_LG_refseq/FCoV1_LG_refseq.reference.fasta"
fastqs="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033"
rep1F="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/cats/009956-18catrep1_L001-ds.8bcb9dd94a914a3a99da2c5d716ce91a/009956-18catrep1_S5_L001_R1_001.fastq.gz"
rep1R="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/cats/009956-18catrep1_L001-ds.8bcb9dd94a914a3a99da2c5d716ce91a/009956-18catrep1_S5_L001_R2_001.fastq.gz"
rep2F="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/cats/009956-18catrep2_L001-ds.9adeaffdbf6f4609aa2e25ef398f7c57/009956-18catrep2_S6_L001_R1_001.fastq.gz"
rep2R="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/cats/009956-18catrep2_L001-ds.9adeaffdbf6f4609aa2e25ef398f7c57/009956-18catrep2_S6_L001_R2_001.fastq.gz"
prefix_rep1="016252Rep1"
prefix_rep2="016252Rep2"
prefix="016252Rep1"
###########################################################################################################################################
###########################################################################################################################################

# * NOTE: Due to a bug in conda interacting with samtools, have to reinstall samtools to update to version 1.9 with the following command:
# conda install -c bioconda samtools=1.9 --force-reinstall
###########################################################################################################################################
conda activate ivar
# conda update --all --name ivar
# First need to index the reference sequence
# bwa index ${horse_ref}
bwa index ${cat_ref_type_1}
###########################################################################################################################################

# Map to reference, convert to bam files, and sort the bam files
# need one for cats and one for horses
mkdir ${fastqs}/cats/bams
bams="/workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/bams"
# #Horses
bwa mem -t 32 ${cat_ref_type_1} ${rep1F} ${rep1R} | samtools view -b -F 4 -F 2048 | samtools sort -o ${bams}/${prefix_rep1}.sorted.bam
bwa mem -t 32 ${cat_ref_type_1} ${rep2F} ${rep2R} | samtools view -b -F 4 -F 2048 | samtools sort -o ${bams}/${prefix_rep2}.sorted.bam

###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################

# From the iVar cookbook:
# https://github.com/andersen-lab/paper_2018_primalseq-ivar/blob/master/cookbook/CookBook.ipynb

#PrimalScheme already gave us primer sequences in BED format
# eq_primers="/workdir/hcm59/panCoV/iVar/EquineCoVprimalscheme/EquineCoV.primer.bed"
cat_type1_primers="/workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/FCoVtype1.primer.bed"
# cat_type2_primers="/workdir/hcm59/panCoV/iVar/PrimalScheme_FCoVtype2_LG_refseq/FCoV1_LG_refseq.primer.bed"

# however, we need to align this to the reference genome so we need to get it back into a fasta format
# first, because our primers were generated with primalScheme, we need to get the primer bed files into a fasta file
# using bedtools getfasta
bedtools getfasta -fi ${cat_ref_type_1} \
  -fo /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/FCoVtype1.primer.fasta \
  -bed ${cat_type1_primers}

# # align to reference genome
bwa mem -k 5 -T 16 ${cat_ref_type_1} \
  /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/FCoVtype1.primer.fasta | samtools view -b -F 4 > /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/cat_type1_primers.bam

# # change back into bed file
bedtools bamtobed -i /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/cat_type1_primers.bam > /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/cat_type1_primers.bed

# now we need to use this BED file to trim primers
# equine
mkdir ${bams}/trimmed

ivar trim -b /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/cat_type1_primers.bed -p ${bams}/trimmed/${prefix_rep1}.trimmed -i ${bams}/${prefix_rep1}.sorted.bam
ivar trim -b /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/cat_type1_primers.bed -p ${bams}/trimmed/${prefix_rep2}.trimmed -i ${bams}/${prefix_rep2}.sorted.bam

###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
# Sort and index trimmed BAM file.

samtools sort -o ${bams}/trimmed/${prefix_rep1}.trimmed.sorted.bam ${bams}/trimmed/${prefix_rep1}.trimmed.bam
samtools index ${bams}/trimmed/${prefix_rep1}.trimmed.sorted.bam

samtools sort -o ${bams}/trimmed/${prefix_rep2}.trimmed.sorted.bam ${bams}/trimmed/${prefix_rep2}.trimmed.bam
samtools index ${bams}/trimmed/${prefix_rep2}.trimmed.sorted.bam


###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
# quickly look at depth of trimmed vs untrimmed bam files

# Trimmed
samtools depth -a ${bams}/trimmed/${prefix_rep1}.trimmed.sorted.bam \
  ${bams}/trimmed/${prefix_rep2}.trimmed.sorted.bam > ${bams}/trimmed/${prefix}.trimmed.sorted.depth

# untrimmed
samtools depth -a ${bams}/${prefix_rep1}.sorted.bam \
  ${bams}/${prefix_rep2}.sorted.bam > ${bams}/trimmed/${prefix}.sorted.depth

#
# python
python
import pandas as pd
import matplotlib.pyplot as plt

df_trimmed = pd.read_table("009956-18cat.trimmed.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])
df_untrimmed = pd.read_table("009956-18cat.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])

ax = df_trimmed["depth_a"].plot(logy=True, label = "Trimmed", figsize = (15,5))
df_untrimmed["depth_a"].plot(logy=True, ax = ax, label ="Untrimmed")
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('depth_009956-18cat_rep1.png')

plt.clf()
ax = df_trimmed["depth_b"].plot(logy=True, label = "Trimmed", figsize = (15,5))
df_untrimmed["depth_b"].plot(logy=True, ax = ax, label ="Untrimmed")
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('depth_009956-18cat_rep2.png')

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

samtools merge -f ${bams}/trimmed/${prefix}.merged.bam \
  ${bams}/trimmed/${prefix_rep1}.trimmed.sorted.bam \
  ${bams}/trimmed/${prefix_rep2}.trimmed.sorted.bam

samtools mpileup -A -d 0 -Q 0 ${bams}/trimmed/${prefix}.merged.bam  | ivar consensus -p \
  ${bams}/trimmed/${prefix}.consensus

bwa index -p ${bams}/trimmed/${prefix}.consensus ${bams}/trimmed/${prefix}.consensus.fa

bwa mem -k 5 -T 16 ${bams}/trimmed/${prefix}.consensus \
  /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/FCoVtype1.primer.fasta  \
  | samtools view -bS -F 4 | samtools sort -o ${bams}/trimmed/FCoVtype1_primers_consensus.bam

###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################
###########################################################################################################################################


# Let's now call iSNVs on this BAM file at a minimum threshold of 3% and the default minimum quality threshold of 20.

samtools mpileup -A -d 0 --reference ${bams}/trimmed/${prefix}.consensus.fa \
  -Q 0 ${bams}/trimmed/FCoVtype1_primers_consensus.bam \
  | ivar variants -p ${bams}/trimmed/FCoVtype1_primers_consensus -t 0.03

#Let's now get the indices of primers with mismtaches and their respective pairs. To get the pair information, we need a tsv file with two columns to represent the pairs of primers.
# I used the file in the PrimalScheme folder titled *_primer.tsv

bedtools bamtobed -i ${bams}/trimmed/FCoVtype1_primers_consensus.bam \
  > ${bams}/trimmed/FCoVtype1_primers_consensus.bed

ivar getmasked -i ${bams}/trimmed/FCoVtype1_primers_consensus.tsv \
  -b ${bams}/trimmed/FCoVtype1_primers_consensus.bed \
  -f /workdir/hcm59/panCoV/iVar/FCoVtype1_PrimalScheme/FCOV1_primer_info.tsv \
  -p ${bams}/trimmed/${prefix}_primer_mismatchers_indices

ivar removereads -i ${bams}/trimmed/${prefix_rep1}.trimmed.sorted.bam \
  -p ${bams}/trimmed/${prefix_rep1}.masked.bam -t ${bams}/trimmed/${prefix}_primer_mismatchers_indices \
  -b ${bams}/trimmed/FCoVtype1_primers_consensus.bed

ivar removereads -i ${bams}/trimmed/${prefix_rep2}.trimmed.sorted.bam \
  -p ${bams}/trimmed/${prefix_rep2}.masked.bam -t ${bams}/trimmed/${prefix}_primer_mismatchers_indices \
  -b ${bams}/trimmed/FCoVtype1_primers_consensus.bed

samtools sort -o ${bams}/trimmed/${prefix_rep1}.masked.sorted.bam ${bams}/trimmed/${prefix_rep1}.masked.bam
samtools sort -o ${bams}/trimmed/${prefix_rep2}.masked.sorted.bam ${bams}/trimmed/${prefix_rep2}.masked.bam

samtools depth -a ${bams}/trimmed/${prefix_rep1}.masked.sorted.bam ${bams}/trimmed/${prefix_rep2}.masked.sorted.bam \
  > ${bams}/${prefix}.masked.sorted.depth
samtools depth -a ${bams}/trimmed/${prefix_rep1}.trimmed.sorted.bam \
  ${bams}/trimmed/${prefix_rep2}.trimmed.sorted.bam > ${bams}/${prefix}.sorted.depth

python
import pandas as pd
import matplotlib.pyplot as plt

df_unmasked = pd.read_table("${prefix}.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])
df_masked = pd.read_table("${prefix}.masked.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])

ax = df_masked["depth_a"].plot(logy=True, label = "Masked", figsize = (15,5), alpha = 0.5)
df_unmasked["depth_a"].plot(logy=True, ax = ax, label ="Unmasked", alpha=0.5)
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('masked_vs_unmasked_rep1_${prefix}.png')

plt.clf()
ax = df_masked["depth_b"].plot(logy=True, label = "Masked", figsize = (15,5), alpha = 0.5)
df_unmasked["depth_b"].plot(logy=True, ax = ax, label ="Unmasked", alpha=0.5)
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('masked_vs_unmasked_rep2_${prefix}.png')
exit()

###########################################################################################################################################

python
import pandas as pd
import matplotlib.pyplot as plt

df_unmasked = pd.read_table("${prefix}.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])
df_masked = pd.read_table("${prefix}.masked.sorted.depth", sep = "\t", names = ["Ref", "Pos", "depth_a", "depth_b"])

ax = df_masked["depth_a"].plot(logy=True, label = "Masked", figsize = (15,5), alpha = 0.5)
df_unmasked["depth_a"].plot(logy=True, ax = ax, label ="Unmasked", alpha=0.5)
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('masked_vs_unmasked_rep1_${prefix}.png')

plt.clf()
ax = df_masked["depth_b"].plot(logy=True, label = "Masked", figsize = (15,5), alpha = 0.5)
df_unmasked["depth_b"].plot(logy=True, ax = ax, label ="Unmasked", alpha=0.5)
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig('masked_vs_unmasked_rep2_${prefix}.png')
exit()
###########################################################################################################################################
###########################################################################################################################################

# Let's now call iSNVs from the BAMS without reads from the masked amplicons.
#


samtools mpileup -A -d 0 --reference ${cat_ref_type_1} -Q 0 ${bams}/trimmed/${prefix_rep1}.masked.bam | ivar variants -p ${prefix_rep1} -t 0.03
samtools mpileup -A -d 0 --reference ${cat_ref_type_1} -Q 0 ${bams}/trimmed/${prefix_rep2}.masked.bam | ivar variants -p ${prefix_rep2} -t 0.03

# call consensus on aligned sequences
prefix_rep1="002173-18horserep1"
prefix_rep2="002173-18horserep2"
prefix="002173-18horse"
samtools mpileup -A -d 0 --reference ${horse_ref} -Q 0 /workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/${prefix_rep1}.masked.bam | ivar consensus -p ${prefix_rep1}
samtools mpileup -A -d 0 --reference ${horse_ref} -Q 0 /workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/${prefix_rep2}.masked.bam | ivar consensus -p ${prefix_rep2}


prefix_rep1="016252Rep1"
prefix_rep2="016252Rep2"
prefix="016252Rep1"
samtools mpileup -A -d 0 --reference ${horse_ref} -Q 0 /workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/${prefix_rep1}.masked.bam | ivar consensus -p ${prefix_rep1}
samtools mpileup -A -d 0 --reference ${horse_ref} -Q 0 /workdir/hcm59/panCoV/iVar/primalseq-281139869/FASTQ_Generation_2021-07-16_21_01_19Z-439472033/horses/${prefix_rep2}.masked.bam | ivar consensus -p ${prefix_rep1}



# Let's now filter the iSNVs to get the ones called across both the replicates.
ivar filtervariants -p ${prefix} ${prefix_rep1}.tsv ${prefix_rep2}.tsv


# Let's now plot iSNVs from each replicate.
python
import pandas as pd
import matplotlib.pyplot as plt

rep_a = pd.read_table("${prefix_rep1}.tsv", sep="\t")
rep_b = pd.read_table("${prefix_rep2}.tsv", sep="\t")

filtered = pd.read_table("${prefix}.tsv", sep="\t")

f, ax = plt.subplots(figsize=(15,5))
rep_a.plot(x="POS", y="ALT_FREQ", label="A", ax =ax, kind="scatter", color="red", alpha = 0.3)
rep_b.plot(x="POS", y="ALT_FREQ", label="B", ax = ax, kind="scatter", color="blue", alpha=0.3)
ax.set_xlim([0, 11000])
ax.set_ylim([0, 1.1])
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig("iSNVs_${prefix}.png")

plt.clf()
ax = filtered.plot(x="POS", y=["ALT_FREQ_${prefix_rep1}.tsv", "ALT_FREQ_${prefix_rep1}.tsv"], marker='o', ls='', figsize=(15,5))
ax.set_xlim([0, 11000])
ax.set_ylim([0, 1.1])
plt.legend()
plt.tight_layout()
plt.show()
plt.savefig("iSNVs_left_${prefix_rep1}.png")


exit()


# convert aligned sequences to a fasta
samtools fasta 002173-18horserep1.masked.sorted.bam > 002173-18horserep1.fasta
samtools fasta 002173-18horserep2.masked.sorted.bam  >002173-18horserep2.fasta
samtools fasta 016252Rep1.masked.sorted.bam > 016252Rep1.fasta
samtools fasta 016252Rep2.masked.sorted.bam > 016252Rep2.fasta
