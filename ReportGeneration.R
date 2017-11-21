#!/usr/bin/env Rscript
Sys.setenv(RSTUDIO_PANDOC="/usr/lib/rstudio/bin/pandoc")
rmarkdown::render("/home/bofa/BOFA/MutationAnalysis/SubC/LANLquery/StatGeneration_selected_tmp.R", "pdf_document")
rmarkdown::render("/home/bofa/BOFA/MutationAnalysis/SubC/LANLquery/StatGeneration_source_tmp.R", "pdf_document")
