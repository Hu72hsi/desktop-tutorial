rootdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/result
<<!
#alpha分析
#由 otutab_rare.R 调用 vegan 包计算的 6 种常用 alpha 多样性指数
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/EasyMicrobiome/script/otutab_rare.R --input $rootdir/ITS.otutab.trimmed.filtered.txt --seed 1 --normalize $rootdir/alpha/ITS.otutab_rare.txt --output $rootdir/alpha/ITS.vegan.txt
usearch -otutab_stats $rootdir/alpha/ITS.otutab_rare.txt -output $rootdir/alpha/ITS.otutab_rare.stat
#USEARCH的-alpha_div 命令可以快速计算 18 种 alpha 多样性指数
usearch -alpha_div $rootdir/alpha/ITS.otutab_rare.txt -output $rootdir/alpha/ITS.alpha.txt
#USEARCH 的-alpha_div_rare 命令实现快速无放回百分数重采样计算各样本的丰富度,可视化为样本稀释曲线，或分组带误差棒的稀释曲线或箱线图
usearch -alpha_div_rare $rootdir/alpha/ITS.otutab_rare.txt -output $rootdir/alpha/ITS.alpha_rare.txt  -method without_replacement
!
#计算每个ASV相对丰度的组均值
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/EasyMicrobiome/script/otu_mean.R --input $rootdir/ITS.otutab.trimmed.filtered.txt \
-d $rootdir/metadata.txt \
-n Group --thre 0 \
-o $rootdir/ITS.otutab_mean.txt

#以平均丰度> 0.1%为阈值筛选特征，用来制作Venn图
awk 'BEGIN{OFS=FS="\t"}{if(FNR==1) {for(i=2;i<=NF;i++) a[i]=$i;}  \
    else {for(i=2;i<=NF;i++) if($i>0.1) print $1, a[i];}}' \
    $rootdir/ITS.otutab_mean.txt > $rootdir/alpha/ITS.otu_group_exist.txt
<<!
#mkdir -p result/beta/
#Bata分析
#基于OTU构建进化树 Make OTU tree, 4s
usearch -cluster_agg unoise/ITS.ZOTU.fa -treeout $rootdir/ITSbeta/ITS.otus.tree
#生成5种距离矩阵：bray_curtis, euclidean, jaccard, manhatten, unifrac
usearch -beta_div $rootdir/alpha/ITS.otutab_rare.txt -tree $rootdir/ITSbeta/ITS.otus.tree  -filename_prefix $rootdir/ITSbeta/

for i in p c o f g;do usearch -sintax_summary $rootdir/ITS.unoise.unite.sintax -otutabin $rootdir/alpha/ITS.otutab_rare.txt -rank ${i} -output $rootdir/tax/ITS.sum_${i}.txt ;done
sed -i 's/(//g;s/)//g;s/\"//g;s/\#//g;s/\/Chloroplast//g' $rootdir/tax/ITS.sum_*.txt
#按各层级分层


#alpha分析
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/EasyMicrobiome/script/otutab_rare.R --input $rootdir/16S.otutab.trimmed.filtered.txt --seed 1 --normalize $rootdir/alpha/16S.otutab_rare.txt --output $rootdir/alpha/16S.vegan.txt
usearch -otutab_stats $rootdir/alpha/16S.otutab_rare.txt -output $rootdir/alpha/16S.otutab_rare.stat

usearch -alpha_div $rootdir/alpha/16S.otutab_rare.txt -output $rootdir/alpha/16S.alpha.txt

usearch -alpha_div_rare $rootdir/alpha/16S.otutab_rare.txt -output $rootdir/alpha/16S.alpha_rare.txt  -method without_replacement
!
#计算每个ASV相对丰度的组均值
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/EasyMicrobiome/script/otu_mean.R --input $rootdir/16S.otutab.trimmed.filtered.txt \
-d $rootdir/metadata.txt \
-n Group --thre 0 \
-o $rootdir/16S.otutab_mean.txt

#以平均丰度> 0.1%为阈值筛选特征，生成Venn表，制作维恩图
awk 'BEGIN{OFS=FS="\t"}{if(FNR==1) {for(i=2;i<=NF;i++) a[i]=$i;}  \
    else {for(i=2;i<=NF;i++) if($i>0.1) print $1, a[i];}}' \
    $rootdir/16S.otutab_mean.txt > $rootdir/alpha/16S.otu_group_exist.txt

<<!
#Bata分析
usearch -cluster_agg unoise/16S.ZOTU.fa -treeout $rootdir/16Sbeta/16S.otus.tree
usearch -beta_div $rootdir/alpha/16S.otutab_rare.txt -tree $rootdir/16Sbeta/16S.otus.tree  -filename_prefix $rootdir/16Sbeta/

for i in p c o f g;do usearch -sintax_summary $rootdir/16S.unoise.silva.sintax -otutabin $rootdir/alpha/16S.otutab_rare.txt -rank ${i} -output $rootdir/tax/16S.sum_${i}.txt ;done
sed -i 's/(//g;s/)//g;s/\"//g;s/\#//g;s/\/Chloroplast//g' $rootdir/tax/16S.sum_*.txt
!


