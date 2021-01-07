unab dummies : *_year

* gravity model on p
reghdfe p ln_distw ln_gdp*, noabsorb cluster($index_vars)
estimates store p_gravity_wotrade
reghdfe p ln_distw ln_gdp* ln_good_total, noabsorb cluster($index_vars)
estimates store p_gravity_wtrade
*reghdfe p ln_distw ln_gdp*, a(`dummies') cluster($index_vars)

* for the coefplots, otherwise should be *-d
rename intent_events_exporter intent
rename visits_events_exporter visits

twoway (histogram intent, color(green%30)) (histogram visits, color(red%30)) if intent <= 300 & visits <= 300, legend(order(1 "intent" 2 "visits" )) graphregion(color(white)) ytitle("") xtitle("number of events")
graph export "output/hist_dependent_after.png", replace

* gravity model without p without FE without political variables (4)
foreach var of varlist $outcomes_simple {
	ppmlhdfe `var' ln_distw ln_gdp* ln_good_total, noabsorb cluster($index_vars)
	estimates store gravity_`var'
}

* gravity model with p without FE without political variables (8)
foreach sample in all eu neighbor other {
	foreach var of varlist $outcomes_simple {
		ppmlhdfe `var' p p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', noabsorb cluster($index_vars)
		estimates store `sample'_`var'_both_1
	}
}

* gravity model with p without FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample', noabsorb cluster($index_vars)
			estimates store `sample'_`var'_both_2
	}
}

* gravity model with p with FE without political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_both_3
	}
}

* gravity model with p with FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p p_inv ln_good_total ln_tot_inv ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree dem_diff if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_both_4
	}
}

coefplot all_intent_both_1 all_intent_both_2 all_intent_both_3 all_intent_both_4, bylabel("All countries") || eu_intent_both_1 eu_intent_both_2 eu_intent_both_3 eu_intent_both_4, bylabel("EU countries") || neighbor_intent_both_1 neighbor_intent_both_2 neighbor_intent_both_3 neighbor_intent_both_4, bylabel("Neighboorhood countries") || (other_intent_both_1, mcolor(green) ciopts(color(green))) (other_intent_both_2, mcolor(red) ciopts(color(red))) (other_intent_both_3, mcolor(blue) ciopts(color(blue))) (other_intent_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p p_inv) coeflabel(p = "Trade" p_inv = "Investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white) title("Intent", color(black)))
graph export "output/coefficients_intent_both_all.png", replace

coefplot all_visits_both_1 all_visits_both_2 all_visits_both_3 all_visits_both_4, bylabel("All countries") || eu_visits_both_1 eu_visits_both_2 eu_visits_both_3 eu_visits_both_4, bylabel("EU countries") || neighbor_visits_both_1 neighbor_visits_both_2 neighbor_visits_both_3 neighbor_visits_both_4, bylabel("Neighboorhood countries") || (other_visits_both_1, mcolor(green) ciopts(color(green))) (other_visits_both_2, mcolor(red) ciopts(color(red))) (other_visits_both_3, mcolor(blue) ciopts(color(blue))) (other_visits_both_4, mcolor(orange) ciopts(color(orange))), bylabel("Other countries") ||, keep(p p_inv) coeflabel(p = "Trade" p_inv = "Investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without FE without political" "Without FE with political" "With FE without political" "With FE with political") byopts(graphregion(col(white)) bgcol(white) title("Visits", color(black)))
graph export "output/coefficients_visits_both_all.png", replace

coefplot all_intent_both_1 all_intent_both_2, bylabel("All countries") || eu_intent_both_1 eu_intent_both_2, bylabel("EU countries") || neighbor_intent_both_1 neighbor_intent_both_2, bylabel("Neighboorhood countries") || (other_intent_both_1, mcolor(green) ciopts(color(green))) (other_intent_both_2, mcolor(red) ciopts(color(red))), bylabel("Other countries") ||, keep(p p_inv) coeflabel(p = "Trade" p_inv = "Investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without political" "With political") byopts(graphregion(col(white)) bgcol(white) title("Intent - without FE", color(black)))
graph export "output/coefficients_intent_both_all_wofe.png", replace

coefplot all_visits_both_1 all_visits_both_2, bylabel("All countries") || eu_visits_both_1 eu_visits_both_2, bylabel("EU countries") || neighbor_visits_both_1 neighbor_visits_both_2, bylabel("Neighboorhood countries") || (other_visits_both_1, mcolor(green) ciopts(color(green))) (other_visits_both_2, mcolor(red) ciopts(color(red))), bylabel("Other countries") ||, keep(p p_inv) coeflabel(p = "Trade" p_inv = "Investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without political" "With political") byopts(graphregion(col(white)) bgcol(white) title("Visits - without FE", color(black)))
graph export "output/coefficients_visits_both_all_wofe.png", replace

coefplot all_intent_both_3 all_intent_both_4, bylabel("All countries") || eu_intent_both_3 eu_intent_both_4, bylabel("EU countries") || neighbor_intent_both_3 neighbor_intent_both_4, bylabel("Neighboorhood countries") || (other_intent_both_3, mcolor(green) ciopts(color(green))) (other_intent_both_4, mcolor(red) ciopts(color(red))), bylabel("Other countries") ||, keep(p p_inv) coeflabel(p = "Trade" p_inv = "Investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without political" "With political") byopts(graphregion(col(white)) bgcol(white) title("Intent - with FE", color(black)))
graph export "output/coefficients_intent_both_all_fe.png", replace

coefplot all_visits_both_3 all_visits_both_4, bylabel("All countries") || eu_visits_both_3 eu_visits_both_4, bylabel("EU countries") || neighbor_visits_both_3 neighbor_visits_both_4, bylabel("Neighboorhood countries") || (other_visits_both_3, mcolor(green) ciopts(color(green))) (other_visits_both_4, mcolor(red) ciopts(color(red))), bylabel("Other countries") ||, keep(p p_inv) coeflabel(p = "Trade" p_inv = "Investment") xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) xscale(range(-2 1)) plotlabels("Without political" "With political") byopts(graphregion(col(white)) bgcol(white) title("Visits - with FE", color(black)))
graph export "output/coefficients_visits_both_all_fe.png", replace

label variable p "p-value (count)"
label variable intent "Intended visits by exporter (count)"
label variable visits "Actual visits by exporter (count)"
label variable intent_events_eu "Mean intended visits by EU countries (count)"
label variable visits_events_eu "Mean actual visits by EU countries (count)"
label variable intent_events_agency "Intended visits by EU institutions (count)"
label variable visits_events_agency "Actual visits by EU institutions (count)"
label variable contig "Contiguity (dummy)"
label variable comlang_off "Common language (dummy)"
label variable colony "Colonial relationship (dummy)" 
label variable comcol "Colonizer (dummy)"
label variable ln_good_total "Trade flow (log)"
label variable ln_distw "Distance (log)"
label variable ln_dem_diff "Difference in democracy level (log)" 
label variable ln_agree "Agreement in UN (log)"
label variable ln_po_diff "Difference in public opinion (log)"
label variable ln_gdp_o "Exporter nominal GDP (log)"
label variable ln_gdp_d "Importer nominal GDP (log)"

esttab p_gravity_wotrade p_gravity_wtrade using "${here}/output/results_gravity_p.tex", replace ///
	label booktabs b(3) p(3) eqlabels(none) collabels("") width(1.0\hsize) compress legend ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	title(Larger, closer countries have more similar trade patterns\label{tab1}) ///
	nonumbers ///
	mlabel("\shortstack{Model 1 \\ without trade flow}" "\shortstack{Model 2 \\ with trade flow}") ///
	addnote("Notes: Linear model is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: all countries.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2, fmt(0 3) labels("Number of observations" "R^{2}"))

esttab gravity_intent gravity_visits using "${here}/output/results_gravity_dependent.tex", replace ///
	label booktabs b(3) p(3) eqlabels(none) collabels("") width(1.0\hsize) compress legend ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	title(The gravity equation holds for measures of economic diplomacy\label{tab2}) ///
	nonumbers ///
	mlabel("\shortstack{Model 1 \\ intent}" "\shortstack{Model 2 \\ visits}") ///
	addnote("Notes: Poisson pseudo-likelihood regression is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: all countries.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_p, fmt(0 3) labels("Number of observations" "Pseudo \(R^{2}\)"))

estimates clear
