setwd("D:/沙漠数据/植物分析")
suppressWarnings(suppressMessages(library(amplicon)))
# 读取vegan表
alpha_div = read.table("ITS.vegan.txt", header=T, row.names=1, sep="\t", comment.char="")
#读取元数据
metadata = read.table("metadata.txt", header=T, row.names=1, sep="\t", comment.char="", stringsAsFactors = F)
#多样性指数可选richness chao1 ACE shannon simpson invsimpson
p = alpha_barplot(alpha_div, metadata, index = "richness", groupID = "Group")
ggsave(paste0("ITS.barplot_richness",".pdf"), p, width = 89, height = 59, units = "mm")
