# script for setting up CGE tools on command line

# Go to wanted location for virulencefinder
cd /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker
# Clone and enter the virulencefinder directory
git clone https://bitbucket.org/genomicepidemiology/virulencefinder.git
cd virulencefinder
# Warning: Due to bugs in BioPython 1.74, if you are not using the Docker container, do not use
# that version if not using Python 3.7.

# Build container
docker build -f /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/Dockerfile -t test1 .
docker build -t virulencefinder .
# Run test
docker1 run --rm -it \
       --entrypoint=/test/test.sh virulencefinder

# Go to the directory where you want to store the virulencefinder database
cd /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker
# Clone database from git repository (develop branch)
# git clone https://bitbucket.org/genomicepidemiology/virulencefinder_db.git
cd virulencefinder_db
VIRULENCE_DB=$(pwd)
# Install VirulenceFinder database with executable kma_index program
# python3 INSTALL.py kma_index

docker run -ti --rm -w /output -v ~/[database folder]:/databases -v ~/[folder with input data]:/input -
v ~/[folder to write output files to]:/output goseqit/virulencefinder_goseqit_docker VirulenceFinder -f
/input/[inputfile.fsa] -s [sub database] -k 95 > ~/[path and folder to write output files to]/
log_virulencefinder

docker1 exec -it b12a9812dba7 /usr/bin/tini -- /bin/bash

/usr/src/virulencefinder.py

docker run \
       -v /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder_db/virulence_ecoli.fsa \
       -v /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/workdir \
       virulencefinder -i /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/workdir/GCA_014810185.1_PDT000850675.1_genomic.fna -o /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/workdir -mp blastn -x


docker run \
        -v /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/test/database \
        -v /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/test \
        virulencefinder -i /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/test/test.fsa -o /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/test/ -mp blastn -x -q


virulencefinder -i /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/test/test.fsa -o /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/test/ -mp blastn -x -q

git clone https://bitbucket.org/genomicepidemiology/virulencefinder_db.git
cd virulencefinder_db

docker1 run   \
       -v /workdir/hcm59/CGE_tools/virulencefinder_db:/virulence_ecoli.fsa \
       -v /workdir/hcm59/CGE_tools:/test \
       virulencefinder -i /workdir/hcm59/CGE_tools/test/test.fsa -o /workdir/hcm59/CGE_tools/test/ -mp blastn -x


docker1 run -it \
  -v /workdir/hcm59/CGE_tools/virulencefinder_db \
  -v /workdir/hcm59/CGE_tools:/test \
  virulencefinder -i /workdir/hcm59/CGE_tools/test/test.fsa -o /workdir/hcm59/CGE_tools/test/ -mp blastn -x




docker run --rm -it \
      -v $(pwd)/database \
      -v  \
      virulencefinder -i ./test.fsa -o /Users/hcm59/Box/Holly/Dog_E_coli_project/Docker/virulencefinder/test/ -mp blastn -x -q

316be1a62d9d

docker1 run -d -it biohpc_hcm59/virulencefinder /bin/bash


docker1 import /home/hcm59/virulencefinder.tar

docker1 run -d -it biohpc_hcm59/virulencefinder /bin/bash
docker1 ps -a
docker1 exec -it 69fcada8b8ba /bin/bash

docker1 run -it \
       --entrypoint=/test/test.sh virulencefinder

docker1 exec 69fcada8b8ba virulencefinder -i /workdir/hcm59/CGE_tools/test/test.fsa -o /workdir/hcm59/CGE_tools/test/ -mp blastn -x

virulencefinder -i /workdir/hcm59/CGE_tools/test/test.fsa -o /workdir/hcm59/CGE_tools/test/ -mp blastn -x



# When running the docker file you must mount 2 directories: 1. virulencefinder_db
  # (VirulenceFinder database) downloaded from bitbucket 2. An output/input folder from where
  # the input file can be reached and an output files can be saved. Here we mount the current
  # working directory (using $pwd) and use this as the output directory, the input file should be
  # reachable from this directory as well. The path to the infile and outfile directories should
  # be relative to the monuted current working directory.

       # -i INPUTFILE input file (fasta or fastq) relative to pwd, up to 2 files
       #
       # -o OUTDIR output directory relative to pwd
       #
       # -d DATABASE set a specific database
       #
       # -p DATABASE_PATH set path to database, default is /database
       #
       # -mp METHOD_PATH set path to method (blast or kma)
       #
       # -l MIN_COV set threshold for minimum coverage
       #
       # -t THRESHOLD set threshold for mininum blast identity
       #
       # -tmp temporary directory for storage of the results from the external software
       #
       # -x extended output: Give extented output with allignment files, template and query hits in fasta and a tab seperated file with gene profile results
       #
       # -q don't show results
