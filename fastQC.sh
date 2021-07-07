## FastQC on amplicons

for file in /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/*/*.fastq.gz

do
FBASE=$(basename $file .fastq.gz)
BASE=${FBASE%.fastq.gz}

fastqc /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/*/${BASE}.fastq.gz

done


### MultiQC

export LC_ALL=en_US.UTF-8
export PYTHONPATH=/programs/multiqc-1.10.1/lib64/python3.6/site-packages:/programs/multiqc-1.10.1/lib/python3.6/site-packages
export PATH=/programs/multiqc-1.10.1/bin:$PATH

multiqc /workdir/hcm59/panCoV/6.27.21/covamplicons-258876621/*
