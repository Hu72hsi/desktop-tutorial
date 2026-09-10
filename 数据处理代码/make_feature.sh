#!/bin/bash
# 输入文件#弃用
#特征表
#FEATURE_TABLE="result/raw/16S.unoise_otutable.txt"
FEATURE_TABLE="result/ITS.otutab.trimmed.filtered.txt"
#注释表
ANNOTATION_TABLE="result/16S.unoise.silva.sintax"
#物种spike的拷贝数
TARGET_COPY_NUMBER="copy_number.txt"
TARGET_SPECIES="Spike"
# 输出文件
OUTPUT_FILE="absolute_abundance.txt"
# 转置后的特征表
TRANSPOSED_FEATURE_TABLE="result/raw/16S.unoise_otutable.transposed.txt"
:<<!
# 转置特征表
awk '{
  for (i=1; i<=NF; i++) {
    if (NR==1) {
      # 如果是第一行，则创建一个以列为索引的数组
      col[i]=$i
    } else {
      # 如果是其他行，则将该行的元素添加到对应的列中
      a[i,NR-1]=$i
    }
  }
}
END {
  # 打印转置后的矩阵
  for (i=1; i<=NF; i++) {
    printf("%s",col[i])
    for (j=1; j<NR; j++) {
      printf(" %s",a[i,j])
    }
    printf("\n")
  }
}' "$FEATURE_TABLE" > "$TRANSPOSED_FEATURE_TABLE"

!

# 获取spike的OTU或ASV ID
TARGET_SPECIES_ID=$(grep -w "$TARGET_SPECIES" "$ANNOTATION_TABLE" | cut -f 1)
# 计算每个样本的总序列数
awk 'NR==1{for(i=2;i<=NF;i++) a[i]=$i} NR>1{s=0; for(i=2;i<=NF;i++) s+=$i; print $1, s}' "$TRANSPOSED_FEATURE_TABLE" > total_sequence.txt

# 计算相对丰度
awk -v id="TARGET_SPECIES_ID" 'NR==1 {for(i=1;i<=NF;i++) {if($i==id) {col=i;break}}} {print $1, $col/sum} NR>1 {sum=0; for(i=2;i<=NF;i++) {sum+=$i}}' "$TRANSPOSED_FEATURE_TABLE" >relative_abundance.txt

# 计算每个样本的总拷贝数
#awk -v copy="$TARGET_COPY_NUMBER" 'NR==1{for(i=2;i<=NF;i++) a[i]=$i} NR>1{s=0; for(i=2;i<=NF;i++) s+=$i; printf "%s\t%d\n", $1, s*copy/a[2]}' "$TRANSPOSED_FEATURE_TABLE" > total_copy_number.txt

