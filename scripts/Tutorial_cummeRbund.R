#Jason Walker, jason.walker[AT]wustl.edu
#Malachi Griffith, mgriffit[AT]wustl.edu
#Obi Griffith, obigriffith[AT]wustl.edu
#The McDonnell Genome Institute, Washington University School of Medicine

#R tutorial for Informatics for RNA-sequence Analysis workshops


# Optional:
# Install cummeRbund library - this should have been done already
#source("http://bioconductor.org/biocLite.R")
#biocLite("cummeRbund")

# Load cummeRbund library
library(cummeRbund)

#A recent overhaul of RSQLite (update to version 1.0.0 on October 25th, 2014) broke number of cummeRbund functions
#This version of the package no longer contains the function used by cummeRbund called "sqliteQuickSQL" and others
#The authors of cummeRbund are working on fixes
#See http://seqanswers.com/forums/showthread.php?t=47785&page=2
#The following is a temporary workaround
sqliteQuickSQL<-dbGetQuery
dbBeginTransaction<-dbBegin

# Set the paths to cuffdiff/cuffmerge output
# Change these paths if you wish to produce cummeRbund output for different cuffdiff runs (e.g., using STAR alignments)
refCuffdiff="~/workspace/rnaseq/de/tophat_cufflinks/ref_only"
gtfFilePath="~/workspace/rnaseq/expression/tophat_cufflinks/ref_only/merged/merged.gtf"
genomePath="~/workspace/data/fasta/GRCh38/chr22_with_ERCC92.fa"
outfile="~/workspace/rnaseq/de/tophat_cufflinks/ref_only/Tutorial_Part2_cummeRbund_output.pdf"
outfile2="~/workspace/rnaseq/de/tophat_cufflinks/ref_only/Tutorial_Part2_cummeRbund_output_extras.pdf"

# read in Cufflinks output
cuff <- readCufflinks(dir=refCuffdiff,rebuild=T,gtfFile=gtfFilePath,genome=genomePath)

# show the data structures contained in cuff object
cuff

#Set pdf device
pdf(file=outfile)

# Plot #1 - A density plot of FPKM across sample replicates
densRep<-csDensity(genes(cuff),replicates=T)
densRep

# Plot #2 - A box plot of FPKM across sample replicates
brep<-csBoxplot(genes(cuff),replicates=T)
brep

# Plot #3 - A single scatter comparing UHR vs HBR
sampleScatter<-csScatter(genes(cuff),"UHR","HBR",smooth=T)
sampleScatter

# Plot #4 - An MAplot of UHR vs HBR
m<-MAplot(genes(cuff),"UHR","HBR")
m

# Plot #5 - A volcano plot of p-value and fold_change per sample
v<-csVolcano(genes(cuff),"UHR","HBR",alpha=0.05)
v


# Plot #6 - Using k-means clustering a dendrogram of the distance between sample replicates
dend.rep<-csDendro(genes(cuff),replicates=T)

# Plot #7 - A heatmap of sample replicate distace based on JS distance
myRepDistHeat<-csDistHeat(genes(cuff),replicates=T)
myRepDistHeat

# Plot #8 - Principal Component Analysis of all genes across each sample
genes.PCA<-PCAplot(genes(cuff),"PC1","PC2")
genes.PCA

# Plot #9 - MDS scaling of all genes across sample replicates
genes.MDS.rep<-MDSplot(genes(cuff),replicates=T)
genes.MDS.rep
	
# Get the gene ids of the significant (FDR <5%) differentially expressed genes
mySigGeneIds<-getSig(cuff,alpha=0.05,level='genes')

# The ids of the first n genes
head(mySigGeneIds)

# The total number of significant differentially expressed genes
length(mySigGeneIds)

# Grab a geneSet including only those genes with an FDR <5%
mySigGenes<-getGenes(cuff,mySigGeneIds)

# Summarize the geneSet data structure
mySigGenes

# Plot #10 - A heatmap of significant differentially expressed genes
sigHeat<-csHeatmap(mySigGenes,cluster='both',labRow=F)
sigHeat

# Grab a single gene of interest
myGeneId<-"TST"
myGene<-getGene(cuff,myGeneId)
myGene

#Summarize the gene and isoform level FPKM values for this gene
head(fpkm(myGene))
head(fpkm(isoforms(myGene)))

# Plot #11 - gene-level expression levels for UHR vs HBR
gl.rep<-expressionPlot(myGene,replicates=TRUE)
gl.rep

# Plot #12 - isoform-level expression levels for UHR vs HBR
gl.iso.rep<-expressionPlot(isoforms(myGene),replicates=T)
gl.iso.rep

#Summarize individual features for this gene
head(features(myGene))

# Plot #13 - Create a visual representation of the isoforms of a gene
genetrack<-makeGeneRegionTrack(myGene)
plotTracks(genetrack)

# Plot #14 - Add an ideogram for relevant chromosome and the gene's position on chromosome
#Plot cufflinks features for the gene plus known isoforms for gene region with 2kb flanking region
###NOTE several of the track plotting functions below are currently broken.###
trackList<-list()
myStart<-min(features(myGene)$start)
myEnd<-max(features(myGene)$end)
myChr<-unique(features(myGene)$seqnames)
genome<-'hg19'
#ideoTrack<-IdeogramTrack(genome=genome,chromosome=myChr)
#trackList<-c(trackList,ideoTrack)
axtrack<-GenomeAxisTrack()
trackList<-c(trackList,axtrack)
genetrack<-makeGeneRegionTrack(myGene)
genetrack
trackList<-c(trackList,genetrack)
#biomTrack<-BiomartGeneRegionTrack(genome=genome,chromosome=as.character(myChr),start=myStart,end=myEnd,name="ENSEMBL",showId=T)
#trackList<-c(trackList,biomTrack)

#Add conservation levels
#conservation<-UcscTrack(genome="hg19",chromosome=myChr,track="Conservation",table="phyloP100wayAll",from=myStart-2000,to=myEnd+2000,trackType="DataTrack",start="start",end="end",data="score",type="hist",window="auto",col.histogram="darkblue",fill.histogram="darkblue",ylim=c(-3.7,4),name="Conservation")
#trackList<-c(trackList,conservation)
plotTracks(trackList,from=myStart-2000,to=myEnd+2000)

#Close pdf device - necessary before you can open it in your browser
dev.off()

#The output file can be viewed in your browser at the following url:
#Note, you must replace __YOUR_IP_ADRESS__ with your own amazon instance number IP (ex. 101.0.1.101)
#http://__YOUR_IP_ADDRESS__/workspace/rnaseq/de/tophat_cufflinks/ref_only/Tutorial_Part2_cummeRbund_output.pdf

#Additional plot examples to try on your own:

#Set pdf device
pdf(file=outfile2)

# generate dispersion plot (observed vs theoretical variance)
disp<-dispersionPlot(genes(cuff))
disp

# A count based MAplot of UHR vs HBR (use counts instead of FPKM)
mCount<-MAplot(genes(cuff),"UHR","HBR",useCount=T)
mCount

# A volcano matrix per sample
vMatrix<-csVolcanoMatrix(genes(cuff))
vMatrix

# A distribution of siginificant features per condition
mySigMat<-sigMatrix(cuff,level='genes',alpha=0.05)
mySigMat

# PCA of all genes across each sample replicate
genes.PCA.rep<-PCAplot(genes(cuff),"PC1","PC2",replicates=T)
genes.PCA.rep

#Plot CDS-level expression levels for UHR vs HBR
gl.cds.rep<-expressionPlot(CDS(myGene),replicates=T)
gl.cds.rep

#Many more... see cummeRbund documentation

#Close pdf device - necessary before you can open it in your browser
dev.off()

#The output file can be viewed in your browser at the following url:
#Note, you must replace __YOUR_IP_ADRESS__ with your own amazon instance IP
#http://__YOUR_IP_ADDRESS__/workspace/rnaseq/de/tophat_cufflinks/ref_only/Tutorial_Part2_cummeRbund_output_extras.pdf

#To exit R type:
quit(save="no")

#The following plots no longer work in the current cummeRbund. They could possibly be reworked:

#Barplot of gene-level expression levels for UHR vs HBR
#gb<-expressionBarplot(myGene)
#gb

#Barplot of gene-level expression levels for UHR vs HBR, by replicate
#gb.rep<-expressionBarplot(myGene,replicates=T)
#gb.rep

#Barplot of isoform-level expression levels for UHR vs HBR, by replicate
#igb<-expressionBarplot(isoforms(myGene),replicates=T)
#igb

