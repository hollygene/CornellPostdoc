# file usage in R:
# code below outputs one protein sequence for each accessory gene 
# source("panaroo_protein_fasta_out.R")
# g<- get_prot_seq("gene_data.csv","gene_presence_absence_roary.csv",T)
# write_fasta_out(g, "ecoli_acc_proteins_out.fasta")


library(dplyr)
library(tidyr)

get_prot_seq <- function(path_to_gene_data, path_to_gene_pres_abs, acc_only=T){
  ## inputs:
  #     path_to_gene_data = "path/gene_data.csv"
  #     path_to_gene_pres_abs = "path/gene_presence_absence_roary.csv"
  #     acc_only = T if you want accessory genes sequences, F if you want all gene sequences 
  
  #read in gene data (contains sequences) and gene presence absence matrix
  genedf <- read.csv(path_to_gene_data)
  genepa <- read.csv(path_to_gene_pres_abs)
  n = genepa[1,5]
  #only retain distinct protein sequences (only want one sequence per gene)
  genedf_f <- genedf %>% distinct(prot_sequence,.keep_all=T)
  
  #get gene presence absence matrix in long format
  genepa_l <- suppressWarnings(genepa %>% gather(key = "seqid", val = "annotation_id",-colnames(genepa[1:14]))) 
  
  #combine two dataframes
  genepa_comb <- left_join(genedf_f, genepa_l, by="annotation_id")
  
  #only keep one protein sequence per gene
  genepa_comb <- genepa_comb %>% distinct(Gene, .keep_all=T)
  
  
  if (acc_only == T){
    #keep accessory genes
    genepa_comb <- genepa_comb %>% filter(No..isolates <= n*.95)
  }
  
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
  


