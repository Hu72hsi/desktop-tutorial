library(ggalluvial)
library(alluvial)
library(ggplot2)
library(reshape2)#用于处理数据格式
library(svglite)#用于保存svg文件
library(paletteer)
library(ggsci)

#install.packages("rlang",version="0.4.7")
#packageVersion("rlang")
setwd("D:/沙漠数据")
df <- read.table(file = "16S.sum_p_new.txt", header = TRUE,row.names = 1, sep = "\t")
#导入16S的门注释数据

df1<-df[,c(1:31)]
df2<-df[,c(32:39)]
#将矩阵按需要分割
#df1_x<-c("A-0","A-1","A-2","A-3","A-4","A-5","A-6","A-7","A-8","A-9","A-11","A-12","A-13","A-14","A-15","A-16","A-17","A-20","A-21","A-23","A-24","A-25","A-26","A-27","A-28","A-29","A-30","A-32","A-34","BS-2","C3-2","G-1","G-2","G-3","G-4","G-5","GR-01","LW-1","T-1")
#df2_x<-c("G-1","G-2","G-3","G-4","G-5","GR-01","LW-1","T-1")
#colnames(df1)=df1_x
#colnames(df2)=df2_x
#导入时格式出错，校正#这一步好像没什么用，因为后面显示时还是不一样

#a<-c()  
#sample_sum=apply(df1,1,sum)
#统计每个样本的细菌总数量,1:按行计算，2:按列计算
#for (i in 1:34) {
#  a[i]=sample_sum[i]
#}
#df1=data.frame(df1,a)
#df1=df1[order(-df1$a),]
#df1=df1[,c(1:31)]
#细菌物种门水平组成变化情况
data_nrom = df1
for(j in 1:31){
#1:31跟据样本数量
  sample_sum=apply(df1,2,sum)
  #统计每个样本的细菌总数量,1:按行计算，2:按列计算
     for (i in 1:34) {
       data_nrom[i,j]=df1[i,j]/sample_sum[j]
     }
}
#由于是分割出来的所以需要标准化丰度
Phylum=rownames(df1)
#提取物种注释
data_frame=data.frame(Phylum,data_nrom)
#新建数据框
Phylum=rev(Phylum)#将向量逆序
Phylum=Phylum[-which(Phylum=="Unassigned")]
Phylum<-c("Unassigned",Phylum)
#将Phylum排序
data_frame=data_frame[Phylum,]
#将数据按设定好的Phylum排列
data_frame=melt(data_frame,id='Phylum')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Phylum <- factor(data_frame$Phylum,levels = Phylum)
#告诉ggplot您已经有了一个有序的因子，因此它不会自动为您排序
#data_frame=merge(data_frame,data_group,by='sample_id')#分组,可能会用到
#普通堆叠图
#stack_plot=ggplot(data_frame,aes(x = sample_id,fill = Phylum,y = value*100))+
#数据输入：样本，物种，丰度
#geom_col(position='stack')+
#stack:堆叠图
#labs(x='samples',y='Relative Abundance (%)')+
#给x、y轴取名
#scale_x_continuous(expand=c(0,0)) +
#调整x轴属性
#scale_y_continuous(expand=c(0,0)) +
#调整y轴属性
#theme(axis.title =element_text(size = 16),axis.text =element_text(size = 14, color = 'black'))+
#theme为设置标题参数，axis.title为轴标题信息，axis.text为轴注释文本
#theme(axis.text.x = element_text(angle = 45,hjust = 1))
#axis.text.x表示设置x轴的信息,angle:调整横轴标签倾斜角度，hjust：上下移动横轴标签
#require(ggplot2)
#ggsave(filename="16S1门注释普通堆积图.svg",plot = stack_plot,width = 10,height = 8)

#冲积图
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Phylum,stratum = Phylum,alluvium = Phylum))+
geom_bar(stat='identity',width=0.45)+
geom_alluvium()+
geom_stratum(width=0.45,size=0.1)+
labs(x='samples',y='Relative Abundance (%)')+
#设置xy轴标识，图例默认为Phylum
scale_y_continuous(expand=c(0,0)) +
theme(axis.text.x = element_text(angle = 45,hjust = 1))+
scale_fill_paletteer_d("ggsci::default_igv")#paletteer包调用ggsci包中igv
#scale_fill_igv("default")#ggsci调用
ggsave(filename="细菌物种门水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

#library("scales")
#pal= pal_igv("default")(50)
#show_col(pal)
#显示调色板

#高粱/狼尾草地细菌物种门水平组成变化情况
data_nrom = df2
for(j in 1:8){
  #1:31跟据样本数量
  sample_sum=apply(df2,2,sum)
  #统计每个样本的细菌总数量,1:按行计算，2:按列计算
  for (i in 1:34) {
    data_nrom[i,j]=df2[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Phylum=rownames(df2)
#提取物种注释
data_frame=data.frame(Phylum,data_nrom)
#新建数据框
Phylum=rev(Phylum)#将向量逆序
Phylum=Phylum[-which(Phylum=="Unassigned")]
Phylum<-c("Unassigned",Phylum)
#将Phylum排序
data_frame=data_frame[Phylum,]
#将数据按设定好的Phylum排列
data_frame=melt(data_frame,id='Phylum')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Phylum <- factor(data_frame$Phylum,levels = Phylum)
#冲积图
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Phylum,stratum = Phylum,alluvium = Phylum))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples',y='Relative Abundance (%)')+
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")
ggsave(filename="高粱狼尾草地细菌物种门水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

df <- read.table(file = "16S.sum_g_new.txt", header = TRUE,row.names = 1, sep = "\t")
#导入16S的属注释数据
df1<-df[c(1:20),c(1:31)]
df2<-df[c(1:20),c(32:39)]
#细菌物种属水平组成变化情况
data_nrom = df1
for(j in 1:31){
  #1:31跟据样本数量
  sample_sum=apply(df1,2,sum)
  #统计每个样本的细菌总数量,1:按行计算，2:按列计算
  for (i in 1:20) {
    data_nrom[i,j]=df1[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Genus=rownames(df1)
#提取物种注释
data_frame=data.frame(Genus,data_nrom)
#新建数据框
Genus=rev(Genus)#将向量逆序
Genus=Genus[-which(Genus=="Unassigned")]
Genus<-c("Unassigned",Genus)
#将Genus排序
data_frame=data_frame[Genus,]
#将数据按设定好的Genus排列
data_frame=melt(data_frame,id='Genus')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Genus <- factor(data_frame$Genus,levels = Genus)
#冲积图
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Genus,stratum = Genus,alluvium = Genus))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples',y='Relative Abundance (%)')+
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")
ggsave(filename="细菌物种属水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

#高粱/狼尾草地细菌物种属水平组成变化情况
data_nrom = df2
for(j in 1:8){
  #1:31跟据样本数量
  sample_sum=apply(df2,2,sum)
  #统计每个样本的细菌总数量,1:按行计算，2:按列计算
  for (i in 1:20) {
    data_nrom[i,j]=df2[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Genus=rownames(df2)
#提取物种注释
data_frame=data.frame(Genus,data_nrom)
#新建数据框
Genus=rev(Genus)#将向量逆序
Genus=Genus[-which(Genus=="Unassigned")]
Genus<-c("Unassigned",Genus)
#将Genus排序
data_frame=data_frame[Genus,]
#将数据按设定好的Genus排列
data_frame=melt(data_frame,id='Genus')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Genus <- factor(data_frame$Genus,levels = Genus)
#冲积图
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Genus,stratum = Genus,alluvium = Genus))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples',y='Relative Abundance (%)')+
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")
ggsave(filename="高粱狼尾草地细菌物种属水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

df <- read.table(file = "ITS.sum_p_new.txt", header = TRUE,row.names = 1, sep = "\t")
#导入ITS的门注释数据
df1<-df[,c(1:16)]
df2<-df[,c(17:19)]
#真菌物种门水平组成变化情况
data_nrom = df1
for(j in 1:16){
  #1:31跟据样本数量
  sample_sum=apply(df1,2,sum)
  #统计每个样本的真菌总数量,1:按行计算，2:按列计算
  for (i in 1:9) {
    data_nrom[i,j]=df1[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Phylum=rownames(df1)
#提取物种注释
data_frame=data.frame(Phylum,data_nrom)
#新建数据框
Phylum=rev(Phylum)#将向量逆序
Phylum=Phylum[-which(Phylum=="Unassigned")]
Phylum<-c("Unassigned",Phylum)
#将Phylum排序
data_frame=data_frame[Phylum,]
#将数据按设定好的Phylum排列
data_frame=melt(data_frame,id='Phylum')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Phylum <- factor(data_frame$Phylum,levels = Phylum)
#冲积图
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Phylum,stratum = Phylum,alluvium = Phylum))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples',y='Relative Abundance (%)')+
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")
ggsave(filename="真菌物种门水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

#高粱/狼尾草地真菌物种门水平组成变化情况
data_nrom = df2
for(j in 1:3){
  #1:31跟据样本数量
  sample_sum=apply(df2,2,sum)
  #统计每个样本的真菌总数量,1:按行计算，2:按列计算
  for (i in 1:9) {
    data_nrom[i,j]=df2[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Phylum=rownames(df2)
#提取物种注释
data_frame=data.frame(Phylum,data_nrom)
#新建数据框
Phylum=rev(Phylum)#将向量逆序
Phylum=Phylum[-which(Phylum=="Unassigned")]
Phylum<-c("Unassigned",Phylum)
#将Phylum排序
data_frame=data_frame[Phylum,]
#将数据按设定好的Phylum排列
data_frame=melt(data_frame,id='Phylum')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Phylum <- factor(data_frame$Phylum,levels = Phylum)
#冲积图
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Phylum,stratum = Phylum,alluvium = Phylum))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples',y='Relative Abundance (%)')+
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")
ggsave(filename="高粱狼尾草地真菌物种门水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

df <- read.table(file = "ITS.sum_g_new.txt", header = TRUE,row.names = 1, sep = "\t")
#导入ITS的属注释数据
df1<-df[c(1:20),c(1:16)]
df2<-df[c(1:20),c(17:19)]
#真菌物种属水平组成变化情况
data_nrom = df1
for(j in 1:16){
  #1:31跟据样本数量
  sample_sum=apply(df1,2,sum)
  #统计每个样本的真菌总数量,1:按行计算，2:按列计算
  for (i in 1:20) {
    data_nrom[i,j]=df1[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Genus=rownames(df1)
#提取物种注释
data_frame=data.frame(Genus,data_nrom)
#新建数据框
Genus=rev(Genus)#将向量逆序
Genus=Genus[-which(Genus=="Unassigned")]
Genus<-c("Unassigned",Genus)
#将Genus排序
data_frame=melt(data_frame,id='Genus')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Genus <- factor(data_frame$Genus,levels = Genus)
#冲积图
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Genus,stratum = Genus,alluvium = Genus))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples',y='Relative Abundance (%)')+
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")
ggsave(filename="真菌物种属水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

#高粱/狼尾草地真菌物种属水平组成变化情况
data_nrom = df2
for(j in 1:3){
  #1:31跟据样本数量
  sample_sum=apply(df2,2,sum)
  #统计每个样本的真菌总数量,1:按行计算，2:按列计算
  for (i in 1:20) {
    data_nrom[i,j]=df2[i,j]/sample_sum[j]
  }
}
#由于是分割出来的所以需要标准化丰度
Genus=rownames(df2)
#提取物种注释
data_frame=data.frame(Genus,data_nrom)
#新建数据框
Genus=rev(Genus)#将向量逆序
Genus=Genus[-which(Genus=="Unassigned")]
Genus<-c("Unassigned",Genus)
#将Genus排序
data_frame=melt(data_frame,id='Genus')
#根据Taxonomy和sample将所有丰度竖着排列
names(data_frame)[2]='sample_id'#重命名
data_frame$Genus <- factor(data_frame$Genus,levels = Genus)
#冲积图
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Genus,stratum = Genus,alluvium = Genus))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples',y='Relative Abundance (%)')+
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")
ggsave(filename="高粱狼尾草地真菌物种属水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

df <- read.table(file = "16S.vegan_new.txt", header = TRUE,sep = "\t")
#导入16S样本丰度数据
df1<-df[c(1:31),c(1:2)]
df2<-df[c(32:39),c(1:2)]
#细菌ASV数量变化趋势
df1$SampleID <- factor(df1$SampleID,levels = df1$SampleID)
#告诉ggplot您已经有了一个有序的因子，因此它不会自动为您排序
ggplot(data = df1, aes(x = SampleID, y = richness, group = 1)) + 
  #因为横坐标的属性为因子（离散型的字符转换为因子），所以需要添加‘group = 1’的设置
  geom_point(size = 3)+
  geom_line(size = 1,color="blue") + 
  labs(x = "Sample", y = "ASV number")
#高粱地/狼尾草地细菌ASV数量
ggplot(data = df2, aes(x = SampleID, y = richness,group=1)) + 
  #因为横坐标的属性为因子（离散型的字符转换为因子），所以需要添加‘group = 1’的设置
  geom_point(size = 3)+
  geom_line(size = 1,color="blue") + 
  labs(x = "Sample", y = "ASV number")

df <- read.table(file = "ITS.vegan_new.txt", header = TRUE,sep = "\t")
#导入ITS样本丰度数据
df1<-df[c(1:16),c(1:2)]
df2<-df[c(17:19),c(1:2)]
#真菌ASV数量变化趋势
df1$SampleID <- factor(df1$SampleID,levels = df1$SampleID)
#告诉ggplot您已经有了一个有序的因子，因此它不会自动为您排序
ggplot(data = df1, aes(x = SampleID, y = richness, group = 1)) + 
  #因为横坐标的属性为因子（离散型的字符转换为因子），所以需要添加‘group = 1’的设置
  geom_point(size = 3)+
  geom_line(size = 1,color="blue") + 
  labs(x = "Sample", y = "ASV number")
#高粱地/狼尾草地真菌ASV数量
ggplot(data = df2, aes(x = SampleID, y = richness,group=1)) + 
  #因为横坐标的属性为因子（离散型的字符转换为因子），所以需要添加‘group = 1’的设置
  geom_point(size = 3)+
  geom_line(size = 1,color="blue") + 
  labs(x = "Sample", y = "ASV number")
