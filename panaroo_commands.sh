# panaroo commands for dog E coli stuff
# set environment
export PATH=/programs/cd-hit-4.8.1:/programs/mafft/bin:$PATH
export PATH=/programs/panaroo-1.2.3/bin:$PATH
export PYTHONPATH=/programs/panaroo-1.2.3/lib/python3.6/site-packages:/programs/panaroo-1.2.3/lib64/python3.6/site-packages

gff_dir="/workdir/hcm59/Ecoli/panaroo_isolates/fastas"
results_dir="/workdir/hcm59/Ecoli/panaroo_results"
# mkdir ${results_dir}

# run panaroo and remove invalid genes (those with stop codons, etc), using 10 threads:
panaroo -i ${gff_dir}/*.gff -o ${results_dir} --clean-mode strict --remove-invalid-genes -t 10


# get a core gene alignment with the built in mafft aligner, output to the results directory
# panaroo-msa --aligner mafft -a core  -t 20 --verbose -o ${results_dir}
