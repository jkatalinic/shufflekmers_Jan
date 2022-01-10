#!/bin/bash

# '*' is a wildcard character in bash. It tells the shell to look for files which end in .fastq

#WORKDIR=/Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/RAW_DATA
cd /Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/RAW_DATA

for f in *.fastq
do
	echo " ------------------------- Filtering and mapping... - $f 	----------------------------------"

	nanofilt --length 4100 --maxlength 4700 $f > nanofilt/$f.lenfilt.fastq

	gsed -n '1~4s/^@/>/p;2~4p' nanofilt/$f.lenfilt.fastq > nanofilt/$f.lenfilt.fasta


done