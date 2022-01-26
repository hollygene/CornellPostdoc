# staramr scripts

# install through bioconda
# in a separate environment to prevent dependency conflicts
conda create -c bioconda --name staramr staramr==0.7.2

source activate staramr
staramr --help


# to update the databases
staramr db update --update-default

# check what database you are using
staramr db info

# run staramr
staramr search -o /workdir/hcm59/staphPseud/staramr_out/human *.fna
