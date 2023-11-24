# barrnap

conda install -c bioconda -c conda-forge barrnap


barrnap -o Actinomyces_dentalis_barrnap_2.fasta < GCF_000429225.1_ASM42922v1_genomic.fna > rrna_Actinomyces_dentalis_2.gff




barrnap -k bac -o 186855_rrna.fa < /workdir/hcm59/actinomyces/assembled/assemblies/contigs_186855.fasta > /workdir/hcm59/actinomyces/assembled/assemblies/186855_rrna.gff
head -n 3 186855_rrna.fa 
