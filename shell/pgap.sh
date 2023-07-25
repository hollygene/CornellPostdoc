# pgap pipeline

mkdir /workdir/$USER
cd /workdir/$USER
wget https://github.com/ncbi/pgap/raw/prod/scripts/pgap.py
chmod uog+x pgap.py
./pgap.py -D singularity --update


phix_assemblies="/workdir/hcm59/Ecoli/fastq_missing_assemblies/phix_contaminated/assemblies_phix_removed"
cd /workdir/$USER
./pgap.py -D singularity -r -o /workdir/hcm59/Ecoli/pgap_results /workdir/hcm59/CornellPostdoc/input_SRR12744009.yaml
