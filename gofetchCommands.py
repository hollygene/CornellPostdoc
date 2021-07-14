python goFetch_py3.py -g /workdir/hcm59/Ecoli/Scoary_analyses/goFetch/gene_presence_absence_roary.csv -i /workdir/hcm59/Ecoli/Scoary_analyses/goFetch/Amoxicillin.Clavulanic.Acid.INT_15_04_2021_1732.results.csv -d '/workdir/hcm59/Ecoli/Scoary_analyses/goFetch/gff_files/'



usage: goFetch.py [-h] [-g GENES] [-i INPUT] [-d GFFDIR] [--version]

Gene Ontology fetcher for Roary and Scoary outputs.

optional arguments:
	-h, --help            show this help message and exit
	-g GENES, --genes GENES
					Input gene presence/absence table (comma-separated-
					values) from Roary (https:/sanger-
					pathogens.github.io/Roary)
	-i INPUT, --input INPUT
					Input interest gene presence/absence table (comma or
					semicolon-separated-values from Roary or Scoary
	-d GFFDIR, --gffdir GFFDIR
					Path to directory containing all gff files used in the
					Roary analysis.
	--version  		Display version, and exit.



import urllib.request, urllib.error, urllib.parse
url = "https://www.customdomain.com"
d = dict(parameter1="value1", parameter2="value2")
req = urllib.request.Request(url, data=urllib.parse.urlencode(d))
f = urllib.request.urlopen(req)
resp = f.read()


data = urllib.parse.urlencode(d).encode("utf-8")
req = urllib.request.Request(url)
with urllib.request.urlopen(req,data=data) as f:
    resp = f.read()
    print(resp)





data = urllib.parse.urlencode(params).encode("utf-8")
request = urllib.request.Request(url, data)
contact = "hmcqueary@cornell.edu" # Please set your email address here to help us debug in case of problems.
request.add_header('User-Agent', 'Python %s' % contact)
with urllib.request.urlopen(req,data=data) as f:
    resp = f.read()
    print(resp)
response = urllib.request.urlopen(request)
page = response.read(200000)
