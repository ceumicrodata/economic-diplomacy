include local_settings.mk
all: output/results_po.tex

temp/p-values-trade.csv: temp/shipment-clean.csv analysis/KLD.jl
	cd analysis/ && $(JULIA) KLD.jl ../$< ../$@
data/external/p-values-%.csv: data/external/%.csv analysis/KLD.jl
	cd analysis/ && $(JULIA) KLD.jl ../$< ../$@
output/results_po.tex: analysis/master.do analysis/create_variables.do analysis/run_regression.do analysis/run_regression_slides.do output/analysis-sample.dta
	stata -b do $<
output/analysis-sample.dta: merge.do temp/po-clean.dta temp/gdp-clean.dta temp/qog-clean.dta temp/gdelt-clean.dta temp/geodist-clean.dta temp/aggregated-clean.dta temp/tsi-clean.dta input/un/un.dta
	stata -b do $<
temp/po-clean.dta: clean_po.do input/public-opinion/ebs_491.xls
	stata -b do $<
temp/gdp-clean.dta: clean_gdp.do input/gdp/gdp.xls
	stata -b do $<
temp/qog-clean.dta: clean_qog.do input/qog/qog-basic.dta
	stata -b do $<
temp/gdelt-clean.dta: clean_gdelt.do input/GDELT/gov2gov-events-by-month.dta
	stata -b do $<
temp/geodist-clean.dta: clean_geodist.do input/cepii-geodist/geodist.dta
	stata -b do $<
temp/aggregated-clean.dta: clean_aggregated.do input/trade_data_aggregated/trade-data-aggregated.dta
	stata -b do $<
temp/tsi-clean.dta: clean_kld.do input/respect-trade-similarity/KLD*.csv
	stata -b do $<
temp/eu-related-countries.csv: 
	wget -O $@ https://raw.githubusercontent.com/ceumicrodata/gov2gov-cooperation/master/externals/eurostat/eu-related-countries.csv
