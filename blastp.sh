#blastp on server

# To use SWISSPROT (you need to copy both nr and swissprot to the working directory) :

cp /shared_data/genome_db/BLAST_NCBI/nr* ./

cp /shared_data/genome_db/BLAST_NCBI/swissprot* ./



blastp -outfmt "6 qseqid sseqid sallseqid qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore" \
-query ./dogEcoli_acc_proteins_out.fasta -db swissprot -out ./dog_verified_host_prots_tab_oneSeq.out -num_threads 36 -max_target_seqs 1

# Outputs:
# qseqid means Query Seq-id
# sseqid means Subject Seq-id
# sallseqid means All subject Seq-id(s), separated by a ';'
# qaccver means Query accesion.version
# saccver means Subject accession.version
# pident means Percentage of identical matches
# length means Alignment length
# mismatch means Number of mismatches
# gapopen means Number of gap openings
# qstart means Start of alignment in query
# qend means End of alignment in query
# sstart means Start of alignment in subject
# send means End of alignment in subject
# evalue means Expect value
# bitscore means Bit score



sort -k1,1 -k2,2n dog_verified_host_prots_tab_more.out | sort -u -k1,1  > test.txt

awk '$2>max[$1]{max[$1]=$2; row[$1]=$0} END{for (i in row) print row[i]}' file

# sort by field one and field two (numeric, reverse) so that min for each key will be top of the group,
# pick the first for each key by the second sort.



#    qgi means Query GI
#   qacc means Query accesion
#   qlen means Query sequence length
#    sgi means Subject GI
# sallgi means All subject GIs
#   sacc means Subject accession
# sallacc means All subject accessions
#   slen means Subject sequence length
#   qseq means Aligned part of query sequence
#   sseq means Aligned part of subject sequence
#  score means Raw score
# nident means Number of identical matches
# positive means Number of positive-scoring matches
#   gaps means Total number of gaps
#   ppos means Percentage of positive-scoring matches
# frames means Query and subject frames separated by a '/'
# qframe means Query frame
# sframe means Subject frame
#   btop means Blast traceback operations (BTOP)
# staxid means Subject Taxonomy ID
# ssciname means Subject Scientific Name
# scomname means Subject Common Name
# sblastname means Subject Blast Name
# sskingdom means Subject Super Kingdom
# staxids means unique Subject Taxonomy ID(s), separated by a ';'
#                (in numerical order)
# sscinames means unique Subject Scientific Name(s), separated by a ';'
# scomnames means unique Subject Common Name(s), separated by a ';'
# sblastnames means unique Subject Blast Name(s), separated by a ';'
#                (in alphabetical order)
# sskingdoms means unique Subject Super Kingdom(s), separated by a ';'
#                (in alphabetical order)
#   stitle means Subject Title
# salltitles means All Subject Title(s), separated by a '<>'
#  sstrand means Subject Strand
#    qcovs means Query Coverage Per Subject
#  qcovhsp means Query Coverage Per HSP
#   qcovus means Query Coverage Per Unique Subject (blastn only)
# if it doesnt work try replacing each - by hand on command line
