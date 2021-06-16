#spades commands for AHDC server

# Before running SAPDES, execute the following command (once per session, or somewhere in the beginning of a script that launches SPADES):
export OMP_NUM_THREADS=16
# (if you use the -t option of SPADES, change '16' to the number greater or equal to the one specified with that option).
parentDir="/workdir/hcm59/panCoV/Horses/5.24.Run"
/programs/spades/bin/spades.py -o ${parentDir}/ --rnaviral -1 /workdir/hcm59/panCoV/Horses/Horse300bpband_S34_L001_R1_001.fastq.gz -2 /workdir/hcm59/panCoV/Horses/Horse300bpband_S34_L001_R2_001.fastq.gz

# or export PATH=/programs/spades/bin:$PATH then spades.py [options]
/programs/spades/bin/spades.py  --rnaviral -1 ./Undetermined_S0_L001_R1_001.fastq.gz -2 ./Undetermined_S0_L001_R2_001.fastq.gz -o ./out

# see if it works just normally without the rnaviral part
/programs/spades/bin/spades.py -1 ./Undetermined_S0_L001_R1_001.fastq.gz -2 ./Undetermined_S0_L001_R2_001.fastq.gz -o ./out
