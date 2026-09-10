#替换下划线为:  ,只输出表头
awk ' { gsub(/_/,":"); print $0 }' sh_general_release_dynamic_s_27.10.2022_dev.fasta
#将数据库调整为自己需要的形式
awk '{ gsub(/__/,":"); print $0 }' sh_general_release_dynamic_s_27.10.2022_dev.fasta >ITS_1.fa
awk '{ gsub(/;/,","); print $0 }' ITS_1.fa >ITS2.fa
rm ITS_1.fa
awk '{ gsub(/\|k:/,";k:"); print $0 }' ITS2.fa >ITS_2022.fa
rm ITS2.fa
awk '{ gsub(/;k:/,";tax=k:"); print $0 }' ITS_2022.fa >ITS_dev_2022.fa
rm ITS_2022.fa
awk '/>/ {print $0";"} !/>/ {print}' ITS_dev_2022.fa>ITS_dev.fa
rm ITS_dev_2022.fa
awk '{gsub(/,..unidentified(.)*;$/,";");print $0}' ITS_dev.fa >ITS_dev_2022.fa
rm ITS_dev.fa
