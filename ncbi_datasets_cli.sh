# use ncbi's datasets tool to download assemblies

wget https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets

chmod a+x datasets

./datasets

#for example, download gene with gene-id 672
/workdir/hcm59/datasets download gene GCA_012348725.1
# datasets location
/workdir/hcm59/datasets

!/bin/bash
filename='/workdir/hcm59/Ecoli/panaroo_isolates/assemblies_for_panaroo_jan22_dog_Ecoli.txt'
while read p; do
    # echo "$p"
    /workdir/hcm59/datasets download genome accession $p --dehydrated --filename $p.zip
done < "$filename"

# datasets download genome accession GCF_000001405.39 --dehydrated --filename human_GRCh38_dataset.zip

for file in /workdir/hcm59/actinomyces/ncbi_genomes/*.1.zip
#
do
FBASE=$(basename $file .1.zip)
BASE=${FBASE%.1.zip}

unzip /workdir/hcm59/actinomyces/ncbi_genomes/${BASE}.1.zip -d /workdir/hcm59/actinomyces/ncbi_genomes/${BASE}
#
done


for d in /workdir/hcm59/actinomyces/ncbi_genomes/*/

do

/workdir/hcm59/datasets rehydrate --directory $d

done



mv GCF*/G* ./
