# Load libraries needed for this analysis
library(ballgown)
library(genefilter)
library(dplyr)
library(devtools)

# Define a path for the output PDF to be written
outfile="~/workspace/rnaseq/de/ballgown/ref_only/Tutorial_Part2_ballgown_output.pdf"

# Load phenotype data
pheno_data = read.csv("UHR_vs_HBR.csv")

# Display the phenotype data
pheno_data

# Load the ballgown object from file
load('bg.rda')

# The load command, loads an R object from a file into memory in our R session. 
# You can use ls() to view the names of variables that have been loaded
ls()

# Print a summary of the ballgown object
bg

# Open a PDF file where we will save some plots. We will save all figures and then view the PDF at the end
pdf(file=outfile)

# Extract FPKM values from the 'bg' object
fpkm = texpr(bg,meas="FPKM")

# View the last several rows of the FPKM table
tail(fpkm)

# Transform the FPKM values by adding 1 and convert to a log2 scale
fpkm = log2(fpkm+1)

# View the last several rows of the transformed FPKM table
tail(fpkm)

# Create boxplots to display summary statistics for the FPKM values for each sample
boxplot(fpkm,col=as.numeric(pheno_data$type)+1,las=2,ylab='log2(FPKM+1)')

# Display the transcript ID for a single row of data
ballgown::transcriptNames(bg)[2763]

# Display the gene name for a single row of data 
ballgown::geneNames(bg)[2763]

# Create a BoxPlot comparing the expression of a single gene for all replicates of both conditions
plot(fpkm[2763,] ~ pheno_data$type, border=c(2,3), main=paste(ballgown::geneNames(bg)[2763],' : ', ballgown::transcriptNames(bg)[2763]),pch=19, xlab="Type", ylab='log2(FPKM+1)')

# Add the FPKM values for each sample onto the plot 
points(fpkm[2763,] ~ jitter(as.numeric(pheno_data$type)), col=as.numeric(pheno_data$type)+1, pch=16)

# Create a plot of transcript structures observed in each replicate and color transcripts by expression level
plotTranscripts(ballgown::geneIDs(bg)[2763], bg, main=c('Gene in sample HBR_Rep1'), sample=c('HBR_Rep1'))
plotTranscripts(ballgown::geneIDs(bg)[2763], bg, main=c('Gene in sample HBR_Rep2'), sample=c('HBR_Rep2'))
plotTranscripts(ballgown::geneIDs(bg)[2763], bg, main=c('Gene in sample HBR_Rep3'), sample=c('HBR_Rep3'))
plotTranscripts(ballgown::geneIDs(bg)[2763], bg, main=c('Gene in sample UHR_Rep1'), sample=c('UHR_Rep1'))
plotTranscripts(ballgown::geneIDs(bg)[2763], bg, main=c('Gene in sample UHR_Rep2'), sample=c('UHR_Rep2'))
plotTranscripts(ballgown::geneIDs(bg)[2763], bg, main=c('Gene in sample UHR_Rep3'), sample=c('UHR_Rep3'))

#plotMeans('TST',bg,groupvar="type",legend=FALSE)

# Close the PDF device where we have been saving our plots
dev.off()

# Exit the R session
quit(save="no")
