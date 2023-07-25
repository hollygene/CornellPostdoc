## AMRFinderPlus commands
# copy software to /workdir/ and set environment
cp -r /programs/amrfinder-3.10.18 /workdir
module load gcc/10.2.0
export PATH=/programs/hmmer/bin:$PATH
export PATH=/workdir/amrfinder-3.10.18:$PATH

# amrfinder -u

# amrfinder -l

fastas="/workdir/hcm59/staphPseud/dogs/"
results="/workdir/hcm59/staphPseud/dogs/AMRFinder"

for file in ${fastas}/*.fna

do
FBASE=$(basename $file .fna)
BASE=${FBASE%.fna}

amrfinder -n ${fastas}/${BASE}.fna -O Staphylococcus_pseudintermedius --plus -o ${results}/${BASE}_AMRFinder.txt

done


# test with one isolate

# amrfinder -n ${fastas}/GCA_020654135.1_PDT000850652.4_genomic.fna -O Escherichia --plus -o ${fastas}/AMRFinder/GCA_020654135.1_PDT000850652.4_genomic_AMRFinder.txt
