unab dummies : *_year

*gravity model without FE, with trade_similarity, with FE, with political variables
reghdfe ln_good_total ln_distw ln_gdp*, noabsorb cluster($index_vars)
reghdfe ln_good_total trade_similarity ln_distw ln_gdp*, noabsorb cluster($index_vars)
reghdfe ln_good_total trade_similarity ln_distw ln_gdp* $dummy_vars, a(`dummies') cluster($index_vars)
reghdfe ln_good_total trade_similarity ln_distw ln_gdp*  $dummy_vars ln_dem_diff agree, a(`dummies') cluster($index_vars)

*reghdfe trade_similarity ln_distw ln_dem_diff agree $dummy_vars, a(`dummies') cluster($index_vars)
reghdfe trade_similarity ln_distw ln_gdp*, noabsorb cluster($index_vars)
reghdfe trade_similarity ln_distw ln_gdp*, a(`dummies') cluster($index_vars)

*gravity model without trade_similarity without FE without political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' ln_good_total ln_distw ln_gdp* if $`sample', noabsorb cluster($index_vars)
	}
}

*gravity model with trade_similarity without FE without political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' trade_similarity ln_good_total ln_distw ln_gdp* if $`sample', noabsorb cluster($index_vars)
	}
}

*gravity model with trade_similarity with FE without political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' trade_similarity ln_good_total ln_distw ln_gdp* $dummy_vars if $`sample', a(`dummies') cluster($index_vars)
	}
}

*gravity model with trade_similarity with FE with political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		eststo: ppmlhdfe `var' trade_similarity ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff if $`sample', a(`dummies') cluster($index_vars)
	}
}
estout using "output/results.txt", keep(trade_similarity) cells(b se) replace
eststo clear

*using lagged trade_similarity (4)
egen iso3_od_num = group($index_vars)
xtset iso3_od_num year
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' trade_similarity l1.trade_similarity l2.trade_similarity ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff if $`sample', a($index_vars) cluster($index_vars)
	}
}

*regressions in different years (only eu_neighbor) (6)
forval i = 2015(1)2017 {
	foreach var of varlist $outcomes_events {
		ppmlhdfe `var' trade_similarity ln_good_total ln_distw ln_gdp* $dummy_vars ln_dem_diff ln_agree if $eu_neighbor & year == `i', a($index_vars) cluster($index_vars)
	}
}

*po-diff added - only EU data (2)
foreach var of varlist $outcomes_events {
	ppmlhdfe `var' trade_similarity ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff ln_po_diff, a(`dummies') cluster($index_vars)
}

*different estimation methods without FE (16)
*egen iso3_od_num = group($index_vars)
*xtset iso3_od_num year
*foreach var of varlist $outcomes {
*	reg `var' trade_similarity ln_distw ln_dem_diff ln_agree $dummy_vars if $eu_neighbor
*	reg `var' trade_similarity ln_distw ln_dem_diff ln_agree i.year $dummy_vars if $eu_neighbor
*	reg `var' trade_similarity ln_distw ln_dem_diff ln_agree i.year $dummy_vars if $eu_neighbor, cluster(iso3_od_num)
*	xtpcse `var' trade_similarity ln_distw ln_dem_diff ln_agree i.year $dummy_vars if $eu_neighbor
*}

*foreach var in intent_events_exporter visits_events_exporter intent_mentions_exporter visits_mentions_exporter {
*	ppmlhdfe `var' trade_similarity ln_distw ln_dem_diff ln_agree i.year $dummy_vars, a($index_vars) cluster($index_vars)
*}
