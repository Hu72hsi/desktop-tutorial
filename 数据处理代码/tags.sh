rootdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj
outdir_1=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/16S.reads_prepare
outdir_2=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/ITS.reads_prepare
#printf "16S_sample\t16S_tag\n" >>16S_ITS_tags.txt
#for sample in `cat $rootdir/16S.sample.list`
#for sample in `cat $rootdir/ITS.sample.list`
#do
#    tag=`grep -c '>' $outdir_1/$sample/${sample}.filtered.fa`
#    printf "$sample\t$tag\n" >>16S_ITS_tags.txt
#done
#printf "ITS_sample\tITS_tag\n" >>16S_ITS_tags.txt
#for sample in `cat $rootdir/ITS.sample.list`
#do
#    tag=`grep -c '>' $outdir_2/$sample/${sample}.filtered.fa`
#    printf "$sample\t$tag\n" >>16S_ITS_tags.txt
#done

#grep -v -f result/16S.unoise_otutab_nonBac_silve.fa unoise/16S.OTU.fa >16S.OTU.OUT.fa
#grep -v -f result/ITS.unoise_otutab_nonFungi_silve.fa unoise/ITS.OTU.fa >ITS.OTU.OUT.fa

tag=`grep -c '>' $rootdir/result/16S.unoise_otutab_nonBac_silva.fa`
echo "$tag"
#tag=`grep -c '>' $rootdir/unoise/16S.OTU.fa`
#echo "$tag"
tag=`grep -c '>' $rootdir/result/ITS.unoise_otutab_nonFungi_unite.fa`
echo "$tag"
#tag=`grep -c '>' $rootdir/unoise/ITS.OTU.fa`
#echo "$tag"

#for sample in `cat $rootdir/16S.sample.list`
#do
#    b=$(cat $outdir_1/*/${sample}.all.fq.gz | wc -l)
#    printf "$sample $b \n" >>16S.tags2.txt
#done
#awk -v OFS="\t" '$1=$1' 16S.tags2.txt >16S.tags.txt

#for sample in `cat $rootdir/ITS.sample.list`
#do
#    b=$(cat $outdir_2/*/${sample}.all.fq.gz | wc -l)
#    printf "$sample $b \n" >>ITS.tags2.txt
#done
#awk -v OFS="\t" '$1=$1' ITS.tags2.txt >ITS.tags.txt

