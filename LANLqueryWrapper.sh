#!/bin/bash
echo "The log for this script can be found in the file LANLqueryWrapper_log.txt"
exec &> LANLqueryWrapper_log.txt
sh LANLEntryFiltrationWithStats.sh
sh LANLEntryFiltrationWithStats_withoutYearFilter.sh
sh Filtercomparison.sh

