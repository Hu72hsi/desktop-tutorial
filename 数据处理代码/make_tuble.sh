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
:<<!
#去重复
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -fastx_uniques $rootdir/16S.all.sub50000.fa -fastaout $temp/16S.all.uniques.fa -sizeout -relabel Uniq_ -minuniquesize 2
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -fastx_uniques $rootdir/ITS.all.sub50000.fa -fastaout $temp/ITS.all.uniques.fa -sizeout -relabel Uniq_ -minuniquesize 2

#生成ASV去噪并去嵌合
#mkdir uparse unoise
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -unoise3 $temp/16S.all.uniques.fa -zotus $outdir/16S.raw.zotus.fa -tabbedout $rootdir/unoise/16S.unoise3.txt
awk 'BEGIN {n=1}; />/ {print ">ASV" n; n++} !/>/ {print}' $outdir/16S.raw.zotus.fa > $rootdir/unoise/16S.ZOTU.fa
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -unoise3 $temp/ITS.all.uniques.fa -zotus $outdir/ITS.raw.zotus.fa -tabbedout $rootdir/unoise/ITS.unoise3.txt
awk 'BEGIN {n=1}; />/ {print ">ASV" n; n++} !/>/ {print}' $outdir/ITS.raw.zotus.fa > $rootdir/unoise/ITS.ZOTU.fa


#生成特征表,用 vsearch reads map ratio比usearch好
#vsearch --usearch_global $rootdir/16S.all.sub50000.fa --db $rootdir/unoise/16S.ZOTU.fa --id 0.97 --otutabout $rootdir/unoise/16S.raw.Zotu.table.txt --biomout $rootdir/unoise/16S.raw.Zotu.table.biom 2>$rootdir/unoise/16S.make-table.log
#vsearch --usearch_global $rootdir/ITS.all.sub50000.fa --db $rootdir/unoise/ITS.ZOTU.fa --id 0.97 --otutabout $rootdir/unoise/ITS.raw.Zotu.table.txt --biomout $rootdir/unoise/ITS.raw.Zotu.table.biom 2>$rootdir/unoise/ITS.make-table.log
#运行这个的话后面要接qiime，但是缺少数据库，所以没用qiime，而且qiime注释没usearch好

#生成特征表
vsearch --usearch_global $rootdir/16S.all.sub50000.fa --db $rootdir/unoise/16S.ZOTU.fa  --otutabout $outdir/16S.unoise_otutable.txt --id 0.97 --threads 4
sed -i 's/\r//' $outdir/16S.unoise_otutable.txt
vsearch --usearch_global $rootdir/ITS.all.sub50000.fa --db $rootdir/unoise/ITS.ZOTU.fa  --otutabout $outdir/ITS.unoise_otutable.txt --id 0.97 --threads 4
sed -i 's/\r//' $outdir/ITS.unoise_otutable.txt

#按物种注释筛选特征表,不要运行下面两行
#更快
##vsearch --sintax 16S.all.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/database/amplicon/rdp_16s_v16.fa --tabbedout result/raw/unoise.rdp.otus.sintax --sintax_cutoff 0.6
#更慢
##vsearch --sintax 16S.all.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/database/amplicon/silva_16s_v123.fa --tabbedout result/raw/unoise.silva.otus.sintax --sintax_cutoff 0.6


vsearch --sintax $rootdir/unoise/16S.ZOTU.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/silva_16s_v123_spike.fa --tabbedout $outdir/16S.unoise.silva.sintax.spike --sintax_cutoff 0.8 --threads 3
#vsearch --sintax $rootdir/unoise/ITS.ZOTU.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/utax_reference_dataset_10.05.2021_fungi_Spike.fasta --tabbedout $outdir/ITS.unoise.silva.sintax.spike --sintax_cutoff 0.8 --threads 3
#上面是2021年的数据库
vsearch --sintax $rootdir/unoise/ITS.ZOTU.fa --db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/ITS_Spike_NCBIblast.fa --tabbedout $outdir/ITS.unoise.unite.sintax.spike --sintax_cutoff 0.8 --threads 3
#unite2022年数据库，会警告Non-ASCII character encountered in FASTA/FASTQ header，但是不会停止，不用管，可能是例如Epichloë_amarillans中的ë引起的
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/software/script/otutab_filter_nonBac.R --input $outdir/16S.unoise_otutable.txt --taxonomy $outdir/16S.unoise.silva.sintax.spike --output $rootdir/result/16S.unoise_otutab_nonBac_silva.txt --stat $outdir/16S.unoise_otutab_nonBac_silva.stat --discard $outdir/16S.unoise_otutab_nonBac_silva.sintax.discard
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/software/script/otutab_filter_nonFungi.R --input $outdir/ITS.unoise_otutable.txt --taxonomy $outdir/ITS.unoise.unite.sintax.spike --output $rootdir/result/ITS.unoise_otutab_nonFungi_unite.txt --stat $outdir/ITS.unoise_otutab_nonFungi_unite.stat --discard $outdir/ITS.unoise_otutab_nonFungi_unite.sintax.discard
#上面的R脚本是我改过的，筛选真菌、细菌、古细菌和Spike（一个人为插入序列）根据需要自己改代码或直接下载源码

#统计特征表中reads数小于5的ASVs数量
/jdfssz1/ST_EARTH/P18Z10200N0112/wenjialing/softwares/miniconda3/bin/R --slave --no-restore --file=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/software/script/otutab_stats.R --args $rootdir/result/16S.unoise_otutab_nonBac_silva.txt  > $rootdir/result/16S.otutab_stats.log
#以5为阈值，丢弃ASVs

/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -otutab_trim $rootdir/result/16S.unoise_otutab_nonBac_silva.txt  -min_otu_size 5 -output $rootdir/result/16S.otutab.trimmed.txt
sed -i 's/#OTU ID/#OTUID/g' $rootdir/result/16S.otutab.trimmed.txt
#去除仅在一个样本中出现的ASVs
#/jdfssz1/ST_EARTH/P18Z10200N0112/wenjialing/softwares/miniconda3/bin/biom convert -i $rootdir/result/16S.otutab.trimmed.txt -o $rootdir/result/16S.otutab.trimmed.biom --table-type="OTU table" --to-json
#source /hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/anaconda3/etc/profile.d/conda.sh
#conda activate qiime2-2021.4
#qiime tools import --input-path $rootdir/result/16S.otutab.trimmed.biom --type 'FeatureTable[Frequency]' --input-format BIOMV100Format --output-path $rootdir/result/16S.otutab.trimmed.qza
#qiime feature-table filter-features \
#  --i-table $rootdir/result/ITS.otutab.trimmed.qza \
#  --p-min-samples 2 \
#  --o-filtered-table $rootdir/result/16S.otutab.trimmed.filtered.qza
#qiime tools export \ 
#  --input-path $rootdir/result/16S.otutab.trimmed.filtered.qza \
#  --output-path $rootdir/result/16S.otutab.trimmed.filtered
#/jdfssz1/ST_EARTH/P18Z10200N0112/wenjialing/softwares/miniconda3/bin/biom convert -i $rootdir/result/16S.otutab.trimmed.filtered/feature-table.biom -o $rootdir/result/16S.otutab.trimmed.filtered.txt --to-tsv  #据统计，共去除了个ASVs, 剩余 ASVs
#自己写的去除仅在一个样本中出现的ASVs方法
!
awk '{for(i = 2; i <= NF; i++) if($i == "0") {j++};if(j < NF-2) {print $0}; j = 0}' $rootdir/result/16S.otutab.trimmed.txt >$rootdir/result/16S.otutab.trimmed.filtered.txt
#sed -i 's/#OTUID/#OTU/g' $rootdir/result/16S.otutab.trimmed.filtered.txt
:<<!
#统计特征表中reads数小于5的ASVs数量
/jdfssz1/ST_EARTH/P18Z10200N0112/wenjialing/softwares/miniconda3/bin/R --slave --no-restore --file=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/software/script/otutab_stats.R --args $rootdir/result/ITS.unoise_otutab_nonFungi_unite.txt  > $rootdir/result/ITS.otutab_stats.log
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -otutab_trim $rootdir/result/ITS.unoise_otutab_nonFungi_unite.txt -min_otu_size 5  -output $rootdir/result/ITS.otutab.trimmed.txt
sed -i 's/#OTU ID/#OTUID/g' $rootdir/result/ITS.otutab.trimmed.txt
#去除仅在一个样本中出现的ASVs
#/jdfssz1/ST_EARTH/P18Z10200N0112/wenjialing/softwares/miniconda3/bin/biom convert -i $rootdir/result/ITS.otutab.trimmed.txt -o $rootdir/result/ITS.otutab.trimmed.biom --table-type="OTU table" --to-json
#source /hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/anaconda3/etc/profile.d/conda.sh
#conda activate qiime2-2021.4
#qiime tools import --input-path $rootdir/result/ITS.otutab.trimmed.biom --type 'FeatureTable[Frequency]' --input-format BIOMV100Format --output-path $rootdir/result/ITS.otutab.trimmed.qza
#qiime feature-table filter-features \
#  --i-table $rootdir/result/ITS.otutab.trimmed.qza \
#  --p-min-samples 2 \
#  --o-filtered-table $rootdir/result/ITS.otutab.trimmed.filtered.qza
#qiime tools export \ 
#  --input-path $rootdir/result/ITS.otutab.trimmed.filtered.qza \
#  --output-path $rootdir/result/ITS.otutab.trimmed.filtered
#/jdfssz1/ST_EARTH/P18Z10200N0112/wenjialing/softwares/miniconda3/bin/biom convert -i $rootdir/result/ITS.otutab.trimmed.filtered/feature-table.biom -o $rootdir/result/ITS.otutab.trimmed.filtered.txt --to-tsv  #据统计，共去除了个ASVs, 剩余 ASVs
!
awk '{for(i = 2; i <= NF; i++) if($i == "0") {j++};if(j < NF-2) {print $0}; j = 0}' $rootdir/result/ITS.otutab.trimmed.txt >$rootdir/result/ITS.otutab.trimmed.filtered.txt

#sed -i 's/#OTUID/#OTU/g' $rootdir/result/ITS.otutab.trimmed.filtered.txt

#筛选特征表对应序的列和物种注释
cut -f 1 $rootdir/result/16S.otutab.trimmed.filtered.txt | tail -n+2 > $rootdir/result/16S.unoise_otutab_nonBac_silva.id
cut -f 1 $rootdir/result/ITS.otutab.trimmed.filtered.txt  | tail -n+2 > $rootdir/result/ITS.unoise_otutab_nonFungi_unite.id


usearch -fastx_getseqs $rootdir/unoise/16S.ZOTU.fa -labels $rootdir/result/16S.unoise_otutab_nonBac_silva.id -fastaout $rootdir/result/16S.unoise_otutab_nonBac_silva.fa
awk 'NR==FNR{a[$1]=$0}NR>FNR{print a[$1]}'  $outdir/16S.unoise.silva.sintax.spike $rootdir/result/16S.unoise_otutab_nonBac_silva.id  > $rootdir/result/16S.unoise.silva.sintax
sed -i 's/\t$/\td:Unassigned/g' $rootdir/result/16S.unoise.silva.sintax
usearch -otutab_stats $rootdir/result/16S.otutab.trimmed.filtered.txt -output $rootdir/result/16S.unoise_otutab_nonBac_silva.stat


usearch -fastx_getseqs $rootdir/unoise/ITS.ZOTU.fa -labels $rootdir/result/ITS.unoise_otutab_nonFungi_unite.id -fastaout $rootdir/result/ITS.unoise_otutab_nonFungi_unite.fa
awk 'NR==FNR{a[$1]=$0}NR>FNR{print a[$1]}'  $outdir/ITS.unoise.unite.sintax.spike $rootdir/result/ITS.unoise_otutab_nonFungi_unite.id  > $rootdir/result/ITS.unoise.unite.sintax
sed -i 's/\t$/\td:Unassigned/g;s/unidentified/Unassigned/g' $rootdir/result/ITS.unoise.unite.sintax
usearch -otutab_stats $rootdir/result/ITS.otutab.trimmed.filtered.txt -output $rootdir/result/ITS.unoise_otutab_nonFungi_unite.stat
#注释文件格式修改
cut -f 1,4 $rootdir/result/16S.unoise.silva.sintax |sed 's/\td/\tk/;s/:/__/g;s/,/;/g;s/"//g;s/\/Chloroplast//' > $rootdir/result/16S_silva_taxonomy2.txt
cut -f 1,4 $rootdir/result/ITS.unoise.unite.sintax |sed 's/\td/\tk/;s/:/__/g;s/,/;/g;s/"//g;s/\/Chloroplast//' > $rootdir/result/ITS_unite_taxonomy2.txt

awk 'BEGIN{OFS=FS="\t"}{delete a;a["k"]="Unassigned";a["p"]="Unassigned";a["c"]="Unassigned";a["o"]="Unassigned";a["f"]="Unassigned";a["g"]="Unassigned";a["s"]="Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=b[2];} print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' $rootdir/result/16S_silva_taxonomy2.txt > $temp/16S_silva_otus.tax
sed 's/;/\t/g;s/.__//g;' $temp/16S_silva_otus.tax|cut -f 1-8 | sed '1s/^/OTUID\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n/' >$rootdir/result/16S_silva_taxonomy.txt

awk 'BEGIN{OFS=FS="\t"}{delete a;a["k"]="Unassigned";a["p"]="Unassigned";a["c"]="Unassigned";a["o"]="Unassigned";a["f"]="Unassigned";a["g"]="Unassigned";a["s"]="Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=b[2];} print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' $rootdir/result/ITS_unite_taxonomy2.txt > $temp/ITS_unite_otus.tax
sed 's/;/\t/g;s/.__//g;' $temp/ITS_unite_otus.tax|cut -f 1-8 | sed '1s/^/OTUID\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\n/' >$rootdir/result/ITS_unite_taxonomy.txt

