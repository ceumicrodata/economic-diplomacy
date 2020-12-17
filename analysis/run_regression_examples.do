unab dummies : *_year

foreach country in AO RU TR {
	* gravity model with p without iso2_o level FE (2)
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff if iso2_d == "`country'", noabsorb cluster(iso2_o)
	}

	* gravity model with p with iso2_o level FE (2)
	*foreach var of varlist $outcomes_events {
	*	ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff if iso2_d == "`country'", absorb(iso2_o) cluster(iso2_o)
	*}
}
