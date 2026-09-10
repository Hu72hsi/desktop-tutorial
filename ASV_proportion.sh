#!/bin/bash
# 统计特征表中每个样本中某个ASV的占比

# 输入特征表文件
#featureTableFile=$1

# 输入ASV的编号
#ASV=$2

# 将特征表示文本转换为csv格式
#paste -d "\t" - - < $featureTableFile >> featureTable.csv

# 计算每个样本中某个ASV的占比
#echo "Sample,Percentage"
#cat $featureTableFile | grep -v "Taxon" | awk 'BEGIN{FS="\t";OFS=","}{a[NR]=$1;b[NR]=$(ASV);total[NR]=0}{total[NR]+=$2}END{for(i=1;i<=NR;i++){print a[i], (b[i]/total[NR])*100}}' ASV=$ASV

#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 feature_table.txt output_file.txt"
    exit 1
fi

feature_table=$1
output_file=$2
ASV_info=() #store each sample's ASV info

#extract ASV info from feature table 
for line in `cat $feature_table |awk '{print $1}'`
do
 sample=${line%%.*} #extract sample name
 ASV_per_sample=(`cat $feature_table |grep -e "$line$" | awk '{print $2}'`) #extract each sample's ASV 
 ASV_num=`echo ${ASV_per_sample[@]} |wc -w`     #count the number of ASVs 
 ASV_per_sample+=("${ASV_num}") #add the number to the end of the array 
 ASV_info+=("${sample}:${ASV_per_sample[@]}")  #add samples' ASV info to the array
done

#write the result into the output file 
echo -e "Sample\tASV_num\tPercentage" >$output_file
for item in ${ASV_info[@]}; do
 sample_name=`echo $item |cut -d":" -f1`
 ASV_array=(`echo $item |cut -d":" -f2-`)
 ASV_num=${ASV_array[-1]}
 ASV_percentage=`echo "scale=2;${ASV_num}/${ASV_num}" | bc`
 echo -e "${sample_name}\t${ASV_num}\t${ASV_percentage}" >>$output_file
done
#result/16S.unoise_otutab_nonBac_silva.txt 
