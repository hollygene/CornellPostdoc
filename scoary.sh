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

conda create --name scoary scoary


conda activate scoary

scoary -t /workdir/hcm59/Ecoli/jan22/panaroo/1.26.22/phenoCefCombCorrASTonlyRm.csv \
 -g /workdir/hcm59/Ecoli/jan22/panaroo/1.26.22/gene_presence_absence_roary.csv \
 -o /workdir/hcm59/Ecoli/jan22/panaroo/1.26.22/scoary \
 -n /workdir/hcm59/Ecoli/jan22/panaroo/1.26.22/core_gene_alignment.aln-gb.treefile \
 -s 15 \
 --delimiter , \
 --permute 1000 --threads 10
