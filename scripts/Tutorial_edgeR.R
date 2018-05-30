#Malachi Griffith, mgriffit[AT]wustl.edu
#Obi Griffith, obigriffith[AT]wustl.edu
#The McDonnell Genome Institute, Washington University School of Medicine

#R tutorial for Informatics for RNA-sequence Analysis workshops

#######################
# Loading Data into R #
#######################

#Set working directory where output will go
working_dir = "~/workspace/rnaseq/de/htseq_counts"
setwd(working_dir)

#Read in gene mapping
mapping=read.table("~/workspace/rnaseq/de/htseq_counts/ENSG_ID2Name.txt", header=FALSE, stringsAsFactors=FALSE, row.names=1)

# Read in count matrix
rawdata=read.table("~/workspace/rnaseq/expression/htseq_counts/gene_read_counts_table_all_final.tsv", header=TRUE, stringsAsFactors=FALSE, row.names=1)

# Check dimensions
dim(rawdata)

# Require at least 25% of samples to have count > 25
quant <- apply(rawdata,1,quantile,0.75)
keep <- which((quant >= 25) == 1)
rawdata <- rawdata[keep,]
dim(rawdata)

#################
# Running edgeR #
#################

# load edgeR
library('edgeR')

# make class labels
class <- factor( c( rep("UHR",3), rep("HBR",3) ))

# Get common gene names
genes=rownames(rawdata)
gene_names=mapping[genes,1]


# Make DGEList object
y <- DGEList(counts=rawdata, genes=genes, group=class)
nrow(y)

# TMM Normalization
y <- calcNormFactors(y)

# Estimate dispersion
y <- estimateCommonDisp(y, verbose=TRUE)
y <- estimateTagwiseDisp(y)

# Differential expression test
et <- exactTest(y)

# Print top genes
topTags(et)

# Print number of up/down significant genes at FDR = 0.05  significance level
summary(de <- decideTestsDGE(et, p=.05))
detags <- rownames(y)[as.logical(de)]


# Output DE genes
# Matrix of significantly DE genes
mat <- cbind(
 genes,gene_names,
 sprintf('%0.3f',log10(et$table$PValue)),
 sprintf('%0.3f',et$table$logFC)
)[as.logical(de),]
colnames(mat) <- c("Gene", "Gene_Name", "Log10_Pvalue", "Log_fold_change")

# Order by log fold change
o <- order(et$table$logFC[as.logical(de)],decreasing=TRUE)
mat <- mat[o,]

# Save table
write.table(mat, file="DE_genes.txt", quote=FALSE, row.names=FALSE, sep="\t")

#To exit R type the following
quit(save="no")

