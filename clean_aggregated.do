use "input/trade_data_aggregated/trade-data-aggregated.dta", clear

destring year, replace

save "temp/aggregated-clean.dta", replace
