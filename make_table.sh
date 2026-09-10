rootdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/result

#alpha分析
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/EasyMicrobiome/script/otutab_rare.R --input $rootdir/ITS.unoise_otutab_nonFungi_silve.txt --seed 1 --normalize $rootdir/alpha/ITS.otutab_rare_new.txt --output $rootdir/alpha/ITS.vegan_new.txt
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -otutab_stats $rootdir/alpha/ITS.otutab_rare_new.txt -output $rootdir/alpha/ITS.otutab_rare_new.stat

/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -alpha_div $rootdir/alpha/ITS.otutab_rare_new.txt -output $rootdir/alpha/ITS.alpha.new.txt

/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -alpha_div_rare $rootdir/alpha/ITS.otutab_rare_new.txt -output $rootdir/alpha/ITS.alpha_rare_new.txt  -method without_replacement

#mkdir -p result/beta/
#不需要分组
#Bata分析
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -cluster_agg unoise/ITS.OTU.fa -treeout $rootdir/beta/ITS.otus.tree
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -beta_div $rootdir/alpha/ITS.otutab_rare_new.txt -tree $rootdir/beta/ITS.otus.tree  -filename_prefix $rootdir/beta/

for i in p c o f g;do /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -sintax_summary $rootdir/ITS.unoise.silva.sintax.new -otutabin $rootdir/alpha/ITS.otutab_rare_new.txt -rank ${i} -output $rootdir/tax/ITS.sum_${i}_new.txt ;done
sed -i 's/(//g;s/)//g;s/\"//g;s/\#//g;s/\/Chloroplast//g' $rootdir/tax/ITS.sum_*_new.txt
#按各层级分层

#alpha分析
/jdfssz1/ST_EARTH/P18Z10200N0112/jincanzhi/software/miniconda3/bin/Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/EasyMicrobiome/script/otutab_rare.R --input $rootdir/16S.unoise_otutab_nonBac_silve.txt --seed 1 --normalize $rootdir/alpha/16S.otutab_rare_new.txt --output $rootdir/alpha/16S.vegan_new.txt
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -otutab_stats $rootdir/alpha/16S.otutab_rare_new.txt -output $rootdir/alpha/16S.otutab_rare_new.stat

/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -alpha_div $rootdir/alpha/16S.otutab_rare_new.txt -output $rootdir/alpha/16S.alpha.new.txt

/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -alpha_div_rare $rootdir/alpha/16S.otutab_rare_new.txt -output $rootdir/alpha/16S.alpha_rare_new.txt  -method without_replacement

#不需要分组
#Bata分析
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -cluster_agg unoise/16S.OTU.fa -treeout $rootdir/beta/16S.otus.tree
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -beta_div $rootdir/alpha/16S.otutab_rare_new.txt -tree $rootdir/beta/16S.otus.tree  -filename_prefix $rootdir/beta/

for i in p c o f g;do /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -sintax_summary $rootdir/16S.unoise.silva.sintax.new -otutabin $rootdir/alpha/16S.otutab_rare_new.txt -rank ${i} -output $rootdir/tax/16S.sum_${i}_new.txt ;done
sed -i 's/(//g;s/)//g;s/\"//g;s/\#//g;s/\/Chloroplast//g' $rootdir/tax/16S.sum_*_new.txt




