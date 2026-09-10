#已完成
#awk '{for(i = 0; i <= NF; i++) if($i == "0") {j++};if(j == NF-2) {print $1}; j = 0}' $rootdir/16S.unoise_zotutab_nonBac_silve.txt >16S.delASV.txt
#没有
#awk '{if(NR > 1) {for(i = 0; i <= NF; i++) j=(j+$i);if(j < 5) {print $1}; j = 0}}' $rootdir/16S.unoise_zotutab_nonBac_silve.txt  
#已完成 
#awk '{for(i = 0; i <= NF; i++) if($i == "0") {j++};if(j == NF-2) {print $1}; j = 0}' $rootdir/ITS.unoise_zotutab_nonFungi_silve.txt >ITS.delASV.txt
#与上面重合
#awk '{if(NR > 1) {for(i = 0; i <= NF; i++) j=(j+$i);if(j < 5) {print $1}; j = 0}}' $rootdir/ITS.unoise_zotutab_nonFungi_silve.txt 

#for i in `cat 16S.delASV.txt`
#do
#    sed -i "/${i}$/, +4d" unoise/16S.OTU.fa 
#done

#for i in `cat ITS.delASV.txt`
#do
#    sed -i "/${i}$/, +4d" unoise/ITS.OTU.fa 
#done

#弃用，留着

#筛选存在于80%样本的ASV
#awk '{for(i = 2; i <= NF; i++) if($i == "0") {j++};if(j < (NF-1)*0.2) {print $1}; j = 0}' 16S.A1-A21.txt >delASV_name.txt
#awk '{for(i = 2; i <= NF; i++) if($i == "0") {j++};if(j ==  0) {print $0}; j = 0}' 16S.A1-A21.txt >nodelASV.txt
#100%
#awk '{for(i=2; i<=NF; i++) {if ($i==0) {j=1;break}}} !j {print $0} j=0' 16S.A1-A21.txt > nodelASV.txt
#awk '{for(i=2; i<=NF; i++) {if ($i==0) {j=1;break}}} !j {print $1} j=0' 16S.A1-A21.txt > delASV_name.txt
awk '{for(i=2; i<=NF; i++) {if ($i==0) {j=1;break}}} !j {print $0} j=0' ITS.A1-A21.txt > ITS.nodelASV.txt
