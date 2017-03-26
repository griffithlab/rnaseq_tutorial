#Integrated Assignment visualization
#This code is adapted from: Tutorial_Part3_Supplementary_R.R

#Malachi Griffith, mgriffit[AT]wustl.edu
#Obi Griffith, obigriffith[AT]wustl.edu
#Jason Walker, jason.walker[AT]wustl.edu
#McDonnell Genome Institute, Washington University School of Medicine

#R tutorial for Informatics for RNA Sequence Analysis workshops

#Starting from the output of the integrated assignment.

#Load libraries
library(ggplot2)
library(gplots)
library(GenomicRanges)
library(ballgown)

#If X11 not available, open a pdf device for output of all plots
pdf(file="assignment_Supplementary_R_output.pdf")

#Clean up workspace - i.e. delete variable created by the graphics demo
rm(list = ls(all = TRUE))

#Set working directory where results files exist
working_dir = "~/workspace/rnaseq/de/ballgown/ref_only" 
setwd(working_dir)

# List the current contents of this directory
dir()

#Import expression and differential expression results from the HISAT2/StringTie/Ballgown pipeline
load('bg.rda')

# View a summary of the ballgown object
bg

# Load gene names for lookup later in the tutorial
bg_table = texpr(bg, 'all')
bg_gene_names = unique(bg_table[, 9:10])

# Pull the gene_expression data frame from the ballgown object
gene_expression = as.data.frame(gexpr(bg))

data_colors=c("tomato1","tomato2","tomato3","royalblue1","royalblue2","royalblue3")

#View expression values for the transcripts of a particular gene symbol of chromosome 22.  e.g. 'TST'
#First determine the rows in the data.frame that match 'PCA3', aka. ENSG00000225937 , then display only those rows of the data.frame
i = row.names(gene_expression) == "ENSG00000225937"
gene_expression[i,]

# Load the transcript to gene index from the ballgown object
transcript_gene_table = indexes(bg)$t2g
head(transcript_gene_table)

#### Plot #1 - the number of transcripts per gene.  
#Many genes will have only 1 transcript, some genes will have several transcripts
#Use the 'table()' command to count the number of times each gene symbol occurs (i.e. the # of transcripts that have each gene symbol)
#Then use the 'hist' command to create a histogram of these counts
#How many genes have 1 transcript?  More than one transcript?  What is the maximum number of transcripts for a single gene?
counts=table(transcript_gene_table[,"g_id"])
c_one = length(which(counts == 1))
c_more_than_one = length(which(counts > 1))
c_max = max(counts)
hist(counts, breaks=50, col="bisque4", xlab="Transcripts per gene", main="Distribution of transcript count per gene")
legend_text = c(paste("Genes with one transcript =", c_one), paste("Genes with more than one transcript =", c_more_than_one), paste("Max transcripts for single gene = ", c_max))
legend("topright", legend_text, lty=NULL)


#### Plot #2 - the distribution of transcript sizes as a histogram
#In this analysis we supplied StringTie with transcript models so the lengths will be those of known transcripts
#However, if we had used a de novo transcript discovery mode, this step would give us some idea of how well transcripts were being assembled
#If we had a low coverage library, or other problems, we might get short 'transcripts' that are actually only pieces of real transcripts

full_table <- texpr(bg , 'all')
hist(full_table$length, breaks=50, xlab="Transcript length (bp)", main="Distribution of transcript lengths", col="steelblue")

#### Summarize FPKM values for all 6 replicates
#What are the minimum and maximum FPKM values for a particular library?
min(gene_expression[,"FPKM.carcinoma_C02"])
max(gene_expression[,"FPKM.carcinoma_C02"])

#Set the minimum non-zero FPKM values for use later.
#Do this by grabbing a copy of all data values, coverting 0's to NA, and calculating the minimum or all non NA values
#zz = fpkm_matrix[,data_columns]
#zz[zz==0] = NA
#min_nonzero = min(zz, na.rm=TRUE)
#min_nonzero

#Alternatively just set min value to 1
min_nonzero=1

# Set the columns for finding FPKM and create shorter names for figures
data_columns=c(1:6)
short_names=c("CR_1","CR_2","CR_3","NR_1","NR_2","NR_3")

#### Plot #3 - View the range of values and general distribution of FPKM values for all 4 libraries
#Create boxplots for this purpose
#Display on a log2 scale and add the minimum non-zero value to avoid log2(0)
boxplot(log2(gene_expression[,data_columns]+min_nonzero), col=data_colors, names=short_names, las=2, ylab="log2(FPKM)", main="Distribution of FPKMs for all 6 libraries")
#Note that the bold horizontal line on each boxplot is the median


# Calculate the differential expression results including significance
results_genes = stattest(bg, feature="gene", covariate="type", getFC=TRUE, meas="FPKM")
results_genes = merge(results_genes,bg_gene_names,by.x=c("id"),by.y=c("gene_id"))

#### Plot #4 - View the distribution of differential expression values as a histogram
#Display only those that are significant according to Ballgown

sig=which(results_genes$pval<0.05)
results_genes[,"de"] = log2(results_genes[,"fc"])
hist(results_genes[sig,"de"], breaks=50, col="seagreen", xlab="log2(Fold change) carcinoma vs normal", main="Distribution of differential expression values")
abline(v=-2, col="black", lwd=2, lty=2)
abline(v=2, col="black", lwd=2, lty=2)
legend("topleft", "Fold-change > 4", lwd=2, lty=2)

#### Plot #5 - Display the grand expression values from carcinoma and normal and mark those that are significantly differentially expressed
gene_expression[,"carcinoma"]=apply(gene_expression[,c(1:3)], 1, mean)
gene_expression[,"normal"]=apply(gene_expression[,c(4:6)], 1, mean)

x=log2(gene_expression[,"carcinoma"]+min_nonzero)
y=log2(gene_expression[,"normal"]+min_nonzero)
plot(x=x, y=y, pch=16, cex=0.25, xlab="carcinoma FPKM (log2)", ylab="normal FPKM (log2)", main="carcinoma vs normal FPKMs")
abline(a=0, b=1)
xsig=x[sig]
ysig=y[sig]
points(x=xsig, y=ysig, col="magenta", pch=16, cex=0.5)
legend("topleft", "Significant", col="magenta", pch=16)

#Get the gene symbols for the top N (according to corrected p-value) and display them on the plot
topn = order(abs(results_genes[sig,"fc"]), decreasing=TRUE)[1:25]
topn = order(results_genes[sig,"qval"])[1:25]
text(x[topn], y[topn], results_genes[topn,"gene_name"], col="black", cex=0.75, srt=45)


#### Write a simple table of differentially expressed transcripts to an output file
#Each should be significant with a log2 fold-change >= 2
sigpi = which(results_genes[,"pval"]<0.05)
sigp = results_genes[sigpi,]
sigde = which(abs(sigp[,"de"]) >= 2)
sig_tn_de = sigp[sigde,]

#Order the output by or p-value and then break ties using fold-change
o = order(sig_tn_de[,"qval"], -abs(sig_tn_de[,"de"]), decreasing=FALSE)

output = sig_tn_de[o,c("gene_name","id","fc","pval","qval","de")]
write.table(output, file="SigDE_supplementary_R.txt", sep="\t", row.names=FALSE, quote=FALSE)

#View selected columns of the first 25 lines of output
output[1:25,c(1,4,5)]

#You can open the file "SigDE.txt" in Excel, Calc, etc.
#It should have been written to the current working directory that you set at the beginning of the R tutorial
dir()


#### Plot #6 - Create a heatmap to vizualize expression differences between the eight samples
#Define custom dist and hclust functions for use with heatmaps
mydist=function(c) {dist(c,method="euclidian")}
myclust=function(c) {hclust(c,method="average")}

main_title="sig DE Transcripts"
par(cex.main=0.8)
sig_genes=results_genes[sig,"id"]
sig_gene_names=results_genes[sig,"gene_name"]
data=log2(as.matrix(gene_expression[sig_genes,data_columns])+1)
heatmap.2(data, hclustfun=myclust, distfun=mydist, na.rm = TRUE, scale="none", dendrogram="both", margins=c(6,7), Rowv=TRUE, Colv=TRUE, symbreaks=FALSE, key=TRUE, symkey=FALSE, density.info="none", trace="none", main=main_title, cexRow=0.3, cexCol=1, labRow=sig_gene_names,col=rev(heat.colors(75)))


dev.off()

#The output file can be viewed in your browser at the following url:
#Note, you must replace __YOUR_IP_ADDRESS__ with your own amazon instance IP
#http://__YOUR_IP_ADDRESS__/workspace/rnaseq/de/ballgown/ref_only/assignment_Supplementary_R_output.pdf
#To exit R type:
quit(save="no")
