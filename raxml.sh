# RaxML

### Raxml ng
# add to your path
export PATH=/programs/raxml-ng_v1.0.1:$PATH

# check your MSA is good
raxml-ng --check --msa all_for_16S_aln_mafft_3.fasta --model GTR+G+I --prefix T1b

raxml-ng --parse --msa all_for_16S_aln_mafft_3.fasta-gb.fasta --model GTR+G --prefix T2a

raxml-ng --msa all_for_16S_aln_mafft_3.fasta-gb.fasta --model GTR+G+I --prefix T3a --threads 2 --seed 2

raxml-ng --msa all_for_16S_aln_mafft_3.fasta-gb.fasta --model GTR+G --prefix T4 --threads 2 --seed 2 --tree pars{25},rand{25}
raxml-ng --search1 --msa all_for_16S_aln_mafft_3.fasta-gb.fasta --model GTR+G --prefix T5 --threads 2 --seed 2
grep "Final LogLikelihood:" T{3,4,5}.raxml.log
cat T{3,4}.raxml.mlTrees T5.raxml.bestTree > mltrees
raxml-ng --rfdist --tree mltrees --prefix RF

grep "ML tree search #" T5.raxml.log

raxml-ng --bootstrap --msa all_for_16S_aln_mafft_3.fasta-gb.fasta --model GTR+G --prefix T7a --seed 2 --threads 2
raxml-ng --bsconverge --bs-trees T7a.raxml.bootstraps --prefix T9 --seed 2 --threads 2 --bs-cutoff 0.01


raxml-ng --bootstrap --msa all_for_16S_aln_mafft_3.fasta-gb.fasta --model GTR+G --prefix T11 --seed 333 --threads 2 --bs-trees 400

cat T7.raxml.bootstraps T11.raxml.bootstraps > allbootstraps
raxml-ng --bsconverge --bs-trees allbootstraps --prefix T12 --seed 2 --threads 1 --bs-cutoff 0.01

raxml-ng --all --msa all_for_16S_aln_mafft_3.fasta-gb.fasta --model GTR+G+I --tree pars{10} --bs-trees 1000
