
cd /Users/jan/FAKS/PhD/LRR_project/Data/NANOPORE/txtFilters/test/filtered

#Following reads a txt file and copies each name as its own file by reading the name's contents and copying to a specified folder.

while read p; do
  echo "$p"
  cp $p pre_post/
done < post_filt.txt