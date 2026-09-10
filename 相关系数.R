# 安装需要的包，并加载。
#install.packages("psych")
library(psych)
library(ggcorrplot)
setwd("D:/沙漠数据/细菌A0-A21")
# 读取otu-sample矩阵
otu=read.table("16S.txt",head=T,row.names=1)
# 选择前10行的ASV
#otu_sub <- head(otu, 10)
#转置
otu=t(otu)
# 计算两两OTU间的相关系数矩阵
occor = corr.test(otu,use="pairwise",method="spearman",adjust="fdr",alpha=0.05)
occor.r = occor$r # 取相关性矩阵R值
occor.p = occor$p # 取相关性矩阵p值
# 确定物种间存在相互作用关系的阈值，将相关性r小于0.6并且显著性p大于0.05的数据转换为0
occor.r[occor.p>0.05|abs(occor.r)<0.6] = 0
# 将occor.r保存为csv文件
write.csv(occor.r,file="network.csv") 
df <- read.table("network.csv", head = T,row.names=1)