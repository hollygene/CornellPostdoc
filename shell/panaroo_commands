# panaroo commands for dog E coli stuff


# run panaroo and remove invalid genes (those with stop codons, etc), using 10 threads:
panaroo -i *.gff -o results_verified_host --clean-mode strict --remove-invalid-genes -t 10


# get a core gene alignment with the built in mafft aligner, output to the current directory:
panaroo-msa --aligner mafft -a core  -t 20 --verbose -o .
