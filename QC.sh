# quast

# put program in path

export PATH=/programs/quast-5.1.0rc1:$PATH


quast.py contigs_217892.fasta \
               -g contigs_217892.gff


# qc with samtools
 
samtools flagstat
