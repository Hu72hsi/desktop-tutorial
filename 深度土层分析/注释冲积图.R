setwd("D:/沙漠数据/深度土层分析")
library(ggalluvial)
library(alluvial)
library(ggplot2)
library(reshape2)#用于处理数据格式
library(svglite)#用于保存svg文件
library(paletteer)
library(ggsci)
suppressWarnings(suppressMessages(library(amplicon)))#懂得都懂
library(showtext)#设置字体，输出中文
library(Cairo)#pdf输出中文
showtext_auto(enable=T)
font_add("myfont","C:/Windows/Fonts/simhei.ttf")#调用windows自带的字体(黑体)
# 载入黑体
#font_add("heiti", regular = "F:\\font\\simhei.ttf")
# 载入宋体
#font_add("songti", regular = "F:\\font\\simsun.ttc")
# 载入Times New Roman字体
#font_add("newrom", regular = "F:\\font\\times.ttf")
#font_families()
#par(family=("heiti"))

df <- read.table(file = "ITS.sum_g.txt", header = TRUE,row.names = 1, sep = "\t")
#导入注释数据
data_nrom = df
for(j in 1:5){
  #1:31跟据样本数量
  sample_sum=apply(df,2,sum)
  #统计每个样本的物种总数量,1:按行计算，2:按列计算
  for (i in 1:21) {
    data_nrom[i,j]=df[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Genus=rownames(df)
#提取物种注释
data_frame=data.frame(Genus,data_nrom)
#新建数据框
Genus=rev(Genus)#将向量逆序
#Genus=Genus[-which(Genus=="Others")]
#Genus<-c("Others",Genus)
##将Genus排序
data_frame=data_frame[Genus,]
#将数据按设定好的Genus排列
data_frame=melt(data_frame,id='Genus')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Genus <- factor(data_frame$Genus,levels = Genus)
#告诉ggplot您已经有了一个有序的因子，因此它不会自动为您排序
p=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Genus,stratum = Genus,,alluvium = Genus))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  theme_bw()+   #设置固定主题为传统的白色背景和深灰色的网格线
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples_g',y='Relative Abundance (%)',title=" ")+
  #将图例设置到下面
  theme(legend.position = "bottom") +
  guides(color = guide_legend(ncol = 1, title.position = "top", title.vjust = 1, title.theme = element_text(size = 14),
                              label.theme = element_text(size = 12)))+
  #设置xy轴标识，图例默认为Genus
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 0,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")+ #paletteer包调用ggsci包中igv
  theme(axis.title.x=element_text(vjust=.5,  
                                  size=30),  # X axis title
        axis.title.y=element_text(size=25,
                                  color = "black"),  # Y axis title
        axis.text.x=element_text(size=25,
                                 angle = 45,
                                 color = "black",
                                 vjust=.5),  # X axis text
        axis.text.y=element_text(size=25))+  # Y axis text
  theme(
    legend.text = element_text(size = 20),
    legend.key.size = unit(10, "pt")
    # 或
    #legend.key.height = unit(35, "pt")
    #legend.key.width = unit(55, "pt")
  )
#scale_fill_igv("default")#ggsci调用

ggsave("细菌属水平土层深度物种组成变化.pdf",p,device=cairo_pdf,width = 15,height = 10)

df <- read.table(file = "16S.sum_p.txt", header = TRUE,row.names = 1, sep = "\t")
#导入注释数据
data_nrom = df
for(j in 1:5){
  #1:31跟据样本数量
  sample_sum=apply(df,2,sum)
  #统计每个样本的细菌总数量,1:按行计算，2:按列计算
  for (i in 1:11) {
    data_nrom[i,j]=df[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Phylum=rownames(df)
#提取物种注释
data_frame=data.frame(Phylum,data_nrom)
#新建数据框
Phylum=rev(Phylum)#将向量逆序
#Phylum=Phylum[-which(Phylum=="Others")]
#Phylum<-c("Others",Phylum)
##将Phylum排序
data_frame=data_frame[Phylum,]
#将数据按设定好的Phylum排列
data_frame=melt(data_frame,id='Phylum')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Phylum <- factor(data_frame$Phylum,levels = Phylum)
#告诉ggplot您已经有了一个有序的因子，因此它不会自动为您排序
p=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Phylum,stratum = Phylum,alluvium = Phylum))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  theme_bw()+   #设置固定主题为传统的白色背景和深灰色的网格线
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples_p',y='Relative Abundance (%)',title=" ")+
  #将图例设置到下面
  theme(legend.position = "bottom") +
  guides(color = guide_legend(ncol = 1, title.position = "top", title.vjust = 1, title.theme = element_text(size = 14),
                              label.theme = element_text(size = 12)))+
  #设置xy轴标识，图例默认为Phylum
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 0,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")+#paletteer包调用ggsci包中igv
  theme(axis.title.x=element_text(vjust=.5,  
                                  size=30),  # X axis title
        axis.title.y=element_text(size=25,
                                  color = "black"),  # Y axis title
        axis.text.x=element_text(size=25,
                                 angle = 45,
                                 color = "black",
                                 vjust=.5),  # X axis text
        axis.text.y=element_text(size=25))+  # Y axis text
   theme(
        legend.text = element_text(size = 20),
        legend.key.size = unit(20, "pt")
        # 或
        #legend.key.height = unit(35, "pt")
        #legend.key.width = unit(55, "pt")
  )
#scale_fill_igv("default")#ggsci调用

ggsave("细菌门水平土层深度物种组成变化.pdf",p,device=cairo_pdf,width = 15,height = 10)

