## AMRFinderPlus commands
# copy software to /workdir/ and set environment
cp -r /programs/amrfinder-3.10.5 /workdir/hcm59
module load gcc/10.2.0
export PATH=/programs/hmmer/bin:$PATH
export PATH=/workdir/amrfinder-3.10.5:$PATH

amrfinder -u


for file in /workdir/hcm59/actinomyces/troubleshootingNov21/*.fasta

do
FBASE=$(basename $file .fasta)
BASE=${FBASE%.fasta}

amrfinder -n ${BASE}.fasta -g ${BASE}.gff

done
