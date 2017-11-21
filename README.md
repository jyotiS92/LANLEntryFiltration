# LANLEntryFiltration
Filtration of entries downloaded from LANL HIV database

HIV-1 subtype C entries' background information downloaded from LANL database with one sequence per subject criterial along with list 'culture method' and 'sample tissue'

Filtration is performed on the basis of absence of country and sampling year information with and without sampling year. 

**Scripts List:**
1) LANLEntryFiltrationWithStats_withYearFiltration.sh

Filters entries in SourceFiles directory based on sample country and sampling year bases as well as culture method (selects only uncultured/primary). This script changes the country names to two letter country codes as per CountryNamesCodesCompiled.txt file. Statistics and relevant plots are generated with the help of accessory R scripts.

2) LANLEntryFiltrationWithStats_withoutYearFiltration.sh

Filtration similar to 1st script except for 'presence of sampling year' filter.

3) ReportGeneration.R

R markdown code to generate pdf document based on StatGeneration.R code.

4) StatGeneration.R

R code to generate various statistics and plots based on filtered/original entries.

5) Filtercomparison.sh

Simple script to assess entries without year information

6) LANLqueryWrapper.sh

simple wrapper script to run all of above mentioned scripts

**Other required Files:**
1) CountryCodesCompiled.txt

File containing comma separated list of Country names; as they appear in background information downloaded from LANL database followed by two letter ISO country code.  

2) Example_Vif.txt

example source file to be written to SourceFiles folder.


--------------------
Written by: Jyoti Sutar <jyoti.sutar92@gmail.com>  
Dept. of Biochemistry and Virology  
National Institute for Research in Reproductive Health (ICMR), Mumbai, India
