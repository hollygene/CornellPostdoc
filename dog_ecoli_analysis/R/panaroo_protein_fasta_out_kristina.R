# file usage in R:
# code below outputs one protein sequence for each accessory gene 
# source("panaroo_protein_fasta_out.R")



library(dplyr)
library(tidyr)
path_to_gene_data <- "/Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gene_data.csv"
path_to_gene_pres_abs <- "/Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gene_presence_absence_roary.csv"
get_prot_seq <- function(path_to_gene_data, path_to_gene_pres_abs, acc_only){
  ## inputs:
  #     path_to_gene_data = "path/gene_data.csv"
  #     path_to_gene_pres_abs = "path/gene_presence_absence_roary.csv"
  #     acc_only = T if you want accessory genes sequences, F if you want all gene sequences 
  
  #read in gene data (contains sequences) and gene presence absence matrix
  genedf <- read.csv(path_to_gene_data)
  genepa <- read.csv(path_to_gene_pres_abs)
  n = genepa[1,5]
  #only retain distinct protein sequences (only want one sequence per gene)
  # genedf_f <- genedf %>% distinct(prot_sequence,.keep_all=T)
  
  #get gene presence absence matrix in long format
  genepa_l <- suppressWarnings(genepa %>% gather(key = "seqid", val = "annotation_id",-colnames(genepa[1:14]))) 
  test <- genepa_l %>% drop_na(annotation_id)
  #combine two dataframes
  # genepa_comb <- left_join(genedf_f, genepa_l, by="annotation_id")
  test_comb <- left_join(genedf,test,by="annotation_id")
  #only keep one protein sequence per gene
  genepa_comb <- test_comb %>% distinct(Gene, .keep_all=T)
  # if (acc_only == T){
  #   #keep accessory genes
  #   genepa_comb <- genepa_comb %>% filter(No..isolates <= n*.95)
  # }
  
  return(genepa_comb)
} 


write_fasta_out <- function(genepa_comb, path_out){
  # write out protein fasta
  sink(path_out)
  for (i in 1:nrow(genepa_comb)){
    name = noquote(paste(">",genepa_comb[i,9],sep=""))
    cat(name,sep="\n")
    ln <- noquote(as.character(genepa_comb[i,5]))
    cat(ln)
    cat("\n")
  }
  sink()
}
  
g2<- get_prot_seq("/Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gene_data.csv","/Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/gene_presence_absence_roary.csv",F)

write_fasta_out(g2, "/Users/hcm59/Box/Goodman\ Lab/Projects/bacterial\ genomics/Ecoli_dog_AMR_results/dog_verified_host/ecoli_all_proteins_out_corrected.fasta")
