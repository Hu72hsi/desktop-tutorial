setwd("D:/沙漠数据/距离矩阵热图")
suppressWarnings(suppressMessages(library(amplicon)))
#读取距离矩阵文件（例如 bray_curtis.txt）
dist_matrix <- read.table("D:/沙漠数据/16Sbeta/bray_curtis.txt", header=TRUE, row.names=1, check.names=FALSE)
#将距离矩阵转换为矩阵形式
matrix_data <- as.matrix(dist_matrix)
#调用 pheatmap 函数，绘制距离矩阵热图
library(pheatmap)
p <- pheatmap(matrix_data, 
         scale = "none", # 用于控制是否在行或列方向上进行标准化（“none”、“row”或“column”）
         clustering_distance_rows = "euclidean", # 用于控制行方向上的聚类方法
         clustering_distance_cols = "euclidean", # 用于控制列方向上的聚类方法
         clustering_method = "complete", # 用于控制聚类算法（“ward.D”、“ward.D2”、“single”、“complete”、“average”、“mcquitty”或“median”）
         border_color = NA, # 用于控制热图边框颜色
         color = colorRampPalette(c("white", "blue"))(50), # 用于控制颜色方案
         main = "距离矩阵热图")
ggsave(paste0("16S.bray_curtis",".pdf"), p, width = 240, height = 240, units = "mm")


