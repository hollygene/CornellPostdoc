## Pipeline for running panaroo

# variables for paths and programs:
scripts="/workdir/hcm59/CornellPostdoc/"
fastas_gffs="/workdir/hcm59/Ecoli/panaroo_isolates/fastas"
results_dir="/workdir/hcm59/Ecoli/panaroo_results"


# set environment
export PATH=/programs/cd-hit-4.8.1:/programs/mafft/bin:$PATH
export PATH=/programs/panaroo-1.2.3/bin:$PATH
export PYTHONPATH=/programs/panaroo-1.2.3/lib/python3.6/site-packages:/programs/panaroo-1.2.3/lib64/python3.6/site-packages

# first need to download the assemblies and make sure we have the correct ones - i.e. correct species and host
# have list of assembly IDs, need to move the files into the proper directory with the following script:
### To move all the files in a directory whose names match a string in a file:
# do this on your own computer, then move the files over to the server
nn=($(cat /Users/hcm59/Box/Holly/Dog_E_coli_project/Nov_Assembly_Download/assemblies_for_panaroo_Nov21_dog_Ecoli.txt))
for x in "${nn[@]}"
do
ls *_genomic.gff.gz|grep "$x"|xargs -I '{}' mv {} /Users/hcm59/Box/Holly/Dog_E_coli_project/Nov_Assembly_Download/panaroo_isolates/fastas # replace ".gff" with ".fasta" for fasta files
done


### next, we need to get the gffs into the proper format for prokka/panroo: (script courtesty of Kristina Ceres)
# make sure your files are gunzipped, or this script won't work:
gunzip *.gz
# make sure to run this in the directory that your .fna and .gff files are located in
for file in ${fastas_gffs}/*.fna

do
FBASE=$(basename $file .fna)
BASE=${FBASE%.fna}

/workdir/hcm59/CornellPostdoc/get_contig_lengths.pl ${BASE}.fna > ${BASE}_lengths.txt
cp ${BASE}.fna ${BASE}_mod.fna
sed '/#/d' ${BASE}.gff > ${BASE}_mod.gff
sed -i.bak '/ribosomal slippage/d' ${BASE}_mod.gff
echo "##FASTA" >> ${BASE}_mod.gff
cat ${BASE}_lengths.txt ${BASE}_mod.gff ${BASE}_mod.fna > ${BASE}_prokka.gff

done

rm *mod*
rm *lengths.txt

### okay now for the fun part, the actual panaroo run
# run panaroo and remove invalid genes (those with stop codons, etc), using 10 threads:
panaroo -i ${fastas_gffs}/*_prokka.gff -o ${results_dir} -t 10 --clean-mode strict
