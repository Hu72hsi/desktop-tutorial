rootdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj
#outdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/16S.reads_prepare
outdir=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/project/soybean_16s/smsj/ITS.reads_prepare
#for sample in `cat $rootdir/16S.sample.list`
for sample in `cat $rootdir/ITS.sample.list`
#要切换16S和ITS只需要切换上面几行代码，barcode拆分和剪切除外
do
    if [ ! -d $outdir/$sample ];then mkdir $outdir/$sample ; fi
    #barcode拆分
    #提取前10bp
    #java -jar /jdfssz1/ST_EARTH/P18Z10200N0112/wenjiawen/software/Trimmomatic-0.38/trimmomatic-0.38.jar SE -phred33 $rootdir/*/forward/${sample}.fq.gz $outdir/$sample/${sample}.barcode.f.fq.gz CROP:10
    #java -jar /jdfssz1/ST_EARTH/P18Z10200N0112/wenjiawen/software/Trimmomatic-0.38/trimmomatic-0.38.jar SE -phred33 $rootdir/*/reverse/${sample}.fq.gz $outdir/$sample/${sample}.barcode.r.fq.gz CROP:10
    #改格式
    #vsearch --fastq_filter $outdir/$sample/${sample}.barcode.f.fq.gz --fastaout $outdir/$sample/${sample}.barcode.f.fa --fastq_eeout --relabel ${sample}
    #sed -i '/>/'d $outdir/$sample/${sample}.barcode.f.fa
    #vsearch --fastq_filter $outdir/$sample/${sample}.barcode.r.fq.gz --fastaout $outdir/$sample/${sample}.barcode.r.fa --fastq_eeout --relabel ${sample}
    #sed -i '/>/'d $outdir/$sample/${sample}.barcode.r.fa

    #按照引物拆分
    #cat 16S.sampleall |while read a b c d ;do perl /hwfssz1/ST_EARTH/P18Z10200N0112/USER/fangxiaolong/tube/script/split_by_one_barcode.pl $a $b $rootdir/*/forward/${sample}.fq.gz $outdir/$sample/ ;done
    #cat 16S.sampleall |while read a b c d ;do perl /hwfssz1/ST_EARTH/P18Z10200N0112/USER/fangxiaolong/tube/script/split_by_one_barcode.pl $c $d $rootdir/*/reverse/${sample}.fq.gz $outdir/$sample/ ;done

    #cat ITS.sampleall |while read a b c d ;do perl /hwfssz1/ST_EARTH/P18Z10200N0112/USER/fangxiaolong/tube/script/split_by_one_barcode.pl $a $b $rootdir/*/forward/${sample}.fq.gz $outdir/$sample/ ;done
    #cat ITS.sampleall |while read a b c d ;do perl /hwfssz1/ST_EARTH/P18Z10200N0112/USER/fangxiaolong/tube/script/split_by_one_barcode.pl $c $d $rootdir/*/reverse/${sample}.fq.gz $outdir/$sample/ ;done
    #上面拆分按需要决定加不加
cutadapt -u 29 -a ATTAGAWACCCVHGTAGTCC -e 0.15 -m 250 --too-short-output $outdir/$sample/${sample}.too.short_f.fq -o $outdir/$sample/${sample}.trimmed_f.fq.gz --untrimmed-output $outdir/$sample/${sample}.untrimmed_f.fq.gz $rootdir/*/forward/${sample}.fq.gz >> $outdir/$sample/${sample}.rmprimer.log
cutadapt -u 30 -a TTACCGCGGCKGCTGGCAC -e 0.15 -m 250 --too-short-output $outdir/$sample/${sample}.too.short_r.fq -o $outdir/$sample/${sample}.trimmed_r.fq.gz --untrimmed-output $outdir/$sample/${sample}.untrimmed_r.fq.gz $rootdir/*/reverse/${sample}.fq.gz >> $outdir/$sample/${sample}.rmprimer.log
   #上面是16S
    cutadapt -u 32 -a GCATCGATGAAGAACGCAGC -e 0.15 -m 250 --too-short-output $outdir/$sample/${sample}.too.short_f.fq -o $outdir/$sample/${sample}.trimmed_f.fq.gz --untrimmed-output $outdir/$sample/${sample}.untrimmed_f.fq.gz $rootdir/*/forward/${sample}.fq.gz >> $outdir/$sample/${sample}.rmprimer.log
    cutadapt -u 30 -a TTACTTCCTCTAAATGACCAAG -e 0.15 -m 250 --too-short-output $outdir/$sample/${sample}.too.short_r.fq -o $outdir/$sample/${sample}.trimmed_r.fq.gz --untrimmed-output $outdir/$sample/${sample}.untrimmed_r.fq.gz $rootdir/*/reverse/${sample}.fq.gz >> $outdir/$sample/${sample}.rmprimer.log
    #ITS
    #上面剪切,-u是引物加barcode长度，-a是引物序列，引物中的兼并碱基自己查，这两个根据自己的数据来，后面-e是误差，-m是剪切后的序列最小要大
于250
    vsearch --fastx_revcomp $outdir/$sample/${sample}.trimmed_r.fq.gz --fastqout $outdir/$sample/${sample}.r.fq
    gzip $outdir/$sample/${sample}.r.fq
    cat $outdir/$sample/${sample}.trimmed_f.fq.gz $outdir/$sample/${sample}.r.fq.gz >$outdir/$sample/${sample}.all.fq.gz
    #将反向序列反转再cat进正向序列
#双端合并不用运行
    #vsearch --fastq_mergepairs $outdir/$sample/${sample}.trimmed_f.fq.gz --reverse $outdir/$sample/${sample}.trimmed_r.fq.gz  --fastqout $outdir/$sample/${sample}.merged.fq --relabel ${i}

    SOAPnuke filter -1 $outdir/$sample/${sample}.all.fq.gz  -C ${sample}.filtered.fq.gz -o $outdir/$sample -l 20 -q 0.15 -n 0.01 -T 3
    #这个是华大自己的软件 ，过滤低质量fastq数据,-1是输入,-C是过滤后文件名,-o是输出目录,-l是低质量阈值,-q是低质量率（低质量数据所占比率）,-n是可以允许N碱基比率阈值, -T是进程线编号
    #/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/fastqc $outdir/$sample/${sample}.filtered.fq.gz -o $outdir/$sample
    #FastQC是一款基于Java的软件，它可以快速地对测序数据进行质量评估,这行去掉也行，看自己需不需要用
    gzip -d $outdir/$sample/${sample}.filtered.fq.gz
    /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -fastq_filter $outdir/$sample/${sample}.filtered.fq -fastq_maxee 1000.0 -fastaout $outdir/$sample/${sample}.filtered.fa -fastq_eeout -sample $sample
    #将fq文件转化成fa文件，-fastq_maxee 应用任何截断选项后，丢弃读取中所有基数的总预期误差> E 的读取，
    tags=`grep -c '>' $outdir/$sample/${sample}.filtered.fa`
    if [ $tags -gt 50000 ]
    #筛选条数大于50000的
    then
         /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/usearch -fastx_subsample $outdir/$sample/${sample}.filtered.fa -sample_size 50000 -fastaout $outdir/$sample/${sample}.sub50000.fa
elif [ $tags -gt 20000 ]
    #将条数大于20000的也保存，这个看自己需求改
    then
           cat $outdir/$sample/${sample}.filtered.fa > $outdir/$sample/${sample}.sub50000.fa
    else
           echo -e "$sample\t$tags" >> $outdir/bad.sample.list
        fi
        rm $outdir/$sample/${sample}.r.fq.gz
done
#不运行
    #cat ITS.sampleall |while read a b c d ;do cat $rootdir/ITS.reads_prepare/*/${a}.fq.gz >$rootdir/ITS.reads_prepare/${a}.all.fq.gz ;cat $rootdir/ITS.reads_prepare/*/${c}.fq.gz >$rootdir/ITS.reads_prepare/${c}.all.fq.gz ;b=$(cat $rootdir/ITS.reads_prepare/${a}.all.fq.gz | wc -l) ;d=$(cat $rootdir/ITS.reads_prepare/${c}.all.fq.gz | wc -l) ;printf "$a $b $c $d \n" >>ITS.barcode2.txt ;done
    #cat 16S.sampleall |while read a b c d ;do cat $rootdir/16S.reads_prepare/*/${a}.fq.gz >$rootdir/16S.reads_prepare/${a}.all.fq.gz ;cat $rootdir/16S.reads_prepare/*/${c}.fq.gz >$rootdir/16S.reads_prepare/${c}.all.fq.gz ;b=$(cat $rootdir/16S.reads_prepare/${a}.all.fq.gz | wc -l) ;d=$(cat $rootdir/16S.reads_prepare/${c}.all.fq.gz | wc -l) ;printf "$a $b $c $d \n" >>16S.barcode2.txt ;done
    #awk -v OFS="\t" '$1=$1' ITS.barcode2.txt >ITS.barcode.txt
    #awk -v OFS="\t" '$1=$1' 16S.barcode2.txt >16S.barcode.txt
#cat $outdir/*/*.barcode.f.fa >>$outdir/all.barcode.f.fa
#cat $outdir/*/*.barcode.r.fa >>$outdir/all.barcode.r.fa
#运行

#for sample in `cat $rootdir/16S1.sample.list`
#do
#  cat $outdir/$sample/${sample}.barcode.f.fa >>$outdir/16S1/all.barcode.f.fa
#  cat $outdir/$sample/${sample}.barcode.r.fa >>$outdir/16S1/all.barcode.r.fa
#  cat 16S.sampleall |while read a b c d ;do cat $outdir/$sample/${a}.fq.gz >>$outdir/16S1/${a}.all.fq.gz ;cat $outdir/$sample/${c}.fq.gz >>$outdir/16S1/${c}.all.fq.gz ;done
#done
#cat 16S.sampleall |while read a b c d ;do b=$(cat $outdir/16S1/${a}.all.fq.gz | wc -l) ;d=$(cat $outdir/16S1/${c}.all.fq.gz | wc -l) ;printf "$a $b $c $d \n" >>16S1.barcode2.txt ;done
#awk -v OFS="\t" '$1=$1' 16S1.barcode2.txt >16S1.barcode.txt

#for sample in `cat $rootdir/16S2.sample.list`
#do
#  cat $outdir/$sample/${sample}.barcode.f.fa >>$outdir/16S2/all.barcode.f.fa
#  cat $outdir/$sample/${sample}.barcode.r.fa >>$outdir/16S2/all.barcode.r.fa
#  cat 16S.sampleall |while read a b c d ;do cat $outdir/$sample/${a}.fq.gz >>$outdir/16S2/${a}.all.fq.gz ;cat $outdir/$sample/${c}.fq.gz >>$outdir/16S2/${c}.all.fq.gz ;done
#done

#cat 16S.sampleall |while read a b c d ;do b=$(cat $outdir/16S2/${a}.all.fq.gz | wc -l) ;d=$(cat $outdir/16S2/${c}.all.fq.gz | wc -l) ;printf "$a $b $c $d \n" >>16S2.barcode2.txt ;done
#awk -v OFS="\t" '$1=$1' 16S2.barcode2.txt >16S2.barcode.txt

#for sample in `cat $rootdir/ITS1.sample.list`
#do
#  cat $outdir/$sample/${sample}.barcode.f.fa >>$outdir/ITS1/all.barcode.f.fa
#  cat $outdir/$sample/${sample}.barcode.r.fa >>$outdir/ITS1/all.barcode.r.fa
#  cat ITS.sampleall |while read a b c d ;do cat $outdir/$sample/${a}.fq.gz >>$outdir/ITS1/${a}.all.fq.gz ;cat $outdir/$sample/${c}.fq.gz >>$outdir/ITS1/${c}.all.fq.gz ;done
#done
#cat ITS.sampleall |while read a b c d ;do b=$(cat $outdir/ITS1/${a}.all.fq.gz | wc -l) ;d=$(cat $outdir/ITS1/${c}.all.fq.gz | wc -l) ;printf "$a $b $c $d \n" >>ITS1.barcode2.txt ;done
#awk -v OFS="\t" '$1=$1' ITS1.barcode2.txt >ITS1.barcode.txt
#for sample in `cat $rootdir/ITS2.sample.list`
#do
 # cat $outdir/$sample/${sample}.barcode.f.fa >>$outdir/ITS2/all.barcode.f.fa
 # cat $outdir/$sample/${sample}.barcode.r.fa >>$outdir/ITS2/all.barcode.r.fa
#  cat ITS.sampleall |while read a b c d ;do cat $outdir/$sample/${a}.fq.gz >>$outdir/ITS2/${a}.all.fq.gz ;cat $outdir/$sample/${c}.fq.gz >>$outdir/ITS2/${c}.all.fq.gz ;done
#重复统计
#sort用cat > 重定向输入原文件会把原文件清空要用-o

#sort -r $outdir/16S1/all.barcode.f.fa | uniq -c >$outdir/16S1/all.barcode.f.txt
#sort -n -r -k 1 $outdir/16S1/all.barcode.f.txt -o $outdir/16S1/all.barcode.f.txt
#sort -r $outdir/16S1/all.barcode.r.fa | uniq -c >$outdir/16S1/all.barcode.r.txt
#sort -n -r -k 1 $outdir/16S1/all.barcode.r.txt -o $outdir/16S1/all.barcode.r.txt
#awk -v OFS="\t" '$1=$1' $outdir/16S1/all.barcode.f.txt >$outdir/16S1/16S1.all.barcode.f.txt
#awk -v OFS="\t" '$1=$1' $outdir/16S1/all.barcode.r.txt >$outdir/16S1/16S1.all.barcode.r.txt

#sort -r $outdir/16S2/all.barcode.f.fa | uniq -c >$outdir/16S2/all.barcode.f.txt
#sort -n -r -k 1 $outdir/16S2/all.barcode.f.txt -o $outdir/16S2/all.barcode.f.txt
#sort -r $outdir/16S2/all.barcode.r.fa | uniq -c >$outdir/16S2/all.barcode.r.txt
#sort -n -r -k 1 $outdir/16S2/all.barcode.r.txt -o $outdir/16S2/all.barcode.r.txt
#awk -v OFS="\t" '$1=$1' $outdir/16S2/all.barcode.f.txt >$outdir/16S2/16S2.all.barcode.f.txt
#awk -v OFS="\t" '$1=$1' $outdir/16S2/all.barcode.r.txt >$outdir/16S2/16S2.all.barcode.r.txt

#sort -r $outdir/ITS1/all.barcode.f.fa | uniq -c >$outdir/ITS1/all.barcode.f.txt
#sort -n -r -k 1 $outdir/ITS1/all.barcode.f.txt -o $outdir/ITS1/all.barcode.f.txt
#sort -r $outdir/ITS1/all.barcode.r.fa | uniq -c >$outdir/ITS1/all.barcode.r.txt
#sort -n -r -k 1 $outdir/ITS1/all.barcode.r.txt -o $outdir/ITS1/all.barcode.r.txt
#awk -v OFS="\t" '$1=$1' $outdir/ITS1/all.barcode.f.txt >$outdir/ITS1/ITS1.all.barcode.f.txt
#awk -v OFS="\t" '$1=$1' $outdir/ITS1/all.barcode.r.txt >$outdir/ITS1/ITS1.all.barcode.r.txt

#sort -r $outdir/ITS2/all.barcode.f.fa | uniq -c >$outdir/ITS2/all.barcode.f.txt
#sort -n -r -k 1 $outdir/ITS2/all.barcode.f.txt -o $outdir/ITS2/all.barcode.f.txt
#sort -r $outdir/ITS2/all.barcode.r.fa | uniq -c >$outdir/ITS2/all.barcode.r.txt
#sort -n -r -k 1 $outdir/ITS2/all.barcode.r.txt -o $outdir/ITS2/all.barcode.r.txt
#awk -v OFS="\t" '$1=$1' $outdir/ITS2/all.barcode.f.txt >$outdir/ITS2/ITS2.all.barcode.f.txt
#awk -v OFS="\t" '$1=$1' $outdir/ITS2/all.barcode.r.txt >$outdir/ITS2/ITS2.all.barcode.r.txt


cat $outdir/*/*.sub50000.fa > $rootdir/16S.all.sub50000.fa
cat $outdir/*/*.sub50000.fa > $rootdir/ITS.all.sub50000.fa
#合并
#统计总条数
#tags=`grep -c '>' $rootdir/16S.all.sub50000.fa`
#echo "$tags/1000000"|bc

