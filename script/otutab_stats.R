#!/hwfssz1/ST_EARTH/P18Z10200N0112/software/03.Soft_ALL/R-4.0.2/bin Rscript
# 程序功能：统计特征表中reads数小于5的ASVs数量
# Functions: Number of ASVs with the number of reads less than 5 in the statistical feature table

#options(warn = -1) # Turning off  warning

args <- commandArgs(trailingOnly = TRUE)
otutab = read.table(args[1], header=T, row.names=1, sep="\t", comment.char="", fill = TRUE)
cat(dim(otutab)[2], " Samples\n")
cat(dim(otutab)[1], " OTUs\n")
cat(sum(otutab), " Reads\n")
cat("\n")

# calculate ASVs num whose read num in all samples < 5
row_sum <- rowSums(otutab)
cat("ASVs num whose read num in all samples <= 5:\n")
cat("\t< 5 reads num: ", sum(row_sum<5)," (", round(sum(row_sum<5)*100/sum(row_sum),digits = 6), "%)\n")
#cat("\t< 20 reads num: ", sum(row_sum<20)," (", round(sum(row_sum<20)*100/sum(row_sum),digits = 6), "%)\n")
#cat("\t< 30 reads num: ", sum(row_sum<30)," (", round(sum(row_sum<30)*100/sum(row_sum),digits = 6), "%)\n")

