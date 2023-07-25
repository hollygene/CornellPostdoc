#!/bin/bash

input=$1
while IFS= read -r line
do
	echo $line
	./get_contig_lengths.pl ${line}.fna > ${line}_lengths.txt

	#sed 's/Escherichia coli strain.*//' ${line}.fna > ${line}_mod.fna
	cp ${line}.fna ${line}_mod.fna
	sed '/#/d' ${line}.gff > ${line}_mod.gff


	sed -i.bak '/ribosomal slippage/d' ${line}_mod.gff


	echo "##FASTA" >> ${line}_mod.gff

	cat ${line}_lengths.txt ${line}_mod.gff ${line}_mod.fna > ${line}_prokka.gff

	rm *mod*
	rm *lengths.txt
done < "$input"

# to run
# in directory where you have gffs, fna files, and text file of sequence IDs (no file endings) and script get_contig_lengths.pl
# ./get_prokka_style_gff.sh all.txt
