#### IQ tree
# put miniconda in your path
export PATH=/workdir/miniconda3/bin:$PATH
source activate iqtree #load in iqtree environment
iqtree -s all_for_16S_aln_mafft_3.fasta -m MFP

iqtree -s /workdir/hcm59/Ecoli/SNPs/dog_verified_host/core_gene_alignment.aln-gb -m GTR+G -nt AUTO
  # nt is number of threads
  # s specifies alignment file to use
  # m specifies what model to use
  # GTR: most general substitution model
  # G: allows different sites to have different substitution rates
  # ASC: want IQTree to run ascertainment bias correction (necessary because SNP data)
