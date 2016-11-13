library(ballgown)
library(genefilter)
library(dplyr)
library(devtools)

# Load phenotype data
pheno_data = read.csv("UHR_vs_HBR.csv")

# Load ballgown data structure
bg = ballgown(samples=as.vector(pheno_data$path),pData=pheno_data)

# Save the ballgown object to a file
save(bg, file='bg.rda')

# Perform DE with no filtering
results_transcripts = stattest(bg, feature="transcript", covariate="type", getFC=TRUE, meas="FPKM")
results_genes = stattest(bg, feature="gene", covariate="type", getFC=TRUE, meas="FPKM")

write.table(results_transcripts,"UHR_vs_HBR_transcript_results.tsv",sep="\t")
write.table(results_genes,"UHR_vs_HBR_gene_results.tsv",sep="\t")

# Filter low-abundance genes Here we remove all transcripts with a variance across samples less than one
bg_filt = subset (bg,"rowVars(texpr(bg)) > 1", genomesubset=TRUE)
results_transcripts = stattest(bg_filt, feature="transcript", covariate="type", getFC=TRUE, meas="FPKM")
results_genes = stattest(bg_filt, feature="gene", covariate="type", getFC=TRUE, meas="FPKM")

write.table(results_transcripts,"UHR_vs_HBR_transcript_results_filtered.tsv",sep="\t")
write.table(results_genes,"UHR_vs_HBR_gene_results_filtered.tsv",sep="\t")


# Identify genes with p value < 0.05
sig_transcripts = subset(results_transcripts,results_transcripts$pval<0.05)
sig_genes = subset(results_genes,results_genes$pval<0.05)
write.table(sig_transcripts,"UHR_vs_HBR_transcript_results_sig.tsv",sep="\t")
write.table(sig_genes,"UHR_vs_HBR_gene_results_sig.tsv",sep="\t")

quit(save="no")
