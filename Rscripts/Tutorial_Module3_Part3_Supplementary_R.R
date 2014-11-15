#Tutorial_Part3_Supplementary_R.R

#Malachi Griffith, mgriffit[AT]genome.wustl.edu
#Obi Griffith, ogriffit[AT]genome.wustl.edu
#The Genome Institute, Washington Univerisity School of Medicine
#R tutorial for CBW - Bioinformatics for Cancer Genomics - RNA Sequence Analysis

#Starting from the output of the RNA-seq Tutorial Part 1.

#Install packages and load libraries
#install.packages("ggplot2")
library(ggplot2)
library(gplots)

#If X11 not available, open a pdf device for output of all plots
pdf(file="Tutorial_Part3_Supplementary_R_output.pdf")

#### Basic R usage.

#Lines beginning with "#" are comments.  All other lines should be executed *IN ORDER*
#Copy and paste from this document to the R commandline interface
#OR if running R on a Mac use: <command> <enter>
#OR if running R on a Windows machine use: <ctrl> r

#To learn about any command type: ?command_name  OR  help.search("command_name")
#e.g.    ?read.table

#This tutorial assumes you are running R on your own laptop and therefore the graphics generated can be viewed directly
#If you were running this tutorial in a Linux terminal without X you would write each graph to a file and then open that file
#Every time you execute a 'plot()', 'hist()', 'boxplot()', etc. command, a new window will open to render the graph
#Or if you leave this window open, each time you draw a new graph it will replace the old one
#Similarly, we will often open a graph, and then in subsequent steps add annotation to that graph (legends, labels, etc.)
#I recommend that you just leave the graphics window open and keep viewing it as you go.

#Test your graphics by running the R graphics demo.  
#Press <enter> when prompted, then view the graph and press <enter> to continue to the next graphic
#try this on your own laptop installations of R (it won't work interactively on the Amazon cloud without X11)
#demo(graphics)

#Clean up workspace - i.e. delete variable created by the graphics demo
rm(list = ls(all = TRUE))

#Working with variables in R
x = 5
y = 10
z = x*y

#Create a sequence of numbers and assign this sequence to a variable called 'my_sequence'
my_sequence = 1:13

#The contents of any variable can be printed to the screen by simply typing in the name of the variable and hitting <enter>
#If you do this for a variable that contains a large amount of data, it may take a while for everything to print out
#If you do that by accident, you can abort a command by pressing <esc>
#View the contents of x, y, z, and 'my_sequence'
x
y
z
my_sequence

#List the variables that exist in your current work space
ls()


#### Import the gene expression data from the Tophat/Cufflinks/Cuffdiff tutorial

#Set working directory where results files exist
working_dir = "~/workspace/rnaseq/final_results/tophat_cufflinks/ref_only" 
setwd(working_dir)

#List the current contents of this directory - it is empty right now so it will be displayed as 'character(0)'
dir()

#Import expression and differential expression results from the Bowtie/Samtools/Tophat/Cufflinks/Cuffdiff pipeline
file1="isoforms.read_group_tracking"
file2="isoform_exp.diff"
file3="isoforms.fpkm_tracking"

#Read in tab delimited files and assign the resulting 'dataframe' to a variable
#Use 'as.is' for columns that contain text/character values (i.e. non-numerical values)
all_fpkm = read.table(file1, header=TRUE, sep="\t", as.is=c(1:2,9))
tn_de = read.table(file2, header=TRUE, sep="\t", as.is=c(1:7,14))
tn_fpkm = read.table(file3, header=TRUE, sep="\t", as.is=c(1:9,13,17))


#### Working with 'dataframes'
#View the first five rows of data (all columns) in one of the dataframes created
head(tn_de)

#View the column names
names(tn_de)

#Determine the dimensions of the dataframe.  'dim()' will return the number of rows and columns
dim(tn_de)

#Get the first 3 rows of data and a selection of columns
tn_de[1:3,c(2:4,7,10,12)]

#Do the same thing, but using the column names instead of numbers
tn_de[1:3, c("gene_id","locus","value_1","value_2")]

#Rename some of the columns from ugly names to more human readable names
names(all_fpkm) = c("tracking_id", "condition", "replicate", "raw_frags", "internal_scaled_frags", "external_scaled_frags", "FPKM", "effective_length", "status")
names(tn_de) = c("test_id", "gene_id", "gene_name", "locus", "sample_1", "sample_2", "status", "value_1", "value_2", "fold_change", "test_stat", "p_value", "q_value", "significant")
names(tn_fpkm) = c("tracking_id", "class_code", "nearest_ref_id", "gene_id", "gene_name", "tss_id", "locus", "length", "coverage", "Tumor_FPKM", "Tumor_conf_lo", "Tumor_conf_hi", "Tumor_status", "Normal_FPKM", "Normal_conf_lo", "Normal_conf_hi", "Normal_status")

#Get ID to gene name mapping
gene_mapping=tn_fpkm[,"gene_name"]
names(gene_mapping)=tn_fpkm[,"tracking_id"]

#Reformat per-replicate FPKM data into a standard matrix
UHR_1=all_fpkm[all_fpkm[,"condition"]=="UHR" & all_fpkm[,"replicate"]==0,"FPKM"]
UHR_2=all_fpkm[all_fpkm[,"condition"]=="UHR" & all_fpkm[,"replicate"]==1,"FPKM"]
UHR_3=all_fpkm[all_fpkm[,"condition"]=="UHR" & all_fpkm[,"replicate"]==2,"FPKM"]
HBR_1=all_fpkm[all_fpkm[,"condition"]=="HBR" & all_fpkm[,"replicate"]==0,"FPKM"]
HBR_2=all_fpkm[all_fpkm[,"condition"]=="HBR" & all_fpkm[,"replicate"]==1,"FPKM"]
HBR_3=all_fpkm[all_fpkm[,"condition"]=="HBR" & all_fpkm[,"replicate"]==2,"FPKM"]

#Add ids as row names and gene names as initial column along with all data
ids=unique(all_fpkm[,"tracking_id"])
gene_names=gene_mapping[ids]
fpkm_matrix=data.frame(gene_names,UHR_1,UHR_2,UHR_3,HBR_1,HBR_2,HBR_3)
row.names(fpkm_matrix)=ids 
data_columns=c(2:7)
short_names=c("UHR_1","UHR_2","UHR_3","HBR_1","HBR_2","HBR_3")

#Assign colors to each.  You can specify color by RGB, Hex code, or name
#To get a list of color names:
colours()
data_colors=c("tomato1","tomato2","tomato3","royalblue1","royalblue2","royalblue3")

#View expression values for the transcripts of a particular gene symbol of chromosome 1.  e.g. 'TST'
#First determine the rows in the data.frame that match 'TST', then display only those rows of the data.frame
i = which(fpkm_matrix[,"gene_names"] == "TST")
fpkm_matrix[i,]

#What if we want to view values for a list of genes of interest all at once? 
genes_of_interest = c("TST", "MMP11", "LGALS2", "ISX")
i = which(fpkm_matrix[,"gene_names"] %in% genes_of_interest)
fpkm_matrix[i,]


#### Examine basic features of the differential expression file
#In part 1 of the tutorial, cuffdiff attempted to perform a differential expression test for each row of data (i.e. each gene/transcript)
#However, sometimes this test fails due to insufficient data, etc.  These cases are summarized in the 'status' column
#Summarize the status of all tests
status_counts=table(tn_de[,"status"])
status_counts

#Plot #1 - Make a barplot of these status counts, first using the basic plotting functions of R, and then using the ggplot2 package
barplot(status_counts, col=rainbow(6), xlab="Status", ylab="Transcript count", main="Status counts reported by Cuffdiff")

#Plot #2 - Now the same idea using ggplot2
Status=factor(tn_de[,"status"])
qplot(Status, data=tn_de, geom="bar", fill=Status, xlab="Status", ylab="Transcript count", main="Status counts reported by Cuffdiff")

#Plot #3 - Make a piechart of these status counts, first using the basic plotting functions of R, and then using the ggplot2 package
pie(status_counts, col=rainbow(6), main="Status counts reported by Cuffdiff")

#Plot #4 - Now the same idea using ggplot2
#zz=as.data.frame(status_counts)
#names(zz) = c("Status", "Count")
#pp <- ggplot(zz, aes(x="", y=Count, fill=Status)) + geom_bar(width=1) + coord_polar("y")
#print(pp)
### NOTE: The above needs to be updated as ggplot has changed###

#Plot #5 - Make a dotchart of these status counts
dotchart(as.numeric(status_counts), col=rainbow(6), labels=names(status_counts), xlab="Transcript count", main="Status counts reported by Cuffdiff", pch=16)

#Each row of data represents a transcript. Many of these transcripts represent the same gene. Determine the numbers of transcripts and unique genes  
length(tn_de[,"gene_name"]) #Transcript count
length(unique(tn_de[,"gene_name"])) #Unique Gene count


#### Plot #6 - the number of transcripts per gene.  
#Many genes will have only 1 transcript, some genes will have several transcripts
#Use the 'table()' command to count the number of times each gene symbol occurs (i.e. the # of transcripts that have each gene symbol)
#Then use the 'hist' command to create a histogram of these counts
#How many genes have 1 transcript?  More than one transcript?  What is the maximum number of transcripts for a single gene?
counts=table(tn_de[,"gene_name"])
c_one = length(which(counts == 1))
c_more_than_one = length(which(counts > 1))
c_max = max(counts)
hist(counts, breaks=50, col="bisque4", xlab="Transcripts per gene", main="Distribution of transcript count per gene")
legend_text = c(paste("Genes with one transcript =", c_one), paste("Genes with more than one transcript =", c_more_than_one), paste("Max transcripts for single gene = ", c_max))
legend("topright", legend_text, lty=NULL)


#### Plot #7 - the distribution of transcript sizes as a histogram
#In this analysis we supplied Cufflinks with transcript models so the lengths will be those of known transcripts
#However, if we had used a de novo transcript discovery mode, this step would give us some idea of how well transcripts were being assembled
#If we had a low coverage library, or other problems, we might get short 'transcripts' that are actually only pieces of real transcripts
hist(tn_fpkm[,"length"], breaks=50, xlab="Transcript length (bp)", main="Distribution of transcript lengths", col="steelblue")


#### Summarize FPKM values for all 6 replicates
#What are the minimum and maximum FPKM values for a particular library?
min(fpkm_matrix[,"UHR_1"])
max(fpkm_matrix[,"UHR_1"])

#Get the minimum non-zero FPKM values for use later.
#Do this by grabbing a copy of all data values, coverting 0's to NA, and calculating the minimum or all non NA values
zz = fpkm_matrix[,data_columns]
zz[zz==0] = NA
min_nonzero = min(zz, na.rm=TRUE)
min_nonzero

#### Plot #8 - View the range of values and general distribution of FPKM values for all 4 libraries
#Create boxplots for this purpose
#Display on a log2 scale and add the minimum non-zero value to avoid log2(0)
boxplot(log2(fpkm_matrix[,data_columns]+min_nonzero), col=data_colors, names=short_names, las=2, ylab="log2(FPKM)", main="Distribution of FPKMs for all 4 libraries")
#Note that the bold horizontal line on each boxplot is the median

#### Plot #9 - plot a pair of replicates to assess reproducibility of technical replicates
#Tranform the data by converting to log2 scale after adding an arbitrary small value to avoid log2(0)
x = fpkm_matrix[,"UHR_1"]
y = fpkm_matrix[,"UHR_2"]
plot(x=log2(x+min_nonzero), y=log2(y+min_nonzero), pch=16, col="blue", cex=0.25, xlab="FPKM (UHR, Replicate 1)", ylab="FPKM (UHR, Replicate 2)", main="Comparison of expression values for a pair of replicates")

#Add a straight line of slope 1, and intercept 0
abline(a=0,b=1)

#Calculate the correlation coefficient and display in a legend
rs=cor(x,y)^2
legend("topleft", paste("R squared = ", round(rs, digits=3), sep=""), lwd=1, col="black")

#### Plot #10 - Scatter plots with a large number of data points can be misleading ... regenerate this figure as a density scatter plot
colors = colorRampPalette(c("white", "blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
smoothScatter(x=log2(x+min_nonzero), y=log2(y+min_nonzero), xlab="FPKM (UHR, Replicate 1)", ylab="FPKM (UHR, Replicate 2)", main="Comparison of expression values for a pair of replicates", colramp=colors, nbin=200)


#### Plot all sets of replicates on a single plot
#Create an function that generates an R plot.  This function will take as input the two libraries to be compared and a plot name and color
plotCor = function(lib1, lib2, name, color){
	x=fpkm_matrix[,lib1]
	y=fpkm_matrix[,lib2]
	zero_count = length(which(x==0)) + length(which(y==0))
	plot(x=log2(x+min_nonzero), y=log2(y+min_nonzero), pch=16, col=color, cex=0.25, xlab=lib1, ylab=lib2, main=name)
	abline(a=0,b=1)
	rs=cor(x,y, method="pearson")^2
	legend_text = c(paste("R squared = ", round(rs, digits=3), sep=""), paste("Zero count = ", zero_count, sep=""))
	legend("topleft", legend_text, lwd=c(1,NA), col="black", bg="white", cex=0.8)
}
#Open a plotting page with room for two plots on one page
par(mfrow=c(1,2))

#Plot #11 - Now make a call to our custom function created above, once for each library comparison
plotCor("UHR_1", "HBR_1", "UHR_1 vs HBR_1", "tomato2")
plotCor("UHR_2", "HBR_2", "UHR_2 vs HBR_2", "royalblue2")


##### One problem with these plots is that there are so many data points on top of each other, that information is being lost
#Regenerate these plots using a density scatter plot
plotCor2 = function(lib1, lib2, name, color){
	x=fpkm_matrix[,lib1]
	y=fpkm_matrix[,lib2]
	zero_count = length(which(x==0)) + length(which(y==0))
	colors = colorRampPalette(c("white", "blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
	smoothScatter(x=log2(x+min_nonzero), y=log2(y+min_nonzero), xlab=lib1, ylab=lib2, main=name, colramp=colors, nbin=275)
	abline(a=0,b=1)
	rs=cor(x,y, method="pearson")^2
	legend_text = c(paste("R squared = ", round(rs, digits=3), sep=""), paste("Zero count = ", zero_count, sep=""))
	legend("topleft", legend_text, lwd=c(1,NA), col="black", bg="white", cex=0.8)
}

#### Plot #12 - Now make a call to our custom function created above, once for each library comparison
par(mfrow=c(1,2))
plotCor2("UHR_1", "HBR_1", "UHR_1 vs HBR_1", "tomato2")
plotCor2("UHR_2", "HBR_2", "UHR_2 vs HBR_2", "royalblue2")


#### Compare the correlation 'distance' between all replicates
#Do we see the expected pattern for all eight libraries (i.e. replicates most similar, then tumor vs. normal)?

#Calculate the FPKM sum for all 6 libraries
fpkm_matrix[,"sum"]=apply(fpkm_matrix[,data_columns], 1, sum)

#Identify the genes with a grand sum FPKM of at least 5 - we will filter out the genes with very low expression across the board
i = which(fpkm_matrix[,"sum"] > 5)

#Calculate the correlation between all pairs of data
r=cor(fpkm_matrix[i,data_columns], use="pairwise.complete.obs", method="pearson")

#Print out these correlation values
r

#### Plot #13 - Convert correlation to 'distance', and use 'multi-dimensional scaling' to display the relative differences between libraries
#This step calculates 2-dimensional coordinates to plot points for each library
#Libraries with similar expression patterns (highly correlated to each other) should group together
#What pattern do we expect to see, given the types of libraries we have (technical replicates, biologal replicates, tumor/normal)?
d=1-r
mds=cmdscale(d, k=2, eig=TRUE)
par(mfrow=c(1,1))
plot(mds$points, type="n", xlab="", ylab="", main="MDS distance plot (all non-zero genes)", xlim=c(-0.12,0.12), ylim=c(-0.12,0.12))
points(mds$points[,1], mds$points[,2], col="grey", cex=2, pch=16)
text(mds$points[,1], mds$points[,2], short_names, col=data_colors)

#### Plot #14 - View the distribution of differential expression values as a histogram
#Display only those that are significant according to Cuffdiff
sig = which(tn_de[,"p_value"]<0.05)
de = log2(tn_de[sig,"value_1"]+min_nonzero) - log2(tn_de[sig,"value_2"]+min_nonzero)
tn_de[,"de"] = log2(tn_de[,"value_1"]+min_nonzero) - log2(tn_de[,"value_2"]+min_nonzero)
hist(de, breaks=50, col="seagreen", xlab="Log2 difference (UHR - HBR)", main="Distribution of differential expression values")
abline(v=-2, col="black", lwd=2, lty=2)
abline(v=2, col="black", lwd=2, lty=2)
legend("topleft", "Fold-change > 4", lwd=2, lty=2)


#### Plot #15 - Display the grand expression values from UHR and HBR and mark those that are significantly differentially expressed
x=log2(tn_de[,"value_1"]+min_nonzero)
y=log2(tn_de[,"value_2"]+min_nonzero)
plot(x=x, y=y, pch=16, cex=0.25, xlab="UHR FPKM (log2)", ylab="HBR FPKM (log2)", main="UHR vs HBR FPKMs")
abline(a=0, b=1)
xsig=x[sig]
ysig=y[sig]
points(x=xsig, y=ysig, col="magenta", pch=16, cex=0.5)
legend("topleft", "Significant", col="magenta", pch=16)

#Get the gene symbols for the top N (according to corrected p-value) and display them on the plot
topn = order(abs(tn_de[,"fold_change"]), decreasing=TRUE)[1:25]
topn = order(tn_de[,"q_value"])[1:25]
text(x[topn], y[topn], tn_de[topn,"gene_name"], col="black", cex=0.75, srt=45)


#### Write a simple table of differentially expressed transcripts to an output file
#Each should be significant with a log2 fold-change >= 2
sig = which(tn_de[,"p_value"]<0.05 & abs(tn_de[,"de"]) >= 2)
sig_tn_de = tn_de[sig,]

#Order the output by or p-value and then break ties using fold-change
o = order(sig_tn_de[,"q_value"], -abs(sig_tn_de[,"de"]), decreasing=FALSE)
output = sig_tn_de[o,c("gene_id","gene_name","locus","value_1","value_2","de","p_value")]
write.table(output, file="SigDE.txt", sep="\t", row.names=FALSE, quote=FALSE)

#View selected columns of the first 25 lines of output
output[1:25,c(2,4,5,6,7)]

#You can open the file "SigDE.txt" in Excel, Calc, etc.
#It should have been written to the current working directory that you set at the beginning of the R tutorial
dir()


#### Plot #16 - Create a heatmap to vizualize expression differences between the eight samples
#Define custom dist and hclust functions for use with heatmaps
mydist=function(c) {dist(c,method="euclidian")}
myclust=function(c) {hclust(c,method="average")}

main_title="sig DE Transcripts"
par(cex.main=0.8)
sig_genes=tn_de[sig,"test_id"]
sig_gene_names=gene_mapping[sig_genes]
data=log2(as.matrix(fpkm_matrix[sig_genes,data_columns])+1)
heatmap.2(data, hclustfun=myclust, distfun=mydist, na.rm = TRUE, scale="none", dendrogram="both", margins=c(6,7), Rowv=TRUE, Colv=TRUE, symbreaks=FALSE, key=TRUE, symkey=FALSE, density.info="none", trace="none", main=main_title, cexRow=1, cexCol=1, labRow=sig_gene_names,col=rev(heat.colors(75)))

dev.off()

#The output file can be viewed in your browser at the following url:
#Note, you must replace cbw## with your own amazon instance number (e.g., "cbw01"))
#http://cbw##.ssh01.com/rnaseq/final_results/tophat_cufflinks/ref_only/Tutorial_Part3_Supplementary_R_output.pdf

#To exit R type:
quit(save="no")

