objects = output/analysis-sample.dta temp/qog-clean.dta temp/gdelt-clean.dta temp/geodist-clean.dta temp/aggregated-clean.dta temp/trade-similarity-clean.dta temp/eu-related-countries.csv

all: $(objects)

output/analysis-sample.dta: merge.do temp/qog-clean.dta temp/gdelt-clean.dta temp/geodist-clean.dta temp/aggregated-clean.dta temp/trade-similarity-clean.dta input/un/un.dta
	stata -b do $<
temp/qog-clean.dta: clean_qog.do input/qog/qog-basic.dta
	stata -b do $<
temp/gdelt-clean.dta: clean_gdelt.do input/GDELT/gov2gov-events-by-month.dta
	stata -b do $<
temp/geodist-clean.dta: clean_geodist.do input/cepii-geodist/geodist.dta
	stata -b do $<
temp/aggregated-clean.dta: clean_aggregated.do input/trade_data_aggregated/trade-data-aggregated.dta
	stata -b do $<
temp/trade-similarity-clean.dta: clean_tsi.do input/respect-trade-similarity/TC_INDEX_EXP_.csv
	stata -b do $<
temp/eu-related-countries.csv: 
	wget -O $@ https://raw.githubusercontent.com/ceumicrodata/gov2gov-cooperation/master/externals/eurostat/eu-related-countries.csv
