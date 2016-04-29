
RCOMMON=cleandata.R
SHARED_DATA=sheet_experiments.csv \
			sheet_datasets.csv

sheet_experiments.csv:
	./download_sheets.sh ${DOCID}

sheet_datasets.csv:
	./download_sheets.sh ${DOCID}

runtime_vs_ntuples.pdf: runtime_vs_ntuples.R $(RCOMMON) ${SHARED_DATA}
	Rscript $<

compare_runtimes.pdf: compare_runtimes.R $(RCOMMON) ${SHARED_DATA}
	Rscript $<
