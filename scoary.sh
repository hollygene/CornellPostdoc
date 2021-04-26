# Script for Scoary on hpc cluster
# building conda environment
# source $HOME/miniconda3/bin/activate
# conda -V
# version 4.9.2
# conda update conda
# see list of available python versions 
# conda search "^python$"

# list packages installed in current env
conda list

# conda create -n scoary python=3.9
source activate scoary

# conda install -n scoary six
# pip install scoary
# pip install ete3

# export PYTHONPATH=/programs/scoary/lib/python2.7/site-packages
# export PATH=/programs/scoary/bin:$PATH

conda activate scoary

scoary -t /workdir/hcm59/Ecoli/SNPs/dog_verified_host/dog_verified_host_PhenoForScoary_OxPolRm.csv \
 -g /workdir/hcm59/Ecoli/SNPs/dog_verified_host/gene_presence_absence_roary.csv \
 -o /workdir/hcm59/Ecoli/SNPs/dog_verified_host \
 -n /workdir/hcm59/Ecoli/SNPs/dog_verified_host/iqtree/core_gene_alignment.aln-gb.treefile \
 -s 15 \
 --delimiter , \
 --permute 1000 --threads 10
