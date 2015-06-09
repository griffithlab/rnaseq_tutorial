#!/usr/bin/env Rscript

#./Tutorial_Module4_ERCC_DE.R /gscmnt/gc2801/analytics/jwalker/RNAseqTutorial/refs/ERCC/ERCC_Controls_Analysis.txt /gscmnt/gc2801/analytics/jwalker/RNAseqTutorial/de/tophat_cufflinks/ref_only/gene_exp.diff

library(ggplot2)

args <- commandArgs(TRUE)
erccFile <- args[1]
diffFile <- args[2]

erccData = read.delim(erccFile)
sortErccData = order(erccData[,'ERCC.ID']) 
erccData = erccData[sortErccData,]

diffData = read.delim(diffFile)
diffIdx = which(diffData[,'gene'] %in% erccData[,'ERCC.ID'])
diffData = diffData[diffIdx,]
sortDiffData = order(diffData[,'gene']) 
diffData = diffData[sortDiffData,]

diffData[,'observed_log2_fc'] = diffData[,'log2.fold_change.'] * -1
diffData[,'expected_log2_fc'] = erccData[,'log2.Mix.1.Mix.2.']
diffData[,'subgroup'] = erccData[,'subgroup']

okDiffDataIdx = which(diffData[,'status']=='OK')
diffData = diffData[okDiffDataIdx,]

model <- lm(observed_log2_fc ~ expected_log2_fc, data=diffData)
r_squared = summary(model)[['r.squared']]

pdf('Tutorial_Module4_ERCC_DE.pdf')
ggplot(diffData, aes(x=expected_log2_fc, y=observed_log2_fc)
       ) + geom_point(aes(color=subgroup)
       ) + geom_smooth(method=lm
       ) + annotate('text', 1, 2,
                    label=paste("R^2 =", r_squared, sep=' '))
dev.off()
