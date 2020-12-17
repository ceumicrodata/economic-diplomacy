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
estimates store p_gravity_wotrade
reghdfe p ln_distw ln_gdp* ln_good_total, noabsorb cluster($index_vars)
estimates store p_gravity_wtrade
*reghdfe p ln_distw ln_gdp*, a(`dummies') cluster($index_vars)

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
		ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', noabsorb cluster($index_vars)
		estimates store `sample'_`var'_1
	}
}

* gravity model with p without FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree ln_dem_diff if $`sample', noabsorb cluster($index_vars)
			estimates store `sample'_`var'_2
	}
}

* gravity model with p with FE without political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_3
	}
}

* gravity model with p with FE with political variables (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree ln_dem_diff if $`sample', a(`dummies') cluster($index_vars)
			estimates store `sample'_`var'_4
	}
}

* gravity model with p without FE with political variables - only large shipments (8)
foreach sample in all eu neighbor other {
		foreach var of varlist $outcomes_simple {
			ppmlhdfe `var' p ln_good_total ln_distw ln_gdp* $dummy_vars `var'_events_eu `var'_events_agency ln_agree ln_dem_diff if $`sample' & shipments_large, noabsorb cluster($index_vars)
			estimates store `sample'_`var'_5
	}
}

*coefplot (est1, label("All - intent")) (est2, label("All - visits")), keep(p) xline(0, lcolor(black)) levels(90)
ssc install grstyle
ssc install palettes
set scheme s2color
grstyle init
grstyle color background white // set overall background to white
*grstyle set color black*.04: plotregion color //set plot area background
coefplot all_intent_1 all_intent_2 all_intent_3 all_intent_4, bylabel("All countries - intent") || eu_intent_1 eu_intent_2 eu_intent_3 eu_intent_4, bylabel("EU countries - intent") || neighbor_intent_1 neighbor_intent_2 neighbor_intent_3 neighbor_intent_4, bylabel("Neighboorhood countries - intent") || other_intent_1 other_intent_2 other_intent_3 other_intent_4, bylabel("Other countries - intent") || all_visits_1 all_visits_2 all_visits_3 all_visits_4, bylabel("All countries - visits") || eu_visits_1 eu_visits_2 eu_visits_3 eu_visits_4, bylabel("EU countries - visits") || neighbor_visits_1 neighbor_visits_2 neighbor_visits_3 neighbor_visits_4, bylabel("Neighboorhood countries - visits") || other_visits_1 other_visits_2 other_visits_3 other_visits_4, bylabel("Other countries - visits") ||, keep(p) xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) graphregion(col(white ))bgcol(white) plotlabels("Without FE" "Without FE with political" "With FE without political" "With FE with political") byopts(note("Coefficients of variable p on intent and visits. Points represent point estimates, lines represent 90% confidence intervals." "Samples named in the title." "Different colors represent different model specifications.", size(vsmall)))
graph export "output/coefficients.png", replace

coefplot all_intent_1 all_intent_2 all_intent_3 all_intent_4, bylabel("All countries") || eu_intent_1 eu_intent_2 eu_intent_3 eu_intent_4, bylabel("EU countries") || neighbor_intent_1 neighbor_intent_2 neighbor_intent_3 neighbor_intent_4, bylabel("Neighboorhood countries") || other_intent_1 other_intent_2 other_intent_3 other_intent_4, bylabel("Other countries") ||, keep(p) xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) graphregion(col(white ))bgcol(white) plotlabels("Without FE" "Without FE with political" "With FE without political" "With FE with political") // byopts(note("Coefficients of variable p on intent and visits. Points represent point estimates, lines represent 90% confidence intervals." "Samples named in the title." "Different colors represent different model specifications.", size(vsmall)))
graph export "output/coefficients_intent.png", replace

coefplot all_visits_1 all_visits_2 all_visits_3 all_visits_4, bylabel("All countries") || eu_visits_1 eu_visits_2 eu_visits_3 eu_visits_4, bylabel("EU countries") || neighbor_visits_1 neighbor_visits_2 neighbor_visits_3 neighbor_visits_4, bylabel("Neighboorhood countries") || other_visits_1 other_visits_2 other_visits_3 other_visits_4, bylabel("Other countries") ||, keep(p) xline(0, lcolor(black)) subtitle(, lcolor(white) fcolor(white)) levels(90) graphregion(col(white ))bgcol(white) plotlabels("Without FE" "Without FE with political" "With FE without political" "With FE with political") // byopts(note("Coefficients of variable p on intent and visits. Points represent point estimates, lines represent 90% confidence intervals." "Samples named in the title." "Different colors represent different model specifications.", size(vsmall)))
graph export "output/coefficients_visits.png", replace

coefplot all_intent_5 all_visits_5, keep(p) xline(0, lcolor(black)) levels(90) bgcol(white) plotlabels("Intent" "Visits") title("All countries", color(black)) note("Coefficients of variable p on intent and visits. Points represent point estimates, lines represent 90% confidence intervals." "Only dyads with at least 1000 shipments in a given year.", size(vsmall))
graph export "output/coefficients_large.png", replace

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
	title(Gravity equation on the p-values\label{tab1}) ///
	nonumbers ///
	mlabel("\shortstack{Model 1 \\ without trade flow}" "\shortstack{Model 2 \\ with trade flow}") ///
	addnote("Notes: Linear model is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: all countries.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2, fmt(0 3) labels("Number of observations" "R^{2}"))

esttab gravity_intent gravity_visits using "${here}/output/results_gravity_dependent.tex", replace ///
	label booktabs b(3) p(3) eqlabels(none) collabels("") width(1.0\hsize) compress legend ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	title(Gravity equation on the dependent variables\label{tab2}) ///
	nonumbers ///
	mlabel("\shortstack{Model 1 \\ intent}" "\shortstack{Model 2 \\ visits}") ///
	addnote("Notes: Poisson pseudo-likelihood regression is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: all countries.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_p, fmt(0 3) labels("Number of observations" "Pseudo \(R^{2}\)"))

*foreach var in all_intent all_visits eu_intent eu_visits neighbor_intent neighbor_visits other_intent other_visits {
*	local sample = substr("`var'", 1, strpos("`var'", "_") - 1) 
*	local title = cond(substr("`var'", strpos("`var'", "_") + 1,.) == "intent", "intended", "actual") 
*	esttab `var'_1 `var'_2 `var'_3 `var'_4 using "${here}/output/results_`var'.tex", replace ///
*		label booktabs b(3) p(3) eqlabels(none) collabels("") width(1.0\hsize) compress legend ///
*		drop(_cons) ///
*		star(* 0.10 ** 0.05 *** 0.01) ///
*		title(Model of `title' visits - `sample' countries\label{tab1}) ///
*		nonumbers ///
*		mlabel("\shortstack{Without FE \\ without political variables}" "\shortstack{Without FE \\ with political variables}" "\shortstack{With FE \\ without political variables}" "\shortstack{With FE \\ with political variables}") ///
*		addnote("Notes: Poisson pseudo-likelihood regression is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: `sample' countries.") ///
*		cells(b(fmt(3) star) se(fmt(3) par)) ///
*		stats(N r2_p, fmt(0 3) labels("Number of observations" "Pseudo \(R^{2}\)"))
*}

local append replace
foreach var in all_intent all_visits eu_intent eu_visits neighbor_intent neighbor_visits other_intent other_visits {
	local sample = substr("`var'", 1, strpos("`var'", "_") - 1) 
	local title = cond(substr("`var'", strpos("`var'", "_") + 1,.) == "intent", "intended", "actual") 
	esttab `var'_1 `var'_2 `var'_3 `var'_4 using "${here}/output/results_append.tex", `append' ///
		label booktabs b(3) p(3) eqlabels(none) collabels("") width(1.0\hsize) compress legend ///
		drop(_cons) ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		title(Model of `title' visits - `sample' countries\label{tab1}) ///
		nonumbers ///
		mlabel("\shortstack{Without FE \\ without political variables}" "\shortstack{Without FE \\ with political variables}" "\shortstack{With FE \\ without political variables}" "\shortstack{With FE \\ with political variables}") ///
		addnote("Notes: Poisson pseudo-likelihood regression is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: `sample' countries.") ///
		cells(b(fmt(3) star) se(fmt(3) par)) ///
		stats(N r2_p, fmt(0 3) labels("Number of observations" "Pseudo \(R^{2}\)"))
		local append append
}

eststo clear
