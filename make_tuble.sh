rootdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj
outdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/result/raw
temp=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/temp
#统计总条数
#tags=`grep -c '>' $rootdir/16S.all.sub50000.fa`
#echo "$tags/1000000"|bc
#2
#tags=`grep -c '>' $rootdir/ITS.all.sub50000.fa`/
#echo "$tags/1000000"|bc
#这个是看序列条数的不要加到流程里

#去重复
#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -fastx_uniques $rootdir/16S.all.sub50000.fa -fastaout $temp/16S.all.uniques.fa -sizeout -relabel Uniq_ -minuniquesize 2
#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -fastx_uniques $rootdir/ITS.all.sub50000.fa -fastaout $temp/ITS.all.uniques.fa -sizeout -relabel Uniq_ -minuniquesize 2

#ASV去噪并去嵌合
#mkdir uparse unoise
#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -unoise3 $temp/16S.all.uniques.fa -zotus $outdir/16S.raw.zotus.fa -tabbedout $rootdir/unoise/16S.unoise3.txt
#awk 'BEGIN {n=1}; />/ {print ">ASV" n; n++} !/>/ {print}' $outdir/16S.raw.zotus.fa > $rootdir/unoise/16S.ZOTU.fa
#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -unoise3 $temp/ITS.all.uniques.fa -zotus $outdir/ITS.raw.zotus.fa -tabbedout $rootdir/unoise/ITS.unoise3.txt
#awk 'BEGIN {n=1}; />/ {print ">ASV" n; n++} !/>/ {print}' $outdir/ITS.raw.zotus.fa > $rootdir/unoise/ITS.ZOTU.fa


#生成特征表,用 vsearch reads map ratio比usearch好
#vsearch --usearch_global $rootdir/16S.all.sub50000.fa --db $rootdir/unoise/16S.ZOTU.fa --id 0.97 --otutabout $rootdir/unoise/16S.raw.Zotu.table.txt --biomout $rootdir/unoise/16S.raw.Zotu.table.biom 2>$rootdir/unoise/16S.make-table.log
#vsearch --usearch_global $rootdir/ITS.all.sub50000.fa --db $rootdir/unoise/ITS.ZOTU.fa --id 0.97 --otutabout $rootdir/unoise/ITS.raw.Zotu.table.txt --biomout $rootdir/unoise/ITS.raw.Zotu.table.biom 2>$rootdir/unoise/ITS.make-table.log
#运行这个的话后面要接qiime，但是缺少数据库，所以没用qiime，而且qiime注释没usearch好

#生成特征表
#vsearch --usearch_global $rootdir/16S.all.sub50000.fa --db $rootdir/unoise/16S.OTU.fa  --otutabout $outdir/16S.unoise_otutable.txt --id 0.97 --threads 4
#sed -i 's/\r//' $outdir/16S.unoise_otutable.txt
#vsearch --usearch_global $rootdir/ITS.all.sub50000.fa --db $rootdir/unoise/ITS.OTU.fa  --otutabout $outdir/ITS.unoise_otutable.txt --id 0.97 --threads 4
#sed -i 's/\r//' $outdir/ITS.unoise_otutable.txt

#按物种注释筛选特征表
#更快
#vsearch --sintax 16S.all.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/database/amplicon/rdp_16s_v16.fa --tabbedout result/raw/unoise.rdp.otus.sintax --sintax_cutoff 0.6
#更慢
#vsearch --sintax 16S.all.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/database/amplicon/silva_16s_v123.fa --tabbedout result/raw/unoise.silva.otus.sintax --sintax_cutoff 0.6


#vsearch --sintax $rootdir/unoise/16S.OTU.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/silva_16s_v123_spike.fa --tabbedout $outdir/16S.unoise.silva.sintax.spike.new --sintax_cutoff 0.8 --threads 3
#vsearch --sintax $rootdir/unoise/ITS.OTU.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/utax_reference_dataset_10.05.2021_fungi_Spike.fasta --tabbedout $outdir/ITS.unoise.silva.sintax.spike.new --sintax_cutoff 0.8 --threads 3
vsearch --sintax $rootdir/unoise/ITS.OTU.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/ITS_Spike.fa --tabbedout $outdir/ITS.unoise.silva.sintax.spike.new --sintax_cutoff 0.8 --threads 3

#/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/software/script/otutab_filter_nonBac.R --input $outdir/16S.unoise_otutable.txt --taxonomy $outdir/16S.unoise.silva.sintax.spike.new --output $rootdir/result/16S.unoise_otutab_nonBac_silve.txt --stat $outdir/16S.unoise_otutab_nonBac_silve.stat --discard $outdir/16S.unoise_otutab_nonBac_silve.sintax.discard
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/software/script/otutab_filter_nonFungi.R
#上面的R脚本是我改过的，筛选真菌、细菌、古细菌和Spike（一个人为插入序列）根据需要自己改代码或直接下载源码

#筛选特征表对应序的列和物种注释
#cut -f 1 $rootdir/result/16S.unoise_otutab_nonBac_silve.txt | tail -n+2 > $rootdir/result/16S.unoise_otutab_nonBac_silve.id
cut -f 1 $rootdir/result/ITS.unoise_otutab_nonFungi_silve.txt | tail -n+2 > $rootdir/result/ITS.unoise_otutab_nonFungi_silve.id
#这一步完成后我再执行了make_ASVfilter.sh,过滤了只在一个样本中出现的ASV和序列条数小于5的ASV，然后生成新的OTU.fa,再从按注释筛选特征表那一步往下运行


#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -fastx_getseqs $rootdir/unoise/16S.OTU.fa -labels $rootdir/result/16S.unoise_otutab_nonBac_silve.id -fastaout $rootdir/result/16S.unoise_otutab_nonBac_silve.fa
#awk 'NR==FNR{a[$1]=$0}NR>FNR{print a[$1]}'  $outdir/16S.unoise.silva.sintax.spike.new $rootdir/result/16S.unoise_otutab_nonBac_silve.id  > $rootdir/result/16S.unoise.silva.sintax.new
#sed -i 's/\t$/\td:Unassigned/' $rootdir/result/16S.unoise.silva.sintax.new
#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -otutab_stats $rootdir/result/16S.unoise_otutab_nonBac_silve.txt -output $rootdir/result/16S.unoise_otutab_nonBac_silve.stat


/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -fastx_getseqs $rootdir/unoise/ITS.OTU.fa -labels $rootdir/result/ITS.unoise_otutab_nonFungi_silve.id -fastaout $rootdir/result/ITS.unoise_otutab_nonFungi_silve.fa
awk 'NR==FNR{a[$1]=$0}NR>FNR{print a[$1]}'  $outdir/ITS.unoise.silva.sintax.spike.new $rootdir/result/ITS.unoise_otutab_nonFungi_silve.id  > $rootdir/result/ITS.unoise.silva.sintax.new
sed -i 's/\t$/\td:Unassigned/' $rootdir/result/ITS.unoise.silva.sintax.new
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -otutab_stats $rootdir/result/ITS.unoise_otutab_nonFungi_silve.txt -output $rootdir/result/ITS.unoise_otutab_nonFungi_silve.stat
#注释文件格式修改
#cut -f 1,4 $rootdir/result/16S.unoise.silva.sintax.new |sed 's/\td/\tk/;s/:/__/g;s/,/;/g;s/"//g;s/\/Chloroplast//' > $rootdir/result/16S_silva_taxonomy2.new.txt
cut -f 1,4 $rootdir/result/ITS.unoise.silva.sintax.new |sed 's/\td/\tk/;s/:/__/g;s/,/;/g;s/"//g;s/\/Chloroplast//' > $rootdir/result/ITS_silva_taxonomy2.new.txt

#awk 'BEGIN{OFS=FS="\t"}{delete a;a["k"]="Unassigned";a["p"]="Unassigned";a["c"]="Unassigned";a["o"]="Unassigned";a["f"]="Unassigned";a["g"]="Unassigned";a["s"]="Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=b[2];} print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' $rootdir/result/16S_silva_taxonomy2.new.txt > $temp/16S_silva_otus.tax
#sed 's/;/\t/g;s/.__//g;' $temp/16S_silva_otus.tax|cut -f 1-8 | sed '1s/^/OTUID\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n/' >$rootdir/result/16S_silva_taxonomy.new.txt

awk 'BEGIN{OFS=FS="\t"}{delete a;a["k"]="Unassigned";a["p"]="Unassigned";a["c"]="Unassigned";a["o"]="Unassigned";a["f"]="Unassigned";a["g"]="Unassigned";a["s"]="Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=b[2];} print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' $rootdir/result/ITS_silva_taxonomy2.new.txt > $temp/ITS_silva_otus.tax
sed 's/;/\t/g;s/.__//g;' $temp/ITS_silva_otus.tax|cut -f 1-8 | sed '1s/^/OTUID\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n/' >$rootdir/result/ITS_silva_taxonomy.new.txt

