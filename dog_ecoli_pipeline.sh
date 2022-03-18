# entire dog e coli pipeline/tools used

################################################################################################
## Pipeline for running panaroo
################################################################################################

# variables for paths and programs:
scripts="/workdir/hcm59/CornellPostdoc/"
fastas_gffs="/workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas"
results_dir="/workdir/hcm59/Ecoli/jan22/panaroo"

# with conda
conda install -c bioconda panaroo
# create environment with panaroo package in it
conda create --name panaroo panaroo
conda activate panaroo

################################################################################################
# first need to download the assemblies and make sure we have the correct ones - i.e. correct species and host
# have list of assembly IDs, need to move the files into the proper directory with the following script:
### To move all the files in a directory whose names match a string in a file:
# nn=($(cat /Users/hcm59/Box/Holly/Dog_E_coli_project/jan22/assemblies_for_panaroo_jan22_dog_Ecoli.txt))
# for x in "${nn[@]}"
# do
# ls *_genomic.fna|grep "$x"|xargs -I '{}' mv {} /Users/hcm59/Box/Holly/Dog_E_coli_project/jan22/fastas # replace ".gff" with ".fasta" for fasta files
# done
#
# # remove files from directory that match the list of files we want to remove
# nn=($(cat /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/gffs_remove.txt))
# for x in "${nn[@]}"
# do
# ls *_genomic.gff|grep "$x"|xargs -I '{}' mv {} /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/remove # replace ".gff" with ".fasta" for fasta files
# done

### next, we need to get the gffs into the proper format for prokka/panroo: (script courtesty of Kristina Ceres)
# make sure your files are gunzipped, or this script won't work:
# gunzip *.gz
# make sure to run this in the directory that your .fna and .gff files are located in
for file in /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/*.fna

do
FBASE=$(basename $file .fna)
BASE=${FBASE%.fna}


./get_contig_lengths.pl /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}.fna > /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_lengths.txt

cp /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}.fna /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_mod.fna

sed '/#/d' /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}.gff > /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_mod.gff

sed -i.bak '/ribosomal slippage/d' /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_mod.gff

echo "##FASTA" >> /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_mod.gff

cat /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_lengths.txt /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_mod.gff /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_mod.fna > /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/${BASE}_prokka.gff

done

rm *mod*
rm *lengths.txt

################################################################################################
conda activate panaroo
### okay now for the fun part, the actual panaroo run
# run panaroo and remove invalid genes (those with stop codons, etc), using 10 threads:
panaroo -i /workdir/hcm59/Ecoli/panaroo_isolates/fastas/jan22/fastas/*.gff -o /workdir/hcm59/Ecoli/jan22/panaroo/1.26.22 -t 20 --clean-mode strict --remove-invalid-genes

# get a core gene alignment with the built in mafft aligner, output to the results directory
panaroo-msa --aligner mafft -a core  -t 20 --verbose -o /workdir/hcm59/Ecoli/jan22/panaroo/1.26.22

#Gblocks commands

export PATH=/programs/Gblocks_0.91b:$PATH

Gblocks core_gene_alignment.aln -t=d -n=y -u=y -d=y
# t=d: type is DNA
# n=y: nonconserved blocks
# u=y: ungapped alignment
# d=y: postscript file with the selected blocks

################################################################################################
## Pipeline for running IQTree
################################################################################################
export PATH=/workdir/miniconda3/bin:$PATH
source activate iqtree #load in iqtree environment

iqtree -s core_gene_alignment.aln-gb -m GTR+G -nt AUTO
  # nt is number of threads
  # s specifies alignment file to use
  # m specifies what model to use
  # GTR: most general substitution model
  # G: allows different sites to have different substitution rates

  ################################################################################################
  ## Pipeline for running Scoary
  ################################################################################################

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
################################################################################################
# Run AMRFinder on all isolates
cp -r /programs/amrfinder-3.10.18 /workdir
module load gcc/10.2.0
export PATH=/programs/hmmer/bin:$PATH
export PATH=/workdir/amrfinder-3.10.18:$PATH

# amrfinder -u

# amrfinder -l

results="/workdir/hcm59/Ecoli/jan22/AMRFinder"

for file in ${fastas_gffs}/*.fna

do
FBASE=$(basename $file .fna)
BASE=${FBASE%.fna}

amrfinder -n ${fastas_gffs}/${BASE}.fna -O Escherichia --plus -o ${results}/${BASE}_AMRFinder.txt

done


################################################################################################
# to get heatmap of gene presence/absence from roary
################################################################################################

python roary_plots.py core_gene_alignment.aln-gb.treefile gene_presence_absence_roary.csv

################################################################################################
# hAMRonization
# program to put AMRFinder results together into one report
# install using conda
conda create --name hamronization --channel conda-forge --channel bioconda --channel defaults hamronization
conda activate hamronization

################################################################################################
# to prune a phylogenetic tree
################################################################################################
conda install -c bioconda gotree
