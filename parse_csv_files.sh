## Parse csv Scoary outputs and panaroo gene presence/absence files to get list of CDS's that are significantly associated with resistance

# need to map between gene PA and scoary outputs
# Gene in Scoary output file
# to gene in gene PA file, want specific CDS
awk 'NR==FNR {end[$1]; next} ($1 in end)' clavamox_example.csv gene_presence_absence_roary.csv > clavamox_genePA.csv
# print just the first CDS result


# convert the row into a column or output the results into rows
# basically want to go from wide to long format
# want:
# groupID1 CDS1
# groupID1 CDS2
# groupID1 CDS3 ...
# first, print only the columns we want
# find how many columns we even have
awk -F, 'END {printf "Number of Rows : %s\nNumber of Columns = %s\n", NR, NF}' clavamox_genePA.csv
#615
cut -d "," -f 1,15-615 clavamox_genePA.csv > clavamox_genePA_test.csv
# change delimiter for first column
sed 's/,/;/' clavamox_genePA_test.csv > clavamox_genePA_test2.csv

while read -r f1 c1; do
  # split the comma delimited field 'c1' into its constituents
  for c in ${c1//,/ }; do
     printf "$f1 $f2 $f3 $f4 $f5 $c\n"
  done
done < clavamox_genePA_test2.csv > outputTest.csv


# now convert to long format
while read -r f1 c1; do
  # split the comma delimited field 'c1' into its constituents
  for c in ${c1//,/ }; do
     printf "$f1 $f2 $f3 $c\n"
  done
done < input.txt



#!/bin/bash

while read -r f1 f2 f3 c1; do
  # split the comma delimited field 'c1' into its constituents
  for c in ${c1//,/ }; do
     printf "$f1 $f2 $f3 $c\n"
  done
done < input.txt



def parseInputCSVFile(filename):
    #Reads csv file with gene information, wither from Roary or Scoary. Gene group id must be in the first col.
    #Saves gene group ids as key in dictionary.
    geneGroup={}
    Delimiter=detectDelimiter(filename) #detects file delimiter
    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=Delimiter)
        next(reader)
        for row in reader:
            geneGroupID=row[0]
            annotation=row[1]
            otherAnnotation=row[2]
            geneGroup[geneGroupID]=[annotation,otherAnnotation] #initialize dictionary containing annotations
    return geneGroup















def detectDelimiter(csvFile):
    #detect file delimiter, ',' or ';'
    with open(csvFile, 'r') as myCsvfile:
        header=myCsvfile.readline()
        if header.find(";")!=-1:
            return ";"
        if header.find(",")!=-1:
            return ","
    return ";"

def parseInputCSVFile(filename):
    #Reads csv file with gene information, wither from Roary or Scoary. Gene group id must be in the first col.
    #Saves gene group ids as key in dictionary.
    geneGroup={}
    Delimiter=detectDelimiter(filename) #detects file delimiter
    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=Delimiter)
        next(reader)
        for row in reader:
            geneGroupID=row[0]
            annotation=row[1]
            otherAnnotation=row[2]
            geneGroup[geneGroupID]=[annotation,otherAnnotation] #initialize dictionary containing annotations
    return geneGroup


def parsePAGeneFile(filename, dic):
    #parser for Roary's gene_presence_absence.csv file
    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile)
        filenames=next(reader)[14:] #save all filenames
        for row in reader:
            if row[0] in list(dic.keys()):
                #geneID starts in the 15th col
                temp_dic={}
                for item in row[14:]:
                    #check if item is empty, only saves non-empty ids
                    if item == '':
                        continue
                    elif '\t' in item: #in case of paralogs
                        item=item.split('\t')
                        for geneID in item:
                            temp_dic[geneID]=[]
                    else:
                        temp_dic[item]=[]
                dic[row[0]].append(temp_dic)
    return dic, filenames
