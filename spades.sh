#spades commands for AHDC server

# Before running SAPDES, execute the following command (once per session, or somewhere in the beginning of a script that launches SPADES):
export OMP_NUM_THREADS=16
# (if you use the -t option of SPADES, change '16' to the number greater or equal to the one specified with that option).
parentDir="/workdir/hcm59/panCoV/6.27.21/covamplicons-258876621"



/programs/spades/bin/spades.py -o /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/028588-18-1-2-1-334025032/assembled \
 --rnaviral -1 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/ /028588-18-1-2-1_S28_L001_R1_001.fastq.gz \
 -2 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/023753-18-1-1-2b-334009082/023753-18-1-1-2b_S26_L001_R2_001.fastq.gz


 /programs/spades/bin/spades.py -o /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/mink710361gel-334005160/assembled \
  --rnaviral -1 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/mink710361gel-334005160/mink710361gel_S9_L001_R1_001.fastq.gz \
  -2 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/mink710361gel-334005160/mink710361gel_S9_L001_R2_001.fastq.gz



/programs/spades/bin/spades.py -o /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/030693-18-1-1-7-334038835/assembled \
 --rnaviral -1 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/030693-18-1-1-7-334038835/030693-18-1-1-7_S32_L001_R1_001.fastq.gz \
 -2 /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/030693-18-1-1-7-334038835/030693-18-1-1-7_S32_L001_R2_001.fastq.gz

# see if it works just normally without the rnaviral part
/programs/spades/bin/spades.py -1 ./Undetermined_S0_L001_R1_001.fastq.gz -2 ./Undetermined_S0_L001_R2_001.fastq.gz -o ./out






/programs/spades/bin/spades.py --plasmid -1 /workdir/hcm59/Ecoli/SNPs/GATK_SNP_calling/fastqs/SRR10996853_1.fastq -2 /workdir/hcm59/Ecoli/SNPs/GATK_SNP_calling/fastqs/SRR10996853_2.fastq -o /workdir/hcm59/Ecoli/SNPs/GATK_SNP_calling/fastqs/plasmidSPAdes
