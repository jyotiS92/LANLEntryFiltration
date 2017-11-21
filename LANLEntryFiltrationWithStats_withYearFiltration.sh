#!/bin/bash
#Next two lines of code are for debugging purposes
#set -x
#trap read debug
#Making all the necessary directories
mkdir SelectedEntries_final Selected_AccessionNos_final StatReports Source_e
mkdir SelectedEntries_final/withYearFilter Selected_AccessionNos_final/withYearFilter
mkdir StatReports/withYearFilter
mkdir StatReports/withYearFilter/Original StatReports/withYearFilter/Filtered
# Sourcefile folder has all the background information files downloaded from LANL HIV database
for i in ./SourceFiles/*.txt; do
    mkdir tmp
    # Since background information sheets downloaded from LANL are not always in the same order, follwing chunk of code figures out where each field is.
    culture_method=`cat $i | awk 'FNR > 2 {print $0}' | awk -F'\t' ' { for (i = 1; i <= NF; ++i) print i, $i; exit } ' | grep -i 'culture method' | awk '{print $1}'`
    sampling_year=`cat $i | awk 'FNR > 2 {print $0}' | awk -F'\t' ' { for (i = 1; i <= NF; ++i) print i, $i; exit } ' | grep -i 'Sampling Year' | awk '{print $1}'`
    source_country=`cat $i | awk 'FNR > 2 {print $0}' | awk -F'\t' ' { for (i = 1; i <= NF; ++i) print i, $i; exit } ' | grep -i 'Country' | awk '{print $1}'`
    source_tissue=`cat $i | awk 'FNR > 2 {print $0}' | awk -F'\t' ' { for (i = 1; i <= NF; ++i) print i, $i; exit } ' | grep -i 'Sample Tissue' | awk '{print $1}'`
    # Getting the file basename sans filepath
    file=`echo $i | awk -F'[./]' '{print $4}'`
    # Actual filtration step, here we remove entries without sampling year and country followed by anything that isn't a primary cultured or uncultured
    cat $i | awk 'FNR>3{print$0}' | awk -F "\t" -v cm="$culture_method" -v sy="$sampling_year" -v sc="$source_country" -v st="$source_tissue" '$sy!="" && $sc!=""' | grep -e 'uncultured' -e 'primary' > tmp/$file\_selectedentries.txt
    # following file is required by the R scripts
    cat $i | awk 'FNR>3{print$0}' > Source_e/$file\_e.txt
    # header file for R. Note to self: R has issues with # and numbers in text files
    cat $i | awk 'FNR == 3{print$0}' | sed -e "s/\#/No/g" > Source_e/$file\_h
    count=0
    number=0
    # For adding Country codes instead of country names. Makes the output and plots neater 
    nooflines=`cat CountryNamesCodesCompiled.txt| wc -l`
    cat tmp/$file\_selectedentries.txt > tmp/tmp_$number.txt
    cat CountryNamesCodesCompiled.txt | while read -r line
        do
            count=$(( $count + 1 ))
            Name=`echo $line | awk -F "," '{print $1}'` 
            Code=`echo $line | awk -F "," '{print $2}'`
            cat tmp/tmp_$number.txt | sed "s/$Name/$Code/g" > tmp/tmp_$count.txt
            number=$(( $number + 1 ))
        done
    cat tmp/tmp_$nooflines.txt > SelectedEntries_final/withYearFilter/$file\_wyf_selectedentries_e.txt
    # follwing code makes a list of accession numbers for downloading relevant sequences
    cat SelectedEntries_final/withYearFilter/$file\_wyf_selectedentries_e.txt | awk -F "\t" '{print $4}' > Selected_AccessionNos_final/withYearFilter/$file\_wyf_accessionlist.txt
    # modification of statistics generating R script for selected sequences
    cat StatGeneration.R | sed -e "s/FileToRead/SelectedEntries_final\/withYearFilter\/$file\_wyf_selectedentries_e.txt/g" -e "s/headerfile/Source_e\/$file\_h/g" > StatGeneration_selected_tmp.R
    # modification of statistics generating R script for original sequences without year, country and culture filter
    cat StatGeneration.R | sed -e "s/FileToRead/Source_e\/$file\_e.txt/g" -e "s/headerfile/Source_e\/$file\_h/g" > StatGeneration_source_tmp.R    
    rm -rf tmp/ 
    # generating R markdown report 
    Rscript ReportGeneration.R 
    mv StatGeneration_source_tmp.pdf StatReports/withYearFilter/Original/Stats_$file\_wyf_ori.pdf
    mv StatGeneration_selected_tmp.pdf StatReports/withYearFilter/Filtered/Stats_$file\_wyf_sel.pdf
    rm *tmp.R
done
rm -rf Source_e
# Ta da!
