#!/usr/bin/env Rscript

library(ggplot2)

args <- commandArgs(TRUE)
filename <- args[1]

data = read.delim(filename)

data$logCount  = log2(data$Count + 1)
data$logConc= log2(data$Concentration)

count_model <- lm(logCount ~ logConc, data=data)
count_r_squared = summary(count_model)[['r.squared']]

pdf('Tutorial_Module4_ERCC_expression.pdf')
ggplot(data, aes(x=logConc, y=logCount)
       ) + geom_point(aes(shape=Label,color=Label)
       ) + geom_smooth(method=lm
       ) + annotate('text', 5, -3,
                    label=paste("R^2 =", count_r_squared, sep=' '))
dev.off()

