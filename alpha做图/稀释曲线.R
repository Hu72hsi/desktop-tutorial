setwd("D:/沙漠数据/alpha做图")
suppressWarnings(suppressMessages(library(amplicon)))
# 读取rare表
alpha_div = read.table("D:/沙漠数据/alpha/16S.alpha_rare.txt", header=T, row.names=1, sep="\t", comment.char="")
#读取元数据
metadata = read.table("D:/沙漠数据/metadata.txt", header=T, row.names=1, sep="\t", comment.char="", stringsAsFactors = F)
p = alpha_rare_curve(alpha_div, metadata, groupID = "Group")
ggsave(paste0("D:/沙漠数据/alpha做图/","16S.alpha_rarefaction_curve",".pdf"), p, width = 120, height = 59, units = "mm")
