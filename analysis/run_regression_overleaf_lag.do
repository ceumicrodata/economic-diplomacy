unab dummies : *_year

* for the coefplots, otherwise should be *-d
rename intent_events_exporter intent
rename visits_events_exporter visits

egen iso3_od_num = group($index_vars)
xtset iso3_od_num year
* gravity model with p without FE without political variables (8)
foreach sample in all eu neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p p_inv l1.p l1.p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', noabsorb cluster($index_vars)
		estimates store `sample'_`var'_both_1
	}
}

* gravity model with p without FE with political variables (8)
foreach sample in all eu neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p p_inv l1.p l1.p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample', noabsorb cluster($index_vars)
		estimates store `sample'_`var'_both_2
	}
}

* gravity model with p with FE without political variables (8)
foreach sample in all eu neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p p_inv l1.p l1.p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', a(`dummies') cluster($index_vars)
		estimates store `sample'_`var'_both_3
	}
}

* gravity model with p with FE with political variables (8)
foreach sample in all eu neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p p_inv l1.p l1.p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample', a(`dummies') cluster($index_vars)
		estimates store `sample'_`var'_both_4
	}
}

coefplot all_intent_both_1 all_intent_both_2 all_intent_both_3 all_intent_both_4, bylabel("All countries") || eu_intent_both_1 eu_intent_both_2 eu_intent_both_3 eu_intent_both_4, bylabel("EU countries") || neighbor_intent_both_1 neighbor_intent_both_2 neighbor_intent_both_3 neighbor_intent_both_4, bylabel("Neighboorhood countries") || (other_intent_both_1, mcolor(green) ciopts(color(green))) (other_intent_both_2, mcolor(red) ciopts(color(red))) (other_intent_both_3, mcolor(blue) ciopts(color(blue))) (other_intent_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p p_inv L.p L.p_inv) coeflabel(p = "Trade" p_inv = "Investment" L.p = "Trade(-1)" L.p_inv = "Investment(-1)") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(`i') xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white) title("Intent", color(black)))
graph export "output/lag_intent_both_all.png", replace

coefplot all_visits_both_1 all_visits_both_2 all_visits_both_3 all_visits_both_4, bylabel("All countries") || eu_visits_both_1 eu_visits_both_2 eu_visits_both_3 eu_visits_both_4, bylabel("EU countries") || neighbor_visits_both_1 neighbor_visits_both_2 neighbor_visits_both_3 neighbor_visits_both_4, bylabel("Neighboorhood countries") || (other_visits_both_1, mcolor(green) ciopts(color(green))) (other_visits_both_2, mcolor(red) ciopts(color(red))) (other_visits_both_3, mcolor(blue) ciopts(color(blue))) (other_visits_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p p_inv L.p L.p_inv) coeflabel(p = "Trade" p_inv = "Investment" L.p = "Trade(-1)" L.p_inv = "Investment(-1)") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(`i') xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white) title("Visits", color(black)))
graph export "output/lag_visits_both_all.png", replace

coefplot all_intent_both_1 all_intent_both_2, bylabel("All countries") || eu_intent_both_1 eu_intent_both_2, bylabel("EU countries") || neighbor_intent_both_1 neighbor_intent_both_2, bylabel("Neighboorhood countries") || (other_intent_both_1, mcolor(green) ciopts(color(green))) (other_intent_both_2, mcolor(red) ciopts(color(red))), bylabel("Other countries") ||, keep(p p_inv L.p L.p_inv) coeflabel(p = "Trade" p_inv = "Investment" L.p = "Trade(-1)" L.p_inv = "Investment(-1)") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(`i') xscale(range(-2 1)) plotlabels("Without political" "With political") byopts(graphregion(col(white)) bgcol(white) title("Intent - without FE", color(black)))
graph export "output/lag__intent_both_all_wofe.png", replace

coefplot all_visits_both_1 all_visits_both_2, bylabel("All countries") || eu_visits_both_1 eu_visits_both_2, bylabel("EU countries") || neighbor_visits_both_1 neighbor_visits_both_2, bylabel("Neighboorhood countries") || (other_visits_both_1, mcolor(green) ciopts(color(green))) (other_visits_both_2, mcolor(red) ciopts(color(red))), bylabel("Other countries") ||, keep(p p_inv L.p L.p_inv) coeflabel(p = "Trade" p_inv = "Investment" L.p = "Trade(-1)" L.p_inv = "Investment(-1)") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(`i') xscale(range(-2 1)) plotlabels("Without political" "With political") byopts(graphregion(col(white)) bgcol(white) title("Visits - without FE", color(black)))
graph export "output/lag__visits_both_all_wofe.png", replace

coefplot all_intent_both_3 all_intent_both_4, bylabel("All countries") || eu_intent_both_3 eu_intent_both_4, bylabel("EU countries") || neighbor_intent_both_3 neighbor_intent_both_4, bylabel("Neighboorhood countries") || (other_intent_both_3, mcolor(green) ciopts(color(green))) (other_intent_both_4, mcolor(red) ciopts(color(red))), bylabel("Other countries") ||, keep(p p_inv L.p L.p_inv) coeflabel(p = "Trade" p_inv = "Investment" L.p = "Trade(-1)" L.p_inv = "Investment(-1)") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(`i') xscale(range(-2 1)) plotlabels("Without political" "With political") byopts(graphregion(col(white)) bgcol(white) title("Intent - with FE", color(black)))
graph export "output/lag__intent_both_all_fe.png", replace

coefplot all_visits_both_3 all_visits_both_4, bylabel("All countries") || eu_visits_both_3 eu_visits_both_4, bylabel("EU countries") || neighbor_visits_both_3 neighbor_visits_both_4, bylabel("Neighboorhood countries") || (other_visits_both_3, mcolor(green) ciopts(color(green))) (other_visits_both_4, mcolor(red) ciopts(color(red))), bylabel("Other countries") ||, keep(p p_inv L.p L.p_inv) coeflabel(p = "Trade" p_inv = "Investment" L.p = "Trade(-1)" L.p_inv = "Investment(-1)") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(`i') xscale(range(-2 1)) plotlabels("Without political" "With political") byopts(graphregion(col(white)) bgcol(white) title("Visits - with FE", color(black)))
graph export "output/lag__visits_both_all_fe.png", replace

estimates clear
