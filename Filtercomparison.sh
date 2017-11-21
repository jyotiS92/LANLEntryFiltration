#!/bin/bash
#Next two lines of code are for debugging purposes
#set -x
#trap read debug
echo "FileName\nTotalEntries\nWithYearFilter\nWithoutYearFilter\nEntriesDeleted" > Filtercomparison_tmp.txt
for i in ./SourceFiles/*.txt; do
    # getting the file basename
    file=`echo $i | awk -F'[./]' '{print $4}'`
    #total entries in original file without any filtration
    total=`cat ./SourceFiles/$file.txt | awk 'FNR>3' | wc -l`
    #total entries in after filtration for sampling country, year and culture method
    wyf=`cat ./Selected_AccessionNos_final/withYearFilter/$file\_wyf_accessionlist.txt | wc -l`
    #total entries in after filtration for sampling country and culture method
    wyof=`cat ./Selected_AccessionNos_final/withoutYearFilter/$file\_woyf_accessionlist.txt | wc -l`
    #total entries deleted due to year filter
    deleted=$(($wyof - $wyf))
    echo "$file\n$total\n$wyf\n$wyof\n$deleted" >> Filtercomparison_tmp.txt
    done
cat Filtercomparison_tmp.txt | paste - - - - - > Filtercomparison.txt
rm *_tmp.txt
    
    
