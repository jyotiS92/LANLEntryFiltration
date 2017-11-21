#!/usr/bin/env R
YearDist <- read.table("/home/bofa/BOFA/MutationAnalysis/SubC/LANLquery/FileToRead", sep = "\t", na.strings=c("", "NA"))
Header <- read.table("/home/bofa/BOFA/MutationAnalysis/SubC/LANLquery/headerfile", sep = "\t", na.strings=c("", "NA"))
culture <- as.numeric(which(Header == "Culture Method", arr.ind = TRUE))[2]
year <- as.numeric(which(Header == "Sampling Year", arr.ind = TRUE))[2]
country <- as.numeric(which(Header == "Country", arr.ind = TRUE))[2]
tissue <- as.numeric(which(Header == "Sample Tissue", arr.ind = TRUE))[2]
seqlength <- as.numeric(which(Header == "Sequence Length", arr.ind = TRUE))[2]
print("No of records:")
length(YearDist$V1)
print("No. of sequences without sampling year")
sum(is.na(YearDist[year]))
print("No. of sequence without sampling tissue")
summary(YearDist[tissue])[grep("NA's", summary(YearDist[tissue])),]
summary(YearDist[tissue])
print("No. of sequences without sampling country")
summary(YearDist[country])[grep("NA's", summary(YearDist[country])),]
print("Summary of culture information")
summary(YearDist[culture])
transform(table(YearDist[year]))
barplot(table(YearDist[year]), main = "Yearwise distribution of sequences", xlab = "Year", col = "red", las=2)
transform(table(YearDist[country]))
barplot(table(YearDist[country]), las=2, main = "Countrywise distribution of sequences", cex.axis = 0.7)
range(YearDist[seqlength])
bins <-seq(0,10000, by=500)
lengthdist <- cut((YearDist[seqlength])[,1], bins, dig.lab = 6)
lengthdistfinaldata <- transform(table(lengthdist))
lengthdistfinaldata
plot(lengthdistfinaldata$lengthdist, lengthdistfinaldata$Freq, cex.axis = 0.7, las=2, main = "Lengthwise distribution of sequences")
