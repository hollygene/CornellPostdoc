# plasforest installation into conda environment + execution

# double-check conda is running/installed
conda --version

git clone https://github.com/leaemiliepradier/PlasForest
pip install --user biopython numpy pandas joblib scikit-learn==0.22.2.post1

wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.10.1+-x64-linux.tar.gz
tar -zxvf ncbi-blast-2.10.1+-x64-linux.tar.gz
export PATH=$HOME/ncbi-blast-2.10.1+/bin:$PATH
export PATH=/programs/ncbi-blast-2.9.0+/bin:$PATH

cd PlasForest/
tar -zxvf plasforest.sav.tar.gz

python3 PlasForest.py -i /path/to/your/inputfile.fasta
