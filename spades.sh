#spades commands for AHDC server

# Before running SAPDES, execute the following command (once per session, or somewhere in the beginning of a script that launches SPADES):
export OMP_NUM_THREADS=16
# (if you use the -t option of SPADES, change '16' to the number greater or equal to the one specified with that option).

/programs/spades/bin/spades.py -o /workdir/hcm59/panCoV/Horses/Undetermined_from_20210514_FS10000815_19_BPL20321-1120_L001-ds.7d5addaa5b2445dca9fffee5f29a7825/out --rnaviral -1 /workdir/hcm59/panCoV/Horses/Undetermined_from_20210514_FS10000815_19_BPL20321-1120_L001-ds.7d5addaa5b2445dca9fffee5f29a7825/Undetermined_S0_L001_R1_001.fastq.gz -2 /workdir/hcm59/panCoV/Horses/Undetermined_from_20210514_FS10000815_19_BPL20321-1120_L001-ds.7d5addaa5b2445dca9fffee5f29a7825/Undetermined_S0_L001_R2_001.fastq.gz

# or export PATH=/programs/spades/bin:$PATH then spades.py [options]
/programs/spades/bin/spades.py  --rnaviral -1 ./Undetermined_S0_L001_R1_001.fastq.gz -2 ./Undetermined_S0_L001_R2_001.fastq.gz -o ./out

# see if it works just normally without the rnaviral part
/programs/spades/bin/spades.py -1 ./Undetermined_S0_L001_R1_001.fastq.gz -2 ./Undetermined_S0_L001_R2_001.fastq.gz -o ./out
