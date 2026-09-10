setwd("D:/沙漠数据/限制性主坐标分析CPCoA")
suppressWarnings(suppressMessages(library(amplicon)))

#读取元数据
metadata = read.table("D:/沙漠数据/metadata.txt", header=T, row.names=1, sep="\t", comment.char="", stringsAsFactors = F)
#距离矩阵Distance matrix
distance_mat = read.table("D:/沙漠数据/ITSbeta/bray_curtis.txt", header=T, row.names=1, sep="\t", comment.char="")
# 输入矩阵矩阵、元数据和分组列，返回ggplot2对象
p = beta_cpcoa_dis(distance_mat, metadata, groupID = "Group", label=FALSE)
# 可以修改图片名称和位置，长宽单位为毫米
ggsave("ITS_bray_curtis.cpcoa.pdf", p, width = 89, height = 59, units = "mm")

