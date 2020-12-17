unab dummies : *_year

rename intent_events_exporter intent
rename visits_events_exporter visits

* gravity model with p without FE without political variables (8)
foreach sample in all neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p_inv ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', noabsorb cluster($index_vars)
		estimates store `sample'_`var'_1
	}
}

* gravity model with p without FE with political variables (8)
foreach sample in all neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p_inv ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree ln_dem_diff if $`sample', noabsorb cluster($index_vars)
			estimates store `sample'_`var'_2
	}
}

* gravity model with p with FE without political variables (8)
foreach sample in all neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p_inv ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_3
	}
}

* gravity model with p with FE with political variables (8)
foreach sample in all neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p_inv ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree ln_dem_diff if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_4
	}
}

coefplot all_intent_1 all_intent_2 all_intent_3 all_intent_4, bylabel("All countries - intent") || eu_intent_1 eu_intent_2 eu_intent_3 eu_intent_4, bylabel("EU countries - intent") || neighbor_intent_1 neighbor_intent_2 neighbor_intent_3 neighbor_intent_4, bylabel("Neighboorhood countries - intent") || other_intent_1 other_intent_2 other_intent_3 other_intent_4, bylabel("Other countries - intent") || all_visits_1 all_visits_2 all_visits_3 all_visits_4, bylabel("All countries - visits") || eu_visits_1 eu_visits_2 eu_visits_3 eu_visits_4, bylabel("EU countries - visits") || neighbor_visits_1 neighbor_visits_2 neighbor_visits_3 neighbor_visits_4, bylabel("Neighboorhood countries - visits") || other_visits_1 other_visits_2 other_visits_3 other_visits_4, bylabel("Other countries - visits") ||, keep(p_inv) xline(0, lcolor(black)) levels(90) bgcol(white) plotlabels("Without FE" "Without FE with political" "With FE without political" "With FE with political") byopts(note("Coefficients of variable p on intent and visits. Points represent point estimates, lines represent 90% confidence intervals." "Samples named in the title." "Different colors represent different model specifications.", size(vsmall)) title("Investment"))
graph export "output/coefficients_investment.png", replace

eststo clear

