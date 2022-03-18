
source /programs/Anaconda2/bin/activate roary
cd /workdir/hcm59/Ecoli/jan22/panaroo/1.26.22/

# roary
#
# conda create --name roaryEnv roary
#
# conda install roary


roary_plots.py name_of_your_newick_tree_file.tre gene_presence_absence.csv


python roary_plots.py core_gene_alignment_aln_gb.tre gene_presence_absence_roary.csv

conda deactivate roary 
