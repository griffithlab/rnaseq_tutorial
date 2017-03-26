#Tutorial_Module5_Part1_comparisons.R

#Malachi Griffith, mgriffit[AT]wustl.edu
#Obi Griffith, obigriffith[AT]wustl.edu
#The McDonnell Genome Institute, Washington University School of Medicine

#R tutorial for Informatics for RNA-sequence Analysis workshops

#Load in expression matrix files from each expression method
working_dir = '/home/ubuntu/workspace/rnaseq/expression'
setwd(working_dir)

htseq_gene = read.table('htseq_counts/gene_read_counts_table_all_final.tsv', sep="\t", header=TRUE, as.is=1)

stringtie_gene = read.table('stringtie/ref_only/gene_tpm_all_samples.tsv', sep="\t", header=TRUE, as.is=1)
    
stringtie/ref_only/transcript_tpm_all_samples.tsv
kallisto/gene_tpms_all_samples.tsv
kallisto/transcript_tpms_all_samples.tsv

