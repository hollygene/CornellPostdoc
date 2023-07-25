# command to run snp-sites
export PATH=/workdir/miniconda3/bin:$PATH
source activate snippy
# mkdir /workdir/hcm59/Ecoli/SNPs/snp_sites
snp-sites -mvp -o /workdir/hcm59/Ecoli/SNPs/dog_verified_host/snps_orig /workdir/hcm59/Ecoli/SNPs/dog_verified_host/core_gene_alignment.aln
