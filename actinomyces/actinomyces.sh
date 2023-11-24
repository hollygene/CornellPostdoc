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


for file in /workdir/hcm59/actinomyces/16S_species_seqs/new/*.fna

do
FBASE=$(basename $file .fna)
BASE=${FBASE%.fna}

perl /programs/rnammer-1.2/rnammer -S bac -m ssu -gff /workdir/hcm59/actinomyces/16S_species_seqs/new/${BASE}.gff < /workdir/hcm59/actinomyces/16S_species_seqs/new/${BASE}.fna

export PATH=/programs/bedtools2-2.29.2/bin:$PATH
bedtools getfasta -fi /workdir/hcm59/actinomyces/16S_species_seqs/new/${BASE}.fna -fo /workdir/hcm59/actinomyces/16S_species_seqs/new/${BASE}_16S.fasta -bed /workdir/hcm59/actinomyces/16S_species_seqs/new/${BASE}.gff

done


###############################################################################################################################

# need to rename fasta headers
# append fasta headers with filenames
for file in *.fasta

do
FBASE=$(basename $file .fasta)
BASE=${FBASE%.fasta}

# awk '/>/{sub(">","&"FILENAME"_");sub(/\.fna/,x)}1' /workdir/hcm59/actinomyces/16S_species_seqs/new/16S/${BASE}.fasta >  /workdir/hcm59/actinomyces/16S_species_seqs/new/16S/${BASE}_renamedHeader.fasta
# awk '{print $1;next}1'  /workdir/hcm59/actinomyces/16S_species_seqs/new/16S/${BASE}_renamedHeader.fasta >  /workdir/hcm59/actinomyces/16S_species_seqs/new/16S/${BASE}_renamedHeaderClean.fasta

awk '/^>/ {gsub(/.fa(sta)?$/,"",FILENAME);printf(">%s\n",FILENAME);next;} {print}' ${BASE}.fasta >  ${BASE}_renamedHeaderTest.fasta
done

# remove colons
# for file in /workdir/hcm59/actinomyces/16S_species_seqs/16S_only/type_strains_16S/*_renamedHeader.fasta
#
# do
# FBASE=$(basename $file _renamedHeader.fasta)
# BASE=${FBASE%_renamedHeader.fasta}
#
# sed s/://g ${BASE}_renamedHeader.fasta > ${BASE}_noCols.fasta
#
# done

#concatenate sequences for alignment
cat *_renamedHeaderTest.fasta > all_actinomyces_16S.fasta
###############################################################################################################################
# align sequences with MAFFT

export PATH=/programs/mafft/bin:$PATH
mafft --reorder --adjustdirectionaccurately --leavegappyregion --kimura 1 --maxiterate 2 --retree 1 --globalpair /workdir/hcm59/actinomyces/16S_species_seqs/new/16S/all_actinomyces_16S_red.fasta > /workdir/hcm59/actinomyces/16S_species_seqs/new/16S/all_actinomyces_16S_red_mafft.fasta

###############################################################################################################################
# clean up alignment with Gblocks
export PATH=/programs/Gblocks_0.91b:$PATH

Gblocks /workdir/hcm59/actinomyces/16S_species_seqs/new/16S/all_actinomyces_16S_red_mafft.fasta -t=d -n=y -u=y -d=y

# t=d: type is DNA
# n=y: nonconserved blocks
# u=y: ungapped alignment
# d=y: postscript file with the selected blocks

###############################################################################################################################
# raxML-ng for tree building
# add to your path
export PATH=/programs/raxml-ng_v1.0.1:$PATH

# check your MSA is good
raxml-ng --check --msa all_actinomyces_16S_red_mafft.fasta-gb --model GTR+G+I --prefix march

raxml-ng --parse --msa all_actinomyces_16S_red_mafft.fasta-gb --model GTR+G+I --prefix march1
raxml-ng --msa all_actinomyces_16S_red_mafft.fasta-gb --model GTR+G+I --prefix T3 --threads 2 --seed 2
raxml-ng --msa all_actinomyces_16S_red_mafft.fasta-gb --model GTR+G+I --prefix T4 --threads 2 --seed 2 --tree pars{25},rand{25}
grep "Final LogLikelihood:" T{3,4}.raxml.log
cat T{3,4}.raxml.mlTrees > mltrees
raxml-ng --rfdist --tree mltrees --prefix RF
raxml-ng --bootstrap --msa all_actinomyces_16S_red_mafft.fasta-gb --model GTR+G+I --tree pars{10},rand{10} --bs-trees 1000 --seed 2
raxml-ng --bsconverge --bs-trees all_actinomyces_16S_red_mafft.fasta-gb.raxml.bootstraps --prefix t2 --seed 2 --threads 2 --bs-cutoff 0.05
raxml-ng --bootstrap --msa all_actinomyces_16S_red_mafft.fasta-gb --model GTR+G+I --prefix bt2 --seed 333 --threads 1 --tree pars{10},rand{10} --bs-trees 500

cat bt2.raxml.bootstraps all_actinomyces_16S_red_mafft.fasta-gb.raxml.bootstraps > allbootstraps
raxml-ng --bsconverge --bs-trees allbootstraps --prefix bt3 --seed 2 --threads 1 --bs-cutoff 0.05

--all

# from web server:
--msa /scratch/cluster/weekly/raxml/job_62272/sequenceAlignment.fasta --model GTR+FO+G --search --opt-branches on --opt-model on --tree pars{10},rand{10} --force --threads 2 --prefix /scratch/cluster/weekly/raxml/job_62272/resul
t
-msa /scratch/cluster/weekly/raxml/job_59298/sequenceAlignment.fasta --model GTR+FO+G --search --opt-branches on --opt-model on --tree pars{10},rand{10} --force --threads 2 --prefix /scratch/cluster/weekly/raxml/job_59298/result


###############################################################################################################################
# IqTree
# put miniconda in your path
export PATH=/workdir/miniconda3/bin:$PATH
source activate iqtree #load in iqtree environment
iqtree -s all_for_16S_aln_mafft_3.fasta -m MFP

iqtree -s all_actinomyces_16S_red_mafft.fasta-gb -m GTR+G -nt AUTO -B 1000 --prefix ufbootstrap
iqtree -s all_actinomyces_16S_red_mafft.fasta-gb -m GTR+G -nt AUTO -b 1000 --prefix stdbootstrap
  # B is # bootstraps for branch support analysis (using UFBoot)
  # -b if you want to use the standard non-parametric bootstrapping
  # nt is number of threads
  # s specifies alignment file to use
  # m specifies what model to use
  # GTR: most general substitution model
  # G: allows different sites to have different substitution rates
  # ASC: want IQTree to run ascertainment bias correction (necessary because SNP data)




###############################################################################################################################
# fastANI to calculate average nucleotide identity
/programs/fastANI-1.3/fastANI
# help page
/programs/fastANI-1.3/fastANI -h

# one to many
# QUERY_LIST and REFERENCE_LIST are files containing paths to genomes, one per line.
# QUERY_GENOME and REFERENCE_GENOME are the query genome assemblies in fasta or multi-fasta format.
# OUTPUT_FILE will contain tab delimited row(s) with query genome, reference genome, ANI value, count of bidirectional fragment mappings, and total query fragments.
#  NOTE: No ANI output is reported for a genome pair if ANI value is much below 80%. Such case should be computed at amino acid level.

/programs/fastANI-1.3/fastANI -q /workdir/hcm59/actinomyces/assembled/assemblies/contigs_217892.fasta -r /workdir/hcm59/actinomyces/assembled/assemblies/contigs_187325.fasta -o /workdir/hcm59/actinomyces/ANI/contigs_217892to187325.txt

/programs/fastANI-1.3/fastANI -q /workdir/hcm59/actinomyces/assembled/assemblies/contigs_186855.fasta --rl /workdir/hcm59/actinomyces/ncbi_genomes/ncbi_dataset/genomes.txt -o /workdir/hcm59/actinomyces/ANI/${BASE}.txt


for file in /workdir/hcm59/actinomyces/assembled/assemblies/*.fasta

do

FBASE=$(basename $file .fasta)
BASE=${FBASE%.fasta}


/programs/fastANI-1.3/fastANI -q /workdir/hcm59/actinomyces/assembled/assemblies/${BASE}.fasta --rl /workdir/hcm59/actinomyces/ncbi_genomes/ncbi_dataset/genomes.txt -o /workdir/hcm59/actinomyces/ANI/${BASE}.txt

done


###############################################################################################################################
# kSNP to find core genome SNPs to make the core genome tree
export PATH=/programs/kSNP3:$PATH

# need to make a file that contains a list of the genomes in the dataset
# must be in directory with all of the genomes for this, and there must be nothing else in the directory
# MakeKSNP3infile directory outfileName mode
# mode = A, automatically makes genome name the file name without the ending
# mode = S, semi-automatic mode, you have to input the genome names
# this has to be done in the parent directory of the directory where your files are, or else it won't work properly. The ouput file (called kSNPinputFile) goes into the parent directory as well
MakeKSNP3infile forKSnp kSNPinputFile3 A
MakeKSNP3infile forKSnp kSNPinputFile4 A
MakeKSNP3infile forKSnp kSNPinputFile5 A
# need to make a fasta file with all of the genomes, since Kchooser needs this (kSNP doesnt, but Kchooser does)
# MakeFasta infile_name outfile_name
MakeFasta kSNPinputFile2 actinomycesGenomes2.fasta
MakeFasta kSNPinputFile4 actinomycesGenomes4.fasta
MakeFasta kSNPinputFile5 actinomycesGenomes5.fasta
# first need to run Kchooser to identify the ideal kmer size to use
Kchooser actinomycesGenomes2.fasta
Kchooser actinomycesGenomes4.fasta
Kchooser actinomycesGenomes5.fasta
# try adjusting the cutoff value to 0.98 based on the Kchooser report
Kchooser actinomycesGenomes.fasta 0.98
Kchooser actinomycesGenomes4.fasta 0.98
# run kSNP with kmer value of 21
# use tee to send log info to a file
kSNP3 -in kSNPinputFile3 -k 21 -core -ML -outdir kSNP4 | tee kSNP4Logfile
kSNP3 -in kSNPinputFile4 -k 21 -core -ML -outdir kSNP5 | tee kSNP5Logfile
kSNP3 -in kSNPinputFile5 -k 21 -core -ML -outdir kSNP6 | tee kSNP6Logfile
###############################################################################################################################
# IQ Tree
export PATH=/workdir/miniconda3/bin:$PATH
source activate iqtree #load in iqtree environment

iqtree -s all_for_16S_aln_mafft.fasta-gb -m GTR+G -nt AUTO
