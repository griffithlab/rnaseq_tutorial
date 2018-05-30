#!/usr/bin/env Rscript

#Jason Walker, jason.walker[AT]wustl.edu
#Malachi Griffith, mgriffit[AT]wustl.edu
#Obi Griffith, obigriffith[AT]wustl.edu
#The McDonnell Genome Institute, Washington University School of Medicine

#R tutorial for Informatics for RNA-sequence Analysis workshops

#./Tutorial_ERCC_DE.R $RNA_HOME/refs/ERCC/ERCC_Controls_Analysis.txt $RNA_HOME/de/ballgown/ref_only/UHR_vs_HBR_gene_results.tsv

library(ggplot2)

args <- commandArgs(TRUE)
erccFile <- args[1]
diffFile <- args[2]

erccData = read.delim(erccFile)
sortErccData = order(erccData[,'ERCC.ID']) 
erccData = erccData[sortErccData,]

diffData = read.delim(diffFile)
diffIdx = which(diffData[,'id'] %in% erccData[,'ERCC.ID'])
diffData = diffData[diffIdx,]
sortDiffData = order(diffData[,'id']) 
diffData = diffData[sortDiffData,]

# TODO, is the inverse needed?
diffData[,'observed_log2_fc'] = log2(diffData[,'fc'])
diffData[,'expected_log2_fc'] = erccData[,'log2.Mix.1.Mix.2.']
diffData[,'subgroup'] = erccData[,'subgroup']

#okDiffDataIdx = which(diffData[,'status']=='OK')
#diffData = diffData[okDiffDataIdx,]

model <- lm(observed_log2_fc ~ expected_log2_fc, data=diffData)
r_squared = summary(model)[['r.squared']]

p = ggplot(diffData, aes(x=expected_log2_fc, y=observed_log2_fc))
p = p + geom_point(aes(color=subgroup)) 
p = p + geom_smooth(method=lm) 
p = p + annotate('text', 1, 2, label=paste("R^2 =", r_squared, sep=' '))
p = p + xlab("Expected Fold Change (log2 scale)") + ylab("Observed Fold Change in RNA-seq data (log2 scale)")

pdf('Tutorial_ERCC_DE.pdf')
print(p)
dev.off()
