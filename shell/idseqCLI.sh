# idseq CLI
# add to your path
export PATH=/programs/idseq-cli-v2:$PATH

idseq login
# paste the given link into your browser and then login through there

#accept user agreement
idseq accept-user-agreement
# say y


idseq short-read-mngs upload-sample \
  -p 'panCov_discovery' \
  -s 'Dog_Nasal_071380' \
  -m 'Host Organism=Dog' \
  -m 'Collection Date=04/27/18' \
  -m 'Collection Location=USA' \
  -m 'Sample Type=Nasal_swab' \
  -m 'Nucleotide Type=RNA' \
  -m 'Water Control=No' \
  LG4_071380_18_dognasal_1.fq.gz LG4_071380_18_dognasal_2.fq.gz


idseq short-read-mngs upload-sample \
  -p 'panCov_discovery' \
  -s 'Blue_Jay_710252' \
  -m 'Host Organism=Blue Jay' \
  -m 'Collection Date=10/25/20' \
  -m 'Collection Location=USA' \
  -m 'Sample Type=S' \
  -m 'Nucleotide Type=RNA' \
  -m 'Water Control=No' \
  LG1_bluejay_1.fq.gz LG1_bluejay_2.fq.gz


  idseq short-read-mngs upload-sample \
    -p 'panCov_discovery' \
    -s 'Horse_002173' \
    -m 'Host Organism=Horse' \
    -m 'Collection Date=01/08/18' \
    -m 'Collection Location=USA' \
    -m 'Sample Type=Feces' \
    -m 'Nucleotide Type=RNA' \
    -m 'Water Control=No' \
    LG5_002173_18_horse_1.fq.gz LG5_002173_18_horse_2.fq.gz
