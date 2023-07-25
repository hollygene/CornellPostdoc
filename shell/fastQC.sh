## FastQC on amplicons

for file in /workdir/hcm59/actinomyces/*paired.fastq

do
FBASE=$(basename $file paired.fastq)
BASE=${FBASE%paired.fastq}

fastqc /workdir/hcm59/actinomyces/${BASE}paired.fastq

done


### MultiQC

export LC_ALL=en_US.UTF-8
export PYTHONPATH=/programs/multiqc-1.10.1/lib64/python3.6/site-packages:/programs/multiqc-1.10.1/lib/python3.6/site-packages
export PATH=/programs/multiqc-1.10.1/bin:$PATH

multiqc /workdir/hcm59/panCoV/RNAseq/*
