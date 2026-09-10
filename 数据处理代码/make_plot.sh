<<!
export PATH=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/anaconda3/envs/qiime2-2021.4/bin:$PATH
rootdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj
unoise=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/unoise
qiime tools import --input-path $unoise/16S.ZOTU.fa --output-path $unoise/16S.raw.zotus.qza  --type 'FeatureData[Sequence]'
qiime feature-classifier classify-sklearn --i-classifier /hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/project/07.SG/gg-13-8-99-515-806-nb-classifier.qza --i-reads $unoise/16S.raw.zotus.qza --p-confidence 0.8 --o-classification $unoise/Zotu_taxonomy.qza
qiime metadata tabulate  --m-input-file $unoise/Zotu_taxonomy.qza  --o-visualization $unoise/Zotu_taxonomy.qzv

qiime taxa barplot --i-table $unoise/16S.raw.otu.table.qza  --i-taxonomy $unoise/Zotu_taxonomy.qza   --m-metadata-file $rootdir/metadata.txt   --o-visualization $unoise/16S.tax-bar-plots.qzv #taxa-barplot
!
rootdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/result
db=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/EasyMicrobiome
<<!
### 1.1 Alpha多样性箱线图

    # 在线绘图平台 https://www.bic.ac.cn/BIC 提供更多定制参数和绘制灵活性
    # 查看帮助
    #/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript ${db}/script/alpha_boxplot.R -h
    # 完整参数，多样性指数可选richness chao1 ACE shannon simpson invsimpson
    /jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript ${db}/script/alpha_boxplot.R --alpha_index richness \
      --input $rootdir/alpha/16S.vegan.txt --design $rootdir/metadata.txt \
      --group Group --output $rootdir/alpha/ \
      --width 89 --height 59
    # 使用循环绘制6种常用指数
    for i in `head -n1 $rootdir/alpha/16S.vegan.txt|cut -f 2-`;do
      /jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript ${db}/script/alpha_boxplot.R --alpha_index ${i} \
        --input $rootdir/alpha/vegan.txt --design $rootdir/metadata.txt \
        --group Group --output $rootdir/alpha/ \
        --width 89 --height 59
    done
    mv alpha_boxplot_TukeyHSD.txt $rootdir/alpha/

    # Alpha多样性柱状图+标准差
    /jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript ${db}/script/alpha_barplot.R --alpha_index richness \
      --input $rootdir/alpha/16S.vegan.txt --design $rootdir/metadata.txt \
      --group Group --output $rootdir/alpha/ \
      --width 89 --height 59

### 1.2 稀释曲线

    /jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript ${db}/script/alpha_rare_curve.R \
      --input $rootdir/alpha/alpha_rare.txt --design $rootdir/metadata.txt \
      --group Group --output $rootdir/alpha/ \
      --width 120 --height 59
!
#上面需要安装amplicon包
# 以bray_curtis为例，-f输入文件,-h是否聚类TRUE/FALSE,-u/v为宽高英寸
    bash ${db}/script/sp_pheatmap.sh \
      -f $rootdir/16Sbeta/bray_curtis.txt \
      -H 'TRUE' -u 6 -v 5
    # 添加分组注释，如2，4列的基因型和地点
    cut -f 1-2 $rootdir/metadata.txt > temp/group.txt
    # -P添加行注释文件，-Q添加列注释
    bash ${db}/script/sp_pheatmap.sh \
      -f $rootdir/beta/bray_curtis.txt \
      -H 'TRUE' -u 6.9 -v 5.6 \
      -P temp/group.txt -Q temp/group.txt





