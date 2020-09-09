unab dummies : *_year

*reghdfe ln_good_total ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
*reghdfe ln_good_total trade_similarity ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
*reghdfe ln_good_total trade_similarity ln_distw ln_dem_diff agree $dummy_vars, a(`dummies') cluster($index_vars)

*reghdfe trade_similarity ln_distw ln_dem_diff agree $dummy_vars, a(`dummies') cluster($index_vars)
*ppmlhdfe trade_similarity ln_distw ln_dem_diff agree $dummy_vars, a(`dummies') cluster($index_vars)

*regressions on different samples (12)
foreach sample in all eu_neighbor eu_eu {
	foreach var of varlist $outcomes {
		ppmlhdfe `var' trade_similarity ln_distw ln_dem_diff ln_agree $dummy_vars if $`sample', a(`dummies') cluster($index_vars)
	}
}

*regressions in different years (only eu_neighbor) (12)
forval i = 2015(1)2017 {
	foreach var of varlist $outcomes {
		ppmlhdfe `var' trade_similarity ln_distw ln_dem_diff ln_agree $dummy_vars if $eu_neighbor & year == `i', a($index_vars) cluster($index_vars)
	}
}

*different estimation methods without FE (16)
egen iso3_od_num = group($index_vars)
xtset iso3_od_num year
foreach var of varlist $outcomes {
	reg `var' trade_similarity ln_distw ln_dem_diff ln_agree $dummy_vars if $eu_neighbor
	reg `var' trade_similarity ln_distw ln_dem_diff ln_agree i.year $dummy_vars if $eu_neighbor
	reg `var' trade_similarity ln_distw ln_dem_diff ln_agree i.year $dummy_vars if $eu_neighbor, cluster(iso3_od_num)
	xtpcse `var' trade_similarity ln_distw ln_dem_diff ln_agree i.year $dummy_vars if $eu_neighbor
}

*foreach var in intent_events_exporter visits_events_exporter intent_mentions_exporter visits_mentions_exporter {
*	ppmlhdfe `var' trade_similarity ln_distw ln_dem_diff ln_agree i.year $dummy_vars, a($index_vars) cluster($index_vars)
*}
