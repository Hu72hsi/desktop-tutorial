
Rscript /hwfssz1/ST_EARTH/P18Z10200N0112/USER/jincanzhi/software/EasyMicrobiome/script/format2lefse.R --input 16S.otutab.trimmed.filtered.txt \
--taxonomy 16S_silva_taxonomy.txt  --design metadata.txt \
--group Group --threshold 0.1 \
--output lefse/16S.LEfSe

