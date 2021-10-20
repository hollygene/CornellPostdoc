# pgap pipeline

mkdir /workdir/$USER
cd /workdir/$USER
wget https://github.com/ncbi/pgap/raw/prod/scripts/pgap.py
chmod uog+x pgap.py
./pgap.py -D singularity --update


phix_assemblies="/workdir/hcm59/Ecoli/fastq_missing_assemblies/phix_contaminated/assemblies_phix_removed"
cd /workdir/$USER
./pgap.py -D singularity -r -o mg37_results test_genomes/MG37/input.yaml
