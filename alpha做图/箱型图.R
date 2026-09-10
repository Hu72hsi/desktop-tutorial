suppressWarnings(suppressMessages(library(amplicon)))
library("multcompView")
library(gridExtra)
setwd("D:/沙漠数据/alpha做图")
# 读取vegan表
alpha_div = read.table("D:/沙漠数据/alpha/ITS.vegan.txt", header=T, row.names=1, sep="\t", comment.char="")
# 转置,原本数据是已经转置过的，如果没有就运行
if(FALSE){
  alpha_div = as.data.frame(t(alpha_div))
}
#标准化
if(FALSE){
alpha_div = alpha_div/rowSums(alpha_div,na=T)*100
}
#读取元数据
metadata = read.table("D:/沙漠数据/metadata.txt", header=T, row.names=1, sep="\t", comment.char="", stringsAsFactors = F)
#metadata = head(metadata,40)
#多样性指数可选richness chao1 ACE shannon simpson invsimpson
p1 = alpha_boxplot(alpha_div, index = "richness", metadata, groupID = "Group")
if (FALSE){
  p1 = p1 + theme(axis.text.x=element_text(angle=45,vjust=1, hjust=1))
}
# 保存图片，大家可以修改图片名称和位置，长宽单位为毫米
ggsave(paste0("D:/沙漠数据/alpha做图/","ITS.boxplot_richness",".pdf"), p1, width = 89, height = 59, units = "mm")
p2 = alpha_boxplot(alpha_div, index = "chao1", metadata, groupID = "Group")
if (FALSE){
  p2 = p2 + theme(axis.text.x=element_text(angle=45,vjust=1, hjust=1))
}
# 保存图片，大家可以修改图片名称和位置，长宽单位为毫米
ggsave(paste0("D:/沙漠数据/alpha做图/","ITS.boxplot_chao1",".pdf"), p2, width = 89, height = 59, units = "mm")
#多样性指数可选richness chao1 ACE shannon simpson invsimpson
p3 = alpha_boxplot(alpha_div, index = "ACE", metadata, groupID = "Group")
if (FALSE){
  p3 = p3 + theme(axis.text.x=element_text(angle=45,vjust=1, hjust=1))
}
# 保存图片，大家可以修改图片名称和位置，长宽单位为毫米
ggsave(paste0("D:/沙漠数据/alpha做图/","ITS.boxplot_ACE",".pdf"), p3, width = 89, height = 59, units = "mm")
#多样性指数可选richness chao1 ACE shannon simpson invsimpson
p4 = alpha_boxplot(alpha_div, index = "shannon", metadata, groupID = "Group")
if (FALSE){
  p4 = p4 + theme(axis.text.x=element_text(angle=45,vjust=1, hjust=1))
}
# 保存图片，大家可以修改图片名称和位置，长宽单位为毫米
ggsave(paste0("D:/沙漠数据/alpha做图/","ITS.boxplot_shannon",".pdf"), p4, width = 89, height = 59, units = "mm")
#多样性指数可选richness chao1 ACE shannon simpson invsimpson
p5 = alpha_boxplot(alpha_div, index = "simpson", metadata, groupID = "Group")
if (FALSE){
  p5 = p5 + theme(axis.text.x=element_text(angle=45,vjust=1, hjust=1))
}
# 保存图片，大家可以修改图片名称和位置，长宽单位为毫米
ggsave(paste0("D:/沙漠数据/alpha做图/","ITS.boxplot_simpson",".pdf"), p5, width = 89, height = 59, units = "mm")
#多样性指数可选richness chao1 ACE shannon simpson invsimpson
p6 = alpha_boxplot(alpha_div, index = "invsimpson", metadata, groupID = "Group")
if (FALSE){
  p6 = p6 + theme(axis.text.x=element_text(angle=45,vjust=1, hjust=1))
}
# 保存图片，大家可以修改图片名称和位置，长宽单位为毫米
ggsave(paste0("D:/沙漠数据/alpha做图/","ITS.boxplot_invsimpson",".pdf"), p6, width = 89, height = 59, units = "mm")
#合起来
ggsave("ITSalpha.pdf", arrangeGrob(p1, p2, p3, p4, p5, p6, ncol = 2),
       width = 297, height = 420, units = "mm")
