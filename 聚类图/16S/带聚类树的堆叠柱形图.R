library(showtext)#设置字体，输出中文
library(Cairo)#pdf输出中文
library(ape)
showtext_auto(enable=T)
font_add("myfont","C:/Windows/Fonts/simhei.ttf")#调用windows自带的字体(黑体)
setwd("D:/沙漠数据/聚类图/16S")
#层次聚类
#读取 OTU 丰度表
dat <- read.delim('16S.sum_p.txt', row.names = 1, sep = '\t', head = TRUE, check.names = FALSE)

#计算样本间距离，以群落分析中常用的 Bray-curtis 距离为例
dis_bray <- vegan::vegdist(t(dat), method = 'bray')

#层次聚类，以 UPGMA 为例
tree <- hclust(dis_bray, method = 'average')
tree
plot(tree)
#系统发育树格式
plot(as.phylo(tree))
##聚类树绘制
#样本分组颜色、名称等
group <- read.delim('sample_data.txt', row.names = 1, sep = '\t',head=TRUE, check.names = FALSE, stringsAsFactors = FALSE)
grp <- group[2]
group_col <- c('red', 'blue')
names(group_col) <- c('1', '2')
group_name <- c('KO', 'WT')

#样本分组标签
layout(t(c(1, 2, 2, 2, 3)))
#设置绘图布局，将绘图区域分为 5 列，第一列绘制注释堆叠图，第二到第四列留白，
#第五列绘制树形图。
par(mar = c(5, 2, 5, 0))
#设置绘图区域的边距，mar 参数为一个长度为 4 的向量，依次代表绘图区域的
#下、左、上、右边距。
plot(0, type = 'n', xaxt = 'n', yaxt = 'n', frame.plot = FALSE, xlab = '', ylab = '',
     xlim = c(-max(tree$height), 0), ylim = c(0, length(tree$order)))
#绘制一个空白图形，用于给后面的图形设置坐标轴、边界和标签等参数。type = 'n' 
#表示不绘制任何点或线条，xaxt = 'n' 和 yaxt = 'n' 表示不绘制坐标轴刻度线，
#frame.plot = FALSE 表示不绘制边框线条，
#xlab = '' 和 ylab = '' 分别表示不绘制 X 和 Y 轴标签，
#xlim = c(-max(tree$height), 0) 和 ylim = c(0, length(tree$order)) 分别
#设置 X 和 Y 轴的边界范围，其中 -max(tree$height) 表示树形图的最大高度
#（从根节点到叶节点的最长距离）。
legend('topleft', legend = group_name, pch = 15, col = group_col, bty = 'n', cex = 1)
#添加图例，'topleft' 表示将图例放置在绘图区域的左上角，
#legend = group_name 表示图例的标签文字，pch = 15 表示图例中使用实心点作为标记，
#col = group_col 表示使用预设的颜色来填充点的颜色，bty = 'n' 表示不绘制图例的边框，
#cex = 1 表示图例标签的字号为默认大小。

##堆叠柱形图
#样本顺序调整为和聚类树中的顺序一致
dat <- dat[ ,tree$order]

#物种颜色设置
#phylum_color <- c('#8DD3C7', '#FFFFB3', '#BEBADA', '#FB8072', '#80B1D3', '#FDB462', '#B3DE69', '#FCCDE5', '#BC80BD')
phylum_color <- c('#8DD3C7', '#FFFFB3', '#BEBADA', '#FB8072', '#80B1D3', '#FDB462', '#B3DE69', '#FCCDE5', '#BC80BD', '#CCEBC5', 'gray')

names(phylum_color) <- rownames(dat)

#堆叠柱形图
par(mar = c(5, 2, 5, 0))

bar <- barplot(as.matrix(dat), col = phylum_color, space = 0.4, width = 0.7, cex.axis = 1, horiz = TRUE, 
                family = 'mono',bg = 'white',axes = FALSE)

mtext('Top 10 phylums', side = 3, line = 1, cex = 1)

#柱形图图例
par(mar = c(5, 1, 5, 0))
plot(0, type = 'n', xaxt = 'n', yaxt = 'n', bty = 'n', xlab = '', ylab = '')
legend('left', pch = 15, col = phylum_color, legend = names(phylum_color), 
       bty = 'n', cex = 2.5, text.width = 1, y.intersp = 0.1, y = ncol(dat)/2 + 0.5)
