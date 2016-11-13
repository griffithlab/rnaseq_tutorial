library(ballgown)
library(genefilter)
library(dplyr)
library(devtools)

outfile="~/workspace/rnaseq/de/ballgown/ref_only/Tutorial_Part2_ballgown_output.pdf"

# Load phenotype data
pheno_data = read.csv("UHR_vs_HBR.csv")

# Load the ballgown object from file
load('bg.rda')

pdf(file=outfile)

# print a summary of the ballgown object
bg

fpkm = texpr(bg,meas="FPKM")

fpkm = log2(fpkm+1)

boxplot(fpkm,col=as.numeric(pheno_data$type),las=2,ylab='log2(FPKM+1)')

ballgown::transcriptNames(bg)[12]

ballgown::geneNames(bg)[12]

plot(fpkm[12,] ~ pheno_data$type, border=c(1,2), main=paste(ballgown::geneNames(bg)[12],' : ', ballgown::transcriptNames(bg)[12]),pch=19, xlab="Type", ylab='log2(FPKM+1)')

points(fpkm[12,] ~ jitter(as.numeric(pheno_data$type)), col=as.numeric(pheno_data$type))

plotTranscripts(ballgown::geneIDs(bg)[1729], bg, main=c('Gene in sample HBR_Rep1'), sample=c('HBR_Rep1'))

plotMeans('TST',bg,groupvar="type",legend=FALSE)

dev.off()

quit(save="no")
