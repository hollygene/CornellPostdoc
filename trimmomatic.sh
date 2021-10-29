# trimmomatic commands



java -jar /programs/trimmomatic/trimmomatic-0.39.jar PE -phred33 186855-17_S15_L001_R1_001.fastq 186855-17_S15_L001_R2_001.fastq 186855_R1_001_paired.fastq 186855_R1_001_unpaired.fastq 186855_R2_001_paired.fastq 186855_R2_001_unpaired.fastq ILLUMINACLIP:/programs/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:200

java -jar /programs/trimmomatic/trimmomatic-0.39.jar PE -phred33 187325-19-1-1A_S18_L001_R1_001.fastq 187325-19-1-1A_S18_L001_R2_001.fastq 187325_R1_001_paired.fastq 187325_R1_001_unpaired.fastq 187325_R2_001_paired.fastq 187325_R2_001_unpaired.fastq ILLUMINACLIP:/programs/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:200


java -jar /programs/trimmomatic/trimmomatic-0.39.jar PE -phred33 217892-18-1_S19_L001_R1_001.fastq 217892-18-1_S19_L001_R2_001.fastq 217892_R1_001_paired.fastq 217892_R1_001_unpaired.fastq 217892_R2_001_paired.fastq 217892_R2_001_unpaired.fastq ILLUMINACLIP:/programs/trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:200
