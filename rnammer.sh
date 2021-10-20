# RNAmmer on server

perl /programs/rnammer-1.2/rnammer -S bac -m ssu -gff 186855-17.gff < 186855-17.fasta

export PATH=/programs/bedtools2-2.29.2/bin:$PATH
bedtools getfasta -fi 186855-17.fasta -fo 186855_16S.fasta -bed 186855-17.gff 
