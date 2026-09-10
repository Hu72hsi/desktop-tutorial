setwd("D:/沙漠数据/深度土层分析")
library(ggplot2)
suppressWarnings(suppressMessages(library(amplicon)))
df <- read.table(file = "16S.vegan.txt", header = TRUE,sep = "\t")
#导入16S样本丰度数据
df<-df[c(32:36),c(1:2)]
#细菌ASV数量变化趋势
df$SampleID <- factor(df$SampleID,levels = df$SampleID)
#告诉ggplot您已经有了一个有序的因子，因此它不会自动为您排序
p <- ggplot(data = df, aes(x = SampleID, y = richness, group = 1)) + 
  #因为横坐标的属性为因子（离散型的字符转换为因子），所以需要添加‘group = 1’的设置
  theme_bw()+   #设置固定主题为传统的白色背景和深灰色的网格线
  geom_point(size = 3)+
  geom_line(size = 1,color="blue") + 
  labs(x = "16S_Sample", y = "richness")+
  theme(axis.title.x=element_text(vjust=1,  
                                  size=40),  # X axis title
        axis.title.y=element_text(size=40,
                                  color = "black"),  # Y axis title
        axis.text.x=element_text(size=30,
                                 angle = 45,
                                 color = "black",
                                 vjust=.5),  # X axis text
        axis.text.y=element_text(size=30))  # Y axis text
ggsave("16S多样性.pdf",p,width = 10,height = 8)

df <- read.table(file = "ITS.vegan.txt", header = TRUE,sep = "\t")
#导入ITS样本丰度数据
df<-df[c(36:40),c(1:2)]
#真菌ASV数量变化趋势
df$SampleID <- factor(df$SampleID,levels = df$SampleID)
#告诉ggplot您已经有了一个有序的因子，因此它不会自动为您排序
p <- ggplot(data = df, aes(x = SampleID, y = richness, group = 1)) + 
  #因为横坐标的属性为因子（离散型的字符转换为因子），所以需要添加‘group = 1’的设置
  theme_bw()+   #设置固定主题为传统的白色背景和深灰色的网格线
  geom_point(size = 3)+
  geom_line(size = 1,color="blue") + 
  labs(x = "ITS_Sample", y = "richness")+
  theme(axis.title.x=element_text(vjust=1,  
                                  size=40),  # X axis title
        axis.title.y=element_text(size=40,
                                  color = "black"),  # Y axis title
        axis.text.x=element_text(size=30,
                                 angle = 45,
                                 color = "black",
                                 vjust=.5),  # X axis text
        axis.text.y=element_text(size=30))  # Y axis text
ggsave("ITS多样性.pdf",p,width = 10,height = 8)
