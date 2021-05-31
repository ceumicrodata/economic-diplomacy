include local_settings.mk
INVPROJECTS = $(wildcard data/investment/*.csv)
all: output/results_append.tex

investment: $(foreach f,$(INVPROJECTS),output/investment/$(notdir $f))
test: output/test.csv
spain: output/spain-KLD.csv output/spain-SAD.csv output/spain-SSD.csv output/spain-MLQ.csv

output/spain-%.csv: input/spanish-trade-count/aggregated_product.csv analysis/simulate_polya_stat.jl
	cd analysis/ && $(JULIA) simulate_polya_stat.jl --index region_o --statistic $* ../$< ../$@
output/test.csv: analysis/test.csv analysis/KLD.jl
	cd analysis/ && julia --project=. KLD.jl --index origin,destination --by destination ../$< ../$@
output/investment/%.csv: data/investment/%.csv analysis/KLD.jl
	cd analysis/ && $(JULIA) KLD.jl ../$< ../$@
output/results_append.tex: analysis/master.do analysis/create_variables.do analysis/run_regression_p.do analysis/graph_p.do output/analysis-sample.dta temp/eu-related-countries.csv output/trade/polya-index.csv
	stata -b do $<
output/analysis-sample.dta: merge.do temp/po-clean.dta temp/gdp-clean.dta temp/qog-clean.dta temp/gdelt-clean.dta temp/geodist-clean.dta temp/aggregated-clean.dta temp/kld-clean.dta input/un/un.dta output/trade/polya-index.csv
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
temp/kld-clean.dta: clean_kld.do input/respect-trade-similarity/KLD*.csv
	stata -b do $<
temp/eu-related-countries.csv: 
	wget -O $@ https://raw.githubusercontent.com/ceumicrodata/gov2gov-cooperation/master/externals/eurostat/eu-related-countries.csv
