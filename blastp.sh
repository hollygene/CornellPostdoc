#blastp on server

# To use SWISSPROT (you need to copy both nr and swissprot to the working directory) :

cp /shared_data/genome_db/BLAST_NCBI/nr* ./

cp /shared_data/genome_db/BLAST_NCBI/swissprot* ./



blastp -query ./dogEcoli_acc_proteins_out.fasta -db swissprot -out ./dog_verified_host_prots.out
