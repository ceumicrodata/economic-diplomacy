
keep year $log_vars $level_vars $dummy_vars $index_vars

foreach X of var $log_vars {
	generate ln_`X' = ln(`X')
}

* convert Kullback-Leibler divergence to Trade Similarity Index with theta
* see https://github.com/ceumicrodata/respect-trade-similarity/blob/3c03231a8d0392609a8a375378d5a29d37cd7736/prepare.py#L32

scalar theta = 8
generate trade_similarity = exp(-1/theta * tci_)

foreach X of var $index_vars {
	egen `X'_year = group(`X' year)
}

* convert GDELT variables, add visits, diplomatic events and cooperation
generate intent = (Events31) if !missing(Events31)
generate visits = (Events41 + Events51 + Events61) if !missing(Events41,Events51,Events61)
