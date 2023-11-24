# ectyper

export PATH=/programs/miniconda3/bin:$PATH

source activate ectyper


# ectyper -i [file path] -o [output_dir]
ectyper -i /workdir/hcm59/Ecoli/panaroo_isolates/fastas/fastas  -o /workdir/hcm59/Ecoli/ectyper # for a folder (all files in the folder will be checked by the tool) 

conda deactivate
