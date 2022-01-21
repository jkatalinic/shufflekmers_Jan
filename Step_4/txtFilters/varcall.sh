#!/bin/bash

cd /Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/shufflekmers_Jan/Output/mono_output_130122

# rename by deleting everything after first instance of white space and replacing w/ .txt

for f in *.txt
do
    mv "$f" "${f/ */.txt}"
done


#######################################################################

# find duplicate module calls in each file. Move those with duplicates to fail.
#-n checks if variable is not null.

for f in *.txt
do
    OUTPUT=$(grep -o 'M_[0-9]\|M_[0-9][0-9]\|M_[A-Z]\+' $f | sort | uniq -d)
    
    if [[ -n $OUTPUT ]]
    then
        mv $f fail
    else
        :
    fi
done
echo "Moved some files to fail folder!"





#######################################################################

#if number of lines of file is greater than 15 and lower than 19, move file to filtered.

for f in *.txt
do
    if [[ "$(wc -l < "$f")" -gt "15" && "$(wc -l < "$f")" -lt "19" ]]
    then 
        mv $f filtered
    fi
done
echo "Copied txt files of desired length to filtered folder!"



#The above in one-liner format:
#for f in *.txt; do if [[ "$(wc -l < "$f")" -gt "15" && "$(wc -l < "$f")" -lt "19" ]]; then cp $f filtered; fi; done



#######################################################################

cd /Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/shufflekmers_Jan/Output/mono_output_130122/filtered

# filter out files w/o PRE module. 
# -z checks if variable is null.

for f in *.txt
do
    PATTERN=$(grep -e 'PRE' $f)
    if [[ -z $PATTERN ]]
    then
        mv $f no_pre
    else
        :
    fi
done

echo "moved files lacking 'PRE' !"


#######################################################################

#remove any instance of START and END from each file.

for f in *.txt
do
    sed -i '' '/START/d' $f
    sed -i '' '/END/d' $f
done

echo "removed all 'START's and 'END's !" 


#######################################################################

# select files of 16 lines in length.

for f in *.txt
do
    if [[ "$(wc -l < "$f")" -eq "16" ]]
    then
        mv $f 16lines
    fi
done

echo "moved 16-line long txt files to new folder !"

#######################################################################

cd /Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/shufflekmers_Jan/Output/mono_output_130122/filtered/16lines

# filter out files w/o POST.

for f in *.txt
do
    PATTERN2=$(grep -e 'POST' $f)
    if [[ -z $PATTERN2 ]]
    then
        mv $f no_post
    else
        :
    fi
done

echo "moved files lacking 'POST' !"


#######################################################################

# separate out files which are in sense (PRE), and those in antisense (POSTr)

for f in *.txt
do
    PATTERN3=$(grep -e 'POSTr' $f)
    if [[ -z $PATTERN3 ]]
    then
        mv $f PRE
    else
        mv $f POSTr
    fi
done

echo " Organised files according to direction !"


