#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -search_global ../../../database/16S.spike.fa -db unoise/16S.OTU.fa -strand both -id 0.9 -alnout 16Sspike.aln -blast6out 16Sspike..blast
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -search_global ../../../database/ITS.spike.fa -db unoise/ITS.OTU.fa -strand both -id 0.9 -alnout ITSspike.aln -blast6out ITSspike..blast
#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -search_global ../../../database/16S.spike.fa -db result/16S.unoise_otutab_nonBac_silve.fa -strand both -id 0.9 -alnout 16Sspike.aln_1 -blast6out 16Sspike..blast_1

#grep -A 4 'ASV6$' unoise/ITS.OTU.fa >ITS.ASV6.fa
#grep -A 4 'ASV26$' unoise/ITS.OTU.fa >ITS.ASV26.fa
#grep -A 4 'ASV24$' unoise/ITS.OTU.fa >ITS.ASV24.fa
#grep -A 4 'ASV27$' unoise/ITS.OTU.fa >ITS.ASV27.fa
:<<!
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -search_global ITS.ASV6.fa -db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/untax_fungi_Spike.fa -strand both -id 0.9 -alnout ITS.ASV6.aln -blast6out ITS.ASV6..blast
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -search_global ITS.ASV26.fa -db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/untax_fungi_Spike.fa -strand both -id 0.9 -alnout ITS.ASV26.aln -blast6out ITS.ASV26..blast
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -search_global ITS.ASV24.fa -db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/untax_fungi_Spike.fa -strand both -id 0.9 -alnout ITS.ASV24.aln -blast6out ITS.ASV24..blast
/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -search_global ITS.ASV27.fa -db /hwfssz1/ST_EARTH/P18Z10200N0112/USER/hucankun/database/untax_fungi_Spike.fasta -strand both -id 0.9 -alnout ITS.ASV27.aln -blast6out ITS.ASV27..blast
!
#/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/usearch -search_global ITS.ASV6.fa -db ITS.ASV26.fa -strand both -id 0.9 -alnout ITS.ASV6.aln -blast6out ITS.ASV6..blast




