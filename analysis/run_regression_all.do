unab dummies : *_year

* for the coefplots, otherwise should be *-d
rename intent_events_exporter intent
rename visits_events_exporter visits

* gravity model without p without FE without political variables (4)
foreach var of varlist $outcomes_simple {
	ppmlhdfe `var' ln_distw ln_gdp* ln_good_total, noabsorb cluster($index_vars)
	estimates store gravity_`var'
}

* gravity model with p without FE without political variables (8)
foreach sample in all eu neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p p_inv ln_good_total num_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', noabsorb cluster($index_vars)
		estimates store `sample'_`var'_both_1
	}
}

* gravity model with p without FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p p_inv ln_good_total num_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample', noabsorb cluster($index_vars)
			estimates store `sample'_`var'_both_2
	}
}

* gravity model with p with FE without political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p p_inv ln_good_total num_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_both_3
	}
}

* gravity model with p with FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p p_inv ln_good_total num_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_both_4
	}
}

* gravity model with p without FE with political variables - only large shipments (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p p_inv ln_good_total num_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample' & shipments_large, noabsorb cluster($index_vars)
			estimates store `sample'_`var'_both_5
	}
}

*coefplot (est1, label("All - intent")) (est2, label("All - visits")), keep(p) xline(0, lcolor(black)) levels(90)
*ssc install grstyle
*ssc install palettes
*set scheme s2color
*grstyle init
*grstyle color background white // set overall background to white

coefplot all_intent_both_1 all_intent_both_2 all_intent_both_3 all_intent_both_4, bylabel("All countries") || eu_intent_both_1 eu_intent_both_2 eu_intent_both_3 eu_intent_both_4, bylabel("EU countries") || neighbor_intent_both_1 neighbor_intent_both_2 neighbor_intent_both_3 neighbor_intent_both_4, bylabel("Neighboorhood countries") || (other_intent_both_1, mcolor(green) ciopts(color(green))) (other_intent_both_2, mcolor(red) ciopts(color(red))) (other_intent_both_3, mcolor(blue) ciopts(color(blue))) (other_intent_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p p_inv) coeflabel(p = "trade" p_inv = "investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white))
graph export "output/coefficients_intent_both_all.png", replace

coefplot all_visits_both_1 all_visits_both_2 all_visits_both_3 all_visits_both_4, bylabel("All countries") || eu_visits_both_1 eu_visits_both_2 eu_visits_both_3 eu_visits_both_4, bylabel("EU countries") || neighbor_visits_both_1 neighbor_visits_both_2 neighbor_visits_both_3 neighbor_visits_both_4, bylabel("Neighboorhood countries") || (other_visits_both_1, mcolor(green) ciopts(color(green))) (other_visits_both_2, mcolor(red) ciopts(color(red))) (other_visits_both_3, mcolor(blue) ciopts(color(blue))) (other_visits_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p p_inv) coeflabel(p = "p_trade" p_inv = "p_investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white))
graph export "output/coefficients_visits_both_all.png", replace

coefplot all_intent_both_1 all_intent_both_2 all_intent_both_3 all_intent_both_4, bylabel("All countries") || eu_intent_both_1 eu_intent_both_2 eu_intent_both_3 eu_intent_both_4, bylabel("EU countries") || neighbor_intent_both_1 neighbor_intent_both_2 neighbor_intent_both_3 neighbor_intent_both_4, bylabel("Neighboorhood countries") || (other_intent_both_1, mcolor(green) ciopts(color(green))) (other_intent_both_2, mcolor(red) ciopts(color(red))) (other_intent_both_3, mcolor(blue) ciopts(color(blue))) (other_intent_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p) coeflabel(p = "trade") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white))
graph export "output/coefficients_intent_both_trade.png", replace

coefplot all_visits_both_1 all_visits_both_2 all_visits_both_3 all_visits_both_4, bylabel("All countries") || eu_visits_both_1 eu_visits_both_2 eu_visits_both_3 eu_visits_both_4, bylabel("EU countries") || neighbor_visits_both_1 neighbor_visits_both_2 neighbor_visits_both_3 neighbor_visits_both_4, bylabel("Neighboorhood countries") || (other_visits_both_1, mcolor(green) ciopts(color(green))) (other_visits_both_2, mcolor(red) ciopts(color(red))) (other_visits_both_3, mcolor(blue) ciopts(color(blue))) (other_visits_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p) coeflabel(p = "p_trade") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white))
graph export "output/coefficients_visits_both_trade.png", replace

coefplot all_intent_both_1 all_intent_both_2 all_intent_both_3 all_intent_both_4, bylabel("All countries") || eu_intent_both_1 eu_intent_both_2 eu_intent_both_3 eu_intent_both_4, bylabel("EU countries") || neighbor_intent_both_1 neighbor_intent_both_2 neighbor_intent_both_3 neighbor_intent_both_4, bylabel("Neighboorhood countries") || (other_intent_both_1, mcolor(green) ciopts(color(green))) (other_intent_both_2, mcolor(red) ciopts(color(red))) (other_intent_both_3, mcolor(blue) ciopts(color(blue))) (other_intent_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p_inv) coeflabel(p_inv = "investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white))
graph export "output/coefficients_intent_both_inv.png", replace

coefplot all_visits_both_1 all_visits_both_2 all_visits_both_3 all_visits_both_4, bylabel("All countries") || eu_visits_both_1 eu_visits_both_2 eu_visits_both_3 eu_visits_both_4, bylabel("EU countries") || neighbor_visits_both_1 neighbor_visits_both_2 neighbor_visits_both_3 neighbor_visits_both_4, bylabel("Neighboorhood countries") || (other_visits_both_1, mcolor(green) ciopts(color(green))) (other_visits_both_2, mcolor(red) ciopts(color(red))) (other_visits_both_3, mcolor(blue) ciopts(color(blue))) (other_visits_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p_inv) coeflabel(p_inv = "p_investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white))
graph export "output/coefficients_visits_both_inv.png", replace

estimates clear
