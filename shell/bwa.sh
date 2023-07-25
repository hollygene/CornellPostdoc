# pipeline to remove phix reads, de novo assemble the decontaminated reads, and confirm using blastn

/programs/bwa-0.7.17/bwa
export PATH=/programs/bwa-0.7.17:$PATH
/programs/samtools-1.11/bin/samtools
export PATH=/programs/samtools-1.11/bin:$PATH
java -jar /programs/picard-tools-2.26.1/picard.jar -h
export LD_LIBRARY_PATH=/usr/local/gcc-7.3.0/lib:/usr/local/gcc-7.3.0/lib64
export PATH=/programs/skesa.centos6.9:$PATH

phix="/workdir/hcm59/Ecoli/fastq_missing_assemblies/phix_contaminated/genome.fa"
workdir="/workdir/hcm59/Ecoli/fastq_missing_assemblies/phix_contaminated"


for file in ${workdir}/*_1.fastq

do
FBASE=$(basename $file _1.fastq)
BASE=${FBASE%_1.fastq}

bwa mem ${phix} ${workdir}/${BASE}_1.fastq ${workdir}/${BASE}_2.fastq > ${workdir}/${BASE}_phix.sam
# use samtools to extract out the unmapped reads
samtools view -b -f 4 ${workdir}/${BASE}_phix.sam > ${workdir}/${BASE}_unmapped.bam
# use samtofastq to get the unmapped reads back into fastq format
java -jar /programs/picard-tools-2.26.1/picard.jar SamToFastq \
     I=${workdir}/${BASE}_unmapped.bam \
     FASTQ=${workdir}/${BASE}_unmapped_1.fastq \
     SECOND_END_FASTQ=${workdir}/${BASE}_unmapped_2.fastq

# de novo assemble the unmapped reads using SKESA
skesa --fastq ${workdir}/${BASE}_unmapped_1.fastq,${workdir}/${BASE}_unmapped_2.fastq --cores 4 --memory 48 > ${workdir}/${BASE}.skesa.fa
# compare with original fastqs
skesa --fastq ${workdir}/${BASE}_1.fastq,${workdir}/${BASE}_2.fastq --cores 4 --memory 48 > ${workdir}/${BASE}_orig.skesa.fa

# confirm with blast that there are no more phix contigs
# compare unmapped to original
blastn -query ${workdir}/${BASE}.skesa.fa -db /workdir/hcm59/Ecoli/fastq_missing_assemblies/blast/nt -out ./${BASE}_unmapped.out -num_threads 36 -max_target_seqs 5
blastn -query ${workdir}/${BASE}_orig.skesa.fa -db /workdir/hcm59/Ecoli/fastq_missing_assemblies/blast/nt -out ./${BASE}_orig.out -num_threads 36 -max_target_seqs 5

done
