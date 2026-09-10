#awk 'BEGIN{OFS=FS="\t"}{delete a;a["k"]="Unassigned";a["p"]="Unassigned";a["c"]="Unassigned";a["o"]="Unassigned";a["f"]="Unassigned";a["g"]="Unassigned";a["s"]="Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=x[i];} print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' result/16S_silva_taxonomy2.txt > 16S.tax

#awk 'BEGIN{OFS=FS=";"}{delete a;a["k"]="k__Unassigned";a["p"]="p__Unassigned";a["c"]="c__Unassigned";a["o"]="o__Unassigned";a["f"]="f__Unassigned";a["g"]="g__Unassigned";a["s"]="s__Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=x[i];} print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' result/16S_silva_taxonomy2.txt > 16S.tax
#awk 'BEGIN{OFS=FS=";"}{delete a;a["p"]="p__Unassigned";a["c"]="c__Unassigned";a["o"]="o__Unassigned";a["f"]="f__Unassigned";a["g"]="g__Unassigned";a["s"]="s__Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=x[i];} print $1,a["k"],a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' result/16S_silva_taxonomy2.txt > 16S.tax

#awk 'BEGIN{OFS=FS=";"}{delete a;a["p"]="p__Unassigned";a["c"]="c__Unassigned";a["o"]="o__Unassigned";a["f"]="f__Unassigned";a["g"]="g__Unassigned";a["s"]="s__Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=x[i];} print $1,a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' result/ITS_silva_taxonomy2.txt > ITS.tax

awk 'BEGIN{OFS=FS=";"}{delete a;a["p"]="p__Unassigned";a["c"]="c__Unassigned";a["o"]="o__Unassigned";a["f"]="f__Unassigned";a["g"]="g__Unassigned";a["s"]="s__Unassigned";split($2,x,";");for(i in x){split(x[i],b,"__");a[b[1]]=x[i];} print $1,a["p"],a["c"],a["o"],a["f"],a["g"],a["s"];}' result/16S_silva_taxonomy2.txt > 16S.tax


