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
*foreach sample in all eu_neighbor eu_eu eu_other {
*	foreach var of varlist $outcomes_events {
*		ppmlhdfe `var' ln_good_total ln_distw ln_gdp* if $`sample', noabsorb cluster($index_vars)
*	}
*}

* for the coefplots, otherwise should be *-d
rename intent_events_exporter intent
rename visits_events_exporter visits

* gravity model with p without FE without political variables (8)
foreach sample in all eu neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu if $`sample', noabsorb cluster($index_vars)
		estimates store `sample'_`var'_1
	}
}

* gravity model with p without FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu ln_agree ln_dem_diff if $`sample', noabsorb cluster($index_vars)
			estimates store `sample'_`var'_2
	}
}

* gravity model with p with FE without political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_3
	}
}

* gravity model with p with FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu ln_agree ln_dem_diff if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_4
	}
}

* gravity model with p without FE with political variables - only large shipments (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu ln_agree ln_dem_diff if $`sample' & shipments_large, noabsorb cluster($index_vars)
			estimates store `sample'_`var'_5
	}
}

*coefplot (est1, label("All - intent")) (est2, label("All - visits")), keep(p) xline(0, lcolor(black)) levels(90)
*coefplot all_intent_1 all_intent_2 all_intent_3 all_intent_4, bylabel("All countries - intent") || eu_intent_1 eu_intent_2 eu_intent_3 eu_intent_4, bylabel("EU countries - intent") || neighbor_intent_1 neighbor_intent_2 neighbor_intent_3 neighbor_intent_4, bylabel("Neighboorhood countries - intent") || other_intent_1 other_intent_2 other_intent_3 other_intent_4, bylabel("Other countries - intent") || all_visits_1 all_visits_2 all_visits_3 all_visits_4, bylabel("All countries - visits") || eu_visits_1 eu_visits_2 eu_visits_3 eu_visits_4, bylabel("EU countries - visits") || neighbor_visits_1 neighbor_visits_2 neighbor_visits_3 neighbor_visits_4, bylabel("Neighboorhood countries - visits") || other_visits_1 other_visits_2 other_visits_3 other_visits_4, bylabel("Other countries - visits") ||, keep(p) xline(0, lcolor(black)) levels(90) bgcol(white) plotlabels("Without FE" "Without FE with political" "With FE without political" "With FE with political")
*graph export "output/coefficients.png", replace

eststo clear
