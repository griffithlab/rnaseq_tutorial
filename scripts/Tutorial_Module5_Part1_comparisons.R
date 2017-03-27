#Tutorial_Module5_Part1_comparisons.R

#Malachi Griffith, mgriffit[AT]wustl.edu
#Obi Griffith, obigriffith[AT]wustl.edu
#The McDonnell Genome Institute, Washington University School of Medicine

#R tutorial for Informatics for RNA-sequence Analysis workshops

#Load libraries
library(ggplot2)

#Set the base working dir from which to access the input files
working_dir = '/home/ubuntu/workspace/rnaseq/expression'
setwd(working_dir)

#Load in expression matrix files from each expression method
htseq_gene = read.table('htseq_counts/gene_read_counts_table_all_final.tsv', sep="\t", header=TRUE, as.is=1, row.names=1)
stringtie_gene = read.table('stringtie/ref_only/gene_tpm_all_samples.tsv', sep="\t", header=TRUE, as.is=1, row.names=1)
stringtie_tran = read.table('stringtie/ref_only/transcript_tpm_all_samples.tsv', sep="\t", header=TRUE, as.is=1, row.names=1)
kallisto_gene = read.table('kallisto/gene_tpms_all_samples.tsv', sep="\t", header=TRUE, as.is=1, row.names=1)
kallisto_tran = read.table('kallisto/transcript_tpms_all_samples.tsv', sep="\t", header=TRUE, as.is=1, row.names=1)

#Summarize the data.frames created
dim(htseq_gene)
dim(stringtie_gene)
dim(kallisto_gene)

dim(stringtie_tran)
dim(kallisto_tran)

#Reorganize the data.frames for total consistency
kallisto_names = c("length", "HBR_Rep1", "HBR_Rep2", "HBR_Rep3", "UHR_Rep1", "UHR_Rep2", "UHR_Rep3") 
names(kallisto_gene) = kallisto_names
names(kallisto_tran) = kallisto_names

sample_names = c("HBR_Rep1", "HBR_Rep2", "HBR_Rep3", "UHR_Rep1", "UHR_Rep2", "UHR_Rep3")
gene_names = row.names(kallisto_gene)
tran_names = row.names(kallisto_tran)

htseq_gene = htseq_gene[gene_names, sample_names]
stringtie_gene = stringtie_gene[gene_names, sample_names]
kallisto_gene = kallisto_gene[gene_names, sample_names]
stringtie_tran = stringtie_tran[tran_names, sample_names]
kallisto_tran = kallisto_tran[tran_names, sample_names]

#Take a look at the top of each data.frame
head(htseq_gene)
head(stringtie_gene)
head(kallisto_gene)
head(stringtie_tran)
head(kallisto_tran)

#Plot kallisto transcript TPMs vs stringtie transcript TPMs
stabvar = 0.1
data = data.frame(kallisto_gene[,"HBR_Rep1"], stringtie_gene[,"HBR_Rep1"], htseq_gene[,"HBR_Rep1"])
names(data) = c("kallisto", "stringtie", "htseq")
p = ggplot(data, aes(log2(kallisto+stabvar), log2(stringtie+stabvar)))
p = p + geom_point()
p = p + geom_point(aes(colour = log2(htseq+stabvar))) + scale_colour_gradient(low = "yellow", high = "red")
p = p + scale_x_log2() + scale_y_log2()

pdf(file="Tutorial_Module5_Part1_comparisons.pdf")
print(p)
dev.off()


