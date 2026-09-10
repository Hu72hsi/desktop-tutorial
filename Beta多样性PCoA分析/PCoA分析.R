setwd("D:/沙漠数据/Beta多样性PCoA分析")
suppressWarnings(suppressMessages(library(amplicon)))

#读取元数据
metadata = read.table("D:/沙漠数据/metadata.txt", header=T, row.names=1, sep="\t", comment.char="", stringsAsFactors = F)
#距离矩阵Distance matrix
distance_mat = read.table("D:/沙漠数据/16Sbeta/bray_curtis.txt", header=T, row.names=1, sep="\t", comment.char="")
#绘图保存 Plotting and saving
#绘图 Plotting
# 输入矩阵矩阵、元数据和分组列，返回ggplot2对象
p = beta_pcoa(distance_mat, metadata, groupID = "Group", label=FALSE)
# 可以修改图片名称和位置，长宽单位为毫米
ggsave("16Sbray_curtis.pcoa.label.pdf", p, width = 89, height = 59, units = "mm")

# 添加样本标签 --label TRUE
# 组间统计 Stat
# statistic each pairwise by adonis
# 结果文件默认见beta_pcoa_stat.txt#会存储到工作目录
if (TRUE){
     beta_pcoa_stat(distance_mat, metadata, groupID = "Group")
}

