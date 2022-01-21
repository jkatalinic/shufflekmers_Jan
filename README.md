# shufflekmers_Jan
Merger between Shuffle_kmers_mono and all other steps of pipeline written by me.

################################ Stage I – Compile all .fastq files into one folder ##################################


Reindex files from each folder:

num=0 ; for f in *.fastq ; do mv "$f" "${f%.fastq}_$num.fastq"; ((num++)); done 

where num should be set to the desired starting index.


Copy all reindexed files into one folder. 
To double-check files all contain reads, count reads by:

for f in *.fastq ; do echo $(cat $f|wc -l)/4|bc ; done




#################### Stage II – Prefilter all .fastq files for relevant reads #####################################

Step 1 – filter for relevant length, convert to .fasta

Run ‘pre-filter_LRRs.sh’ in terminal. Make sure you’re in the directory of the script. Length range: 4100 to 4700 nt. 
Check length of resulting .fasta files:

for f in *.fasta; do grep ">" $f | wc -l; done


Step 2 – combine all .fasta files into one .fasta file

Use cat command.

cat *.fasta > filename.fasta


######################## Stage III – Run modified kmers script, obtain .txt files ####################################

Run with nanofilt-filtered and combined fasta file. 
Run w/ outputkmers3 and ranges3. These split the PRE region into START and PRE, and POST region into POST and END. 
For some reason, the script doesn’t recognise whatever comes last. So to prove POST is there, POST was split into two parts, which allows at least the first portion of POST to be recognised. Same w/ PRE if read is in reverse. 


########################## Stage IV – Filter .txt files ############################################################


Select for txt files which contain at least PRE and POST. Define a length range: 16-18 lines. 

Use grep and VSC. Consult notes from session w/ Nace. Check ‘txtFilters’ folder.


Run varcall.sh in terminal in Visual Studio Code (VSC).

Step 1: rename files w/ mv command
-	Replace everything after first instance of white space w/ .txt.

Step 2: filter out files with duplicate module calls
-	Execute command composed of three piped commands in brackets and save output as variable OUTPUT
o	First one greps regex which looks for M_singledigit or M_doubledigit or M_alphabetical. This then gets ordered w/ ‘sort’, then the occurrences of each get counted w/ uniq. Uniq’s -d prints only those which occur >1 time.
o	If OUTPUT is non-zero (checked by -n), then copy file to fail folder
o	Else, do nothing

Step 3: Select text files of length >15 x < 19 
-	Check wc -l of $f is > 15 AND <19. If so, move file to filtered folder. 

Step 4: remove files w/o PRE
-	For each file, grep for PRE line and store output as PATTERN. If PATTERN is null (check w/ -z), then move file to no_pre folder. Else, do nothing.


Step 5: remove any instance of START and END
-	sed -i overwrites file in its own place. Allows to delete lines in text w/ specified word. /d stands for delete. 

Step 6: select files of length 16 lines
-	check if wc -l of $f is equal to 16. If so, mv command moves file.

Step 7: remove files w/o POST
-	To remove oddball files which have gap instead of POST.
-	Again, grep for POST, then check if null.

Step 8: separate out files which are in sense (PRE), and those in antisense (POSTr)
-	Use same trick as before: grep for POSTr. If output is null, move file to PRE folder, else move to POSTr folder.


 
############################## Stage V - Compile and analyse in R ##############################################

Step 1 – compile filtered .txt files into datatables

Use wrangling_texts_.r scripts from ‘Step_4’ folder. 
Those starting w/ PRE go into one datable. Those starting w/ POSTr, go into another.
PRE data table gets exported as a .Rds file.
POSTr datatable entries get rev complemented.
The two datatables are then combined by calling PRE.Rds in POSTr script. 

Step 2 – analyse 

Obtain plot. 






