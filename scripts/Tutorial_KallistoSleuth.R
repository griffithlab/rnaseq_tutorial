#load sleuth library
suppressMessages({
      library("sleuth")
})

#set input and output dirs
datapath = "/home/ubuntu/workspace/rnaseq/de/sleuth/input"
resultdir = '/home/ubuntu/workspace/rnaseq/de/sleuth/results'
setwd(resultdir)

#create a sample to condition metadata description
sample_id = dir(file.path(datapath))
kal_dirs = file.path(datapath, sample_id)
print(kal_dirs)
sample = c("HBR_Rep1_ERCC-Mix2", "HBR_Rep2_ERCC-Mix2", "HBR_Rep3_ERCC-Mix2", "UHR_Rep1_ERCC-Mix1", "UHR_Rep2_ERCC-Mix1", "UHR_Rep3_ERCC-Mix1")
condition = c("HBR", "HBR", "HBR", "UHR", "UHR", "UHR")
s2c = data.frame(sample,condition)
s2c <- dplyr::mutate(s2c, path = kal_dirs)
print(s2c)

#run sleuth on the data
so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE)
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_lrt(so, 'reduced', 'full')
models(so)

#summarize the sleuth results and view 20 most significant DE transcripts
sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)
head(sleuth_significant, 20)

#plot an example DE transcript result
p1 = plot_bootstrap(so, "ENST00000328933", units = "est_counts", color_by = "condition")
p2 = plot_pca(so, color_by = 'condition')

#Print out the plots created above and store in a single PDF file
pdf(file="SleuthResults.pdf")
print(p1)
print(p2)
dev.off()

#Quit R
quit(save="no")

