
cap keep year $log_vars $log_vars_single $level_vars $dummy_vars $index_vars $index_vars_iso2

foreach X of var $log_vars $log_vars_single {
	generate ln_`X' = ln(`X')
}

* convert Kullback-Leibler divergence to Trade Similarity Index with theta
* see https://github.com/ceumicrodata/respect-trade-similarity/blob/3c03231a8d0392609a8a375378d5a29d37cd7736/prepare.py#L32

scalar theta = 8
*generate trade_similarity = exp(-1/theta * tci_)
generate trade_similarity_exp = exp(-kldexp)
generate trade_similarity_imp = exp(-kldimp)

foreach X of var $index_vars {
	egen `X'_year = group(`X' year)
}

* only use exporter with EU to destinations among neighborhood and other sample countries
*keep if eu_relation_exporter == "EU" & eu_relation_importer != "EU"  & !missing(eu_relation_importer)
