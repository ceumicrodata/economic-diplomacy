unab dummies : *_year

* gravity model without FE, with trade_similarity, with FE, with political variables
reghdfe ln_good_total ln_distw ln_gdp*, noabsorb cluster($index_vars)
reghdfe ln_good_total p ln_distw ln_gdp*, noabsorb cluster($index_vars)
reghdfe ln_good_total p ln_distw ln_gdp* $dummy_vars, a(`dummies') cluster($index_vars)
reghdfe ln_good_total p ln_distw ln_gdp*  $dummy_vars ln_dem_diff agree, a(`dummies') cluster($index_vars)

* kldexp and p
reghdfe p kldexp ln_gdp*, noabsorb cluster($index_vars)
reghdfe p kldexp ln_gdp*, a(`dummies') cluster($index_vars)

* gravity model on p
reghdfe p ln_distw ln_gdp*, noabsorb cluster($index_vars)
reghdfe p ln_distw ln_gdp*, a(`dummies') cluster($index_vars)

* gravity model without p without FE without political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' ln_good_total ln_distw ln_gdp* if $`sample', noabsorb cluster($index_vars)
	}
}

* gravity model with p without FE without political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* if $`sample', noabsorb cluster($index_vars)
	}
}

* gravity model with p with FE without political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars if $`sample', a(`dummies') cluster($index_vars)
	}
}

* gravity model with p with FE with political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		eststo: ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff if $`sample', a(`dummies') cluster($index_vars)
	}
}

coefplot (est1, label("All - intent")) (est2, label("All - visits")), keep(p) xline(0, lcolor(black)) levels(90)
graph export "output/coefficients.png", replace
eststo clear

* using lagged p (4)
egen iso3_od_num = group($index_vars)
xtset iso3_od_num year
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' p l1.trade_similarity_exp l2.trade_similarity_exp ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff if $`sample', a($index_vars) cluster($index_vars)
	}
}
