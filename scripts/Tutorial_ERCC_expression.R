#!/usr/bin/env Rscript

#Jason Walker, jason.walker[AT]wustl.edu
#Malachi Griffith, mgriffit[AT]wustl.edu
#Obi Griffith, obigriffith[AT]wustl.edu
#The McDonnell Genome Institute, Washington University School of Medicine

#R tutorial for Informatics for RNA-sequence Analysis workshops

library(ggplot2)

args <- commandArgs(TRUE)
filename <- args[1]

data = read.delim(filename)

data$logCount  = log2(data$Count + 1)
data$logConc= log2(data$Concentration)

count_model <- lm(logCount ~ logConc, data=data)
count_r_squared = summary(count_model)[['r.squared']]

p = ggplot(data, aes(x=logConc, y=logCount))
p = p + geom_point(aes(shape=Label,color=Label))
p = p + geom_smooth(method=lm) + annotate('text', 5, -3, label=paste("R^2 =", count_r_squared, sep=' '))
p = p + xlab("Expected concentration (log2 scale)") + ylab("Observed read count (log2 scale)")

pdf('Tutorial_ERCC_expression.pdf')
print(p)
dev.off()

