library(ggalluvial)
library(alluvial)
library(ggplot2)
library(reshape2)
library(svglite)
library(paletteer)
library(ggsci)

setwd("D:/沙漠数据")
df <- read.table(file = "16S.sum_p_new.txt", header = TRUE,row.names = 1, sep = "\t")
df1<-df[,c(1:31)]
for(j in 1:31){
  #1:31跟据样本数量
  sample_sum=apply(df1,2,sum)
  for (i in 1:34) {
    data_nrom[i,j]=df1[i,j]/sample_sum[j]
  }
}
Phylum=rownames(df1)
data_frame=data.frame(Phylum,data_nrom)
Phylum=rev(Phylum)
data_frame=data_frame[Phylum,]
data_frame=melt(data_frame,id='Phylum')
names(data_frame)[2]='sample_id'
data_frame$Phylum <- factor(data_frame$Phylum,levels = Phylum)
stack_plot=ggplot(data_frame,aes(x = sample_id,y = value*100,fill = Phylum,stratum = Phylum,alluvium = Phylum))+
  geom_bar(stat='identity',width=0.45)+
  geom_alluvium()+
  geom_stratum(width=0.45,size=0.1)+
  labs(x='samples',y='Relative Abundance (%)')+
  scale_y_continuous(expand=c(0,0)) +
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  scale_fill_paletteer_d("ggsci::default_igv")
ggsave(filename="细菌物种门水平组成变化情况冲积图.svg",plot = stack_plot,width = 10,height = 8)

