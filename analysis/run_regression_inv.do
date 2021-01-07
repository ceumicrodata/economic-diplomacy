unab dummies : *_year

rename intent_events_exporter intent
rename visits_events_exporter visits

* gravity model with p without FE without political variables (8)
foreach sample in all eu neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', noabsorb cluster($index_vars)
		estimates store `sample'_`var'_inv_1
	}
}

* gravity model with p without FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample', noabsorb cluster($index_vars)
			estimates store `sample'_`var'_inv_2
	}
}

* gravity model with p with FE without political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_inv_3
	}
}

* gravity model with p with FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_inv_4
	}
}

*coefplot all_intent_1 all_intent_2 all_intent_3 all_intent_4, bylabel("All countries - intent") || neighbor_intent_1 neighbor_intent_2 neighbor_intent_3 neighbor_intent_4, bylabel("Neighboorhood countries - intent") || other_intent_1 other_intent_2 other_intent_3 other_intent_4, bylabel("Other countries - intent") || all_visits_1 all_visits_2 all_visits_3 all_visits_4, bylabel("All countries - visits") || neighbor_visits_1 neighbor_visits_2 neighbor_visits_3 neighbor_visits_4, bylabel("Neighboorhood countries - visits") || other_visits_1 other_visits_2 other_visits_3 other_visits_4, bylabel("Other countries - visits") ||, keep(p_inv) xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white))  levels(90) bgcol(white) plotlabels("Without FE" "Without FE with political" "With FE without political" "With FE with political") byopts(note("Coefficients of variable p on intent and visits. Points represent point estimates, lines represent 90% confidence intervals." "Samples named in the title." "Different colors represent different model specifications.", size(vsmall)) title("Investment", color(black)))
*graph export "output/coefficients_investment.png", replace

coefplot all_intent_inv_1 all_intent_inv_2 all_intent_inv_3 all_intent_inv_4, bylabel("All countries") || eu_intent_inv_1 eu_intent_inv_2 eu_intent_inv_3 eu_intent_inv_4, bylabel("EU countries") ||neighbor_intent_inv_1 neighbor_intent_inv_2 neighbor_intent_inv_3 neighbor_intent_inv_4, bylabel("Neighboorhood countries") || (other_intent_inv_1, mcolor(green) ciopts(color(green))) (other_intent_inv_2, mcolor(red) ciopts(color(red))) (other_intent_inv_3, mcolor(blue) ciopts(color(blue))) (other_intent_inv_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p_inv) coeflabel(p_inv = "investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white))
graph export "output/coefficients_inv_intent.png", replace

coefplot all_visits_inv_1 all_visits_inv_2 all_visits_inv_3 all_visits_inv_4, bylabel("All countries") || eu_visits_inv_1 eu_visits_inv_2 eu_visits_inv_3 eu_visits_inv_4, bylabel("EU countries") || neighbor_visits_inv_1 neighbor_visits_inv_2 neighbor_visits_inv_3 neighbor_visits_inv_4, bylabel("Neighboorhood countries") || (other_visits_inv_1, mcolor(red) ciopts(color(red))) (other_visits_inv_2, mcolor(green) ciopts(color(green))) (other_visits_inv_3, mcolor(blue) ciopts(color(blue))) (other_visits_inv_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p_inv) coeflabel(p_inv = "investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white))
graph export "output/coefficients_inv_visits.png", replace

estimates clear

