#blastp on server

# To use SWISSPROT (you need to copy both nr and swissprot to the working directory) :

cp /shared_data/genome_db/BLAST_NCBI/nr* ./

cp /shared_data/genome_db/BLAST_NCBI/swissprot* ./



blastp -outfmt "6 qseqid qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore" -query ./dogEcoli_acc_proteins_out.fasta -db swissprot -out ./dog_verified_host_prots_tab.out



# if it doesnt work try replacing each - by hand on command line 
