export PATH=/hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/software/anaconda3/envs/qiime2-2021.4/bin:$PATH
qiime tools import --input-path ZOTU.fa --output-path raw.zotus.qza  --type 'FeatureData[Sequence]'
qiime feature-classifier classify-sklearn --i-classifier /hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/project/07.SG/gg-13-8-99-515-806-nb-classifier.qza --i-reads raw.zotus.qza --p-confidence 0.8 --o-classification Zotu_taxonomy0.8.qza
qiime feature-classifier classify-sklearn --i-classifier /hwfssz1/ST_EARTH/P18Z10200N0112/USER/luoxinyue/project/07.SG/gg-13-8-99-515-806-nb-classifier.qza --i-reads raw.zotus.qza --p-confidence 0.95 --o-classification Zotu_taxonomy0.95.qza
qiime metadata tabulate  --m-input-file Zotu_taxonomy0.8.qza  --o-visualization Zotu_taxonomy0.8.qzv
qiime metadata tabulate  --m-input-file Zotu_taxonomy0.95.qza  --o-visualization Zotu_taxonomy0.95.qzv
#1.prepare OTU tabel
qiime tools import --input-path raw.Zotu.table.biom --type 'FeatureTable[Frequency]' --input-format BIOMV100Format --output-path raw.Zotu.table.qza
qiime feature-table summarize --i-table raw.Zotu.table.qza --o-visualization raw.Zotu.table.qzv
qiime feature-table filter-features \
  --i-table raw.Zotu.table.qza \
  --p-min-samples 2 \
  --p-min-frequency 20 \
  --o-filtered-table feature-frequency-filtered-table.qza && \
qiime taxa filter-table \
  --i-table feature-frequency-filtered-table.qza \
  --i-taxonomy Zotu_taxonomy0.8.qza \
  --p-include Bacteria,Archaea \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-table filtered.OTU.table.qza && \
qiime feature-table summarize --i-table filtered.OTU.table.qza --o-visualization filtered.OTU.table.qzv

