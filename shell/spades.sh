#spades commands for AHDC server

# Before running SAPDES, execute the following command (once per session, or somewhere in the beginning of a script that launches SPADES):
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


 /programs/spades/bin/spades.py -o /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/mink710361gel-334005160/assembled \
  --rnaviral -1 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/mink710361gel-334005160/mink710361gel_S9_L001_R1_001.fastq.gz \
  -2 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/mink710361gel-334005160/mink710361gel_S9_L001_R2_001.fastq.gz



/programs/spades/bin/spades.py -o /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/030693-18-1-1-7-334038835/assembled \
 --rnaviral -1 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/030693-18-1-1-7-334038835/030693-18-1-1-7_S32_L001_R1_001.fastq.gz \
 -2 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/030693-18-1-1-7-334038835/030693-18-1-1-7_S32_L001_R2_001.fastq.gz

# see if it works just normally without the rnaviral part
/programs/spades/bin/spades.py -1 ./Undetermined_S0_L001_R1_001.fastq.gz -2 ./Undetermined_S0_L001_R2_001.fastq.gz -o ./out






/programs/spades/bin/spades.py --plasmid -1 /workdir/hcm59/Ecoli/SNPs/GATK_SNP_calling/fastqs/SRR10996853_1.fastq -2 /workdir/hcm59/Ecoli/SNPs/GATK_SNP_calling/fastqs/SRR10996853_2.fastq -o /workdir/hcm59/Ecoli/SNPs/GATK_SNP_calling/fastqs/plasmidSPAdes
