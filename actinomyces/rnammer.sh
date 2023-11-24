# RNAmmer on server

16S_dir="/workdir/hcm59/actinomyces/16S_species_seqs"

for file in /workdir/hcm59/actinomyces/16S_species_seqs/*.fna

do
FBASE=$(basename $file .fna)
BASE=${FBASE%.fna}

perl /programs/rnammer-1.2/rnammer -S bac -m ssu -gff /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}.gff < /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}.fna

export PATH=/programs/bedtools2-2.29.2/bin:$PATH
bedtools getfasta -fi /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}.fna -fo /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}_16S.fasta -bed /workdir/hcm59/actinomyces/16S_species_seqs/${BASE}.gff

done



for file in /workdir/hcm59/actinomyces/troubleshootingNov21/*.fasta

do
FBASE=$(basename $file .fasta)
BASE=${FBASE%.fasta}

perl /programs/rnammer-1.2/rnammer -S bac -m ssu -gff /workdir/hcm59/actinomyces/troubleshootingNov21/16S/${BASE}.gff < /workdir/hcm59/actinomyces/troubleshootingNov21/${BASE}.fasta

export PATH=/programs/bedtools2-2.29.2/bin:$PATH
bedtools getfasta -fi /workdir/hcm59/actinomyces/troubleshootingNov21/${BASE}.fasta -fo /workdir/hcm59/actinomyces/troubleshootingNov21/16S/${BASE}_16S.fasta -bed /workdir/hcm59/actinomyces/troubleshootingNov21/16S/${BASE}.gff

done






for file in /workdir/hcm59/actinomyces/troubleshootingNov21/*.fna

do
FBASE=$(basename $file .fna)
BASE=${FBASE%.fna}

perl /programs/rnammer-1.2/rnammer -S bac -m ssu -gff /workdir/hcm59/actinomyces/troubleshootingNov21/16S/${BASE}.gff < /workdir/hcm59/actinomyces/troubleshootingNov21/${BASE}.fna

export PATH=/programs/bedtools2-2.29.2/bin:$PATH
bedtools getfasta -fi /workdir/hcm59/actinomyces/troubleshootingNov21/${BASE}.fna -fo /workdir/hcm59/actinomyces/troubleshootingNov21/16S/${BASE}_16S.fasta -bed /workdir/hcm59/actinomyces/troubleshootingNov21/16S/${BASE}.gff

done
