export PATH=/programs/Anaconda2/bin:$PATH
export LD_LIBRARY_PATH=/programs/Anaconda2/lib:$LD_LIBRARY_PATH

source activate roary

roary

roary_plots.py name_of_your_newick_tree_file.tre gene_presence_absence.csv
