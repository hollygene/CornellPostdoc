# to submit a bunch of jobs to the queue
for file in /path/to/your/data/*same.ending # beginning of loop - path to files that all have the same ending

do
  FBASE=$(basename $file same.ending) # tells the loop what the files names are or something
  BASE=${FBASE%same.ending} # similar to above
	OUT="${BASE}_name.sh" # this is what each job script will be called - file name + name of choice
	echo "#!/bin/bash" > ${OUT} # required at top of submission scripts
	echo "#PBS -N ${BASE}_name" >> ${OUT} # required at top of submission scripts
	echo "#PBS -l walltime=12:00:00" >> ${OUT} # required at top of submission scripts
	echo "#PBS -l nodes=1:ppn=1:AMD" >> ${OUT} # required at top of submission scripts
	echo "#PBS -q batch" >> ${OUT} # required at top of submission scripts
	echo "#PBS -l mem=30gb" >> ${OUT} # required at top of submission scripts
	echo "" >> ${OUT} # just a space for readability
	echo "cd ${output_directory}" >> ${OUT} # here's where your script starts
	echo "module load ${picard_module}" >> ${OUT} # load
  echo "module load ${bwa_module}" >> ${OUT} # your
  echo "module load ${samtools_module}" >> ${OUT} # favorite
  echo "module load ${GATK_module}" >> ${OUT} # modules
	echo "" >> ${OUT} # space for readability
	echo "mkdir /path/to/output/TMP" >> ${OUT} # make a dir if you want
	echo "mkdir /path/to/output/name" >> ${OUT} # make another one for function
	echo "cd /path/to/output/name" >> ${OUT} # go to there
  echo "bwa mem -M -t 7 -p /path/to/ref/genome /path/to/your/data/${BASE}same.ending > /path/to/output/name${BASE}.output.file.ending" >> ${OUT} # here's where the body of your script goes

	qsub ${OUT} # submits the script to the queue
              # good luck!
done
