unab dummies : *_year

label variable intent_events_exporter "Intended visits by exporter (count)"
label variable visits_events_exporter "Actual visits by exporter (count)"
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

estpost sum intent_events_exporter visits_events_exporter contig comlang_off colony comcol ln_good_total ln_distw ln_agree ln_po_diff ln_gdp_o ln_gdp_d
est store descriptive
esttab descriptive using "${here}/output/results_descriptives.tex", replace ///
	title(Descriptive statistics\label{tab1}) ///
	cells("count(fmt(0)) mean(fmt(2)) sd(fmt(2))") label booktabs nonum collabels("Obs" "Mean" "SD") gaps noobs
eststo clear

*gravity model without FE, with trade_similarity, with FE, with political variables
eststo: quietly reghdfe ln_good_total ln_distw ln_gdp*, noabsorb cluster($index_vars)

esttab est1 using "${here}/output/results_gravity.tex", replace ///
	label booktabs b(3) p(3) eqlabels(none) collabels(none) width(0.8\linewidth) legend ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	title(Gravity model\label{tab2}) ///
	nonumbers mtitles("Trade flow") ///
	addnote("Notes: Without FE." "Standard errors: Clustered standard errors are in parantheses." "Sample: All countries.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2, fmt(0 3) labels("Number of observations" "\(R^{2}\)"))

eststo clear

*simple model without trade_similarity without FE without political variables (4)
foreach var of varlist $outcomes_events {
	eststo: quietly ppmlhdfe `var' ln_good_total ln_distw ln_gdp*, noabsorb cluster($index_vars)
}

esttab est1 est2 using "${here}/output/results_without_fe.tex", replace ///
	label booktabs b(3) p(3) eqlabels(none) collabels(none) width(0.8\linewidth) legend ///
	drop(_cons) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	title(Simple model of intended and actual visits\label{tab3}) ///
	nonumbers mtitles("Intent" "Visits") ///
	addnote("Notes: Poisson pseudo-likelihood regression without fixed effects is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: All countries.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_p, fmt(0 3) labels("Number of observations" "Pseudo \(R^{2}\)"))

eststo clear

*gravity model with trade_similarity with FE with political variables (4)
*foreach sample in all eu_neighbor {
*	foreach var of varlist $outcomes_events {
*		eststo: quietly ppmlhdfe `var' ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff if $`sample', a(`dummies') cluster($index_vars)
*	}
*	esttab est* using "output/results_`sample'.tex", replace ///
*	label booktabs b(3) p(3) eqlabels(none) width(0.8\linewidth) ///
*	drop(_cons landlocked* ln_gdp*) ///
*	star(* 0.10 ** 0.05 *** 0.01) ///
*	title(Regression table\label{tab1}) ///
*	cells("b(fmt(3)star)" "se(fmt(3)par)") ///
*	stats(N r2_p, fmt(0 3) labels(`"Number of observations"' `"\(R^{2}\)"' `"LR chi2"'))
*	eststo clear
*}

*gravity model with trade_similarity with FE with political variables (4)
foreach sample in all eu_neighbor {
	foreach var of varlist $outcomes_events {
		eststo: quietly ppmlhdfe `var' ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff if $`sample', a(`dummies') cluster($index_vars)
	}
}

esttab est1 est2 using "${here}/output/results_all.tex", replace ///
	label booktabs b(3) p(3) eqlabels(none) collabels(none) width(0.8\linewidth) legend ///
	drop(_cons landlocked* ln_gdp*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	title(Determinants of intented and actual visits\label{tab4}) ///
	nonumbers mtitles("Intent" "Visits") ///
	addnote("Notes: Poisson pseudo-likelihood regression with fixed effects is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: All countries.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_p, fmt(0 3) labels("Number of observations" "Pseudo \(R^{2}\)"))
	
esttab est3 est4 using "${here}/output/results_eu_neighbor.tex", replace ///
	label booktabs b(3) p(3) eqlabels(none) collabels(none) width(0.8\linewidth) legend ///
	drop(_cons landlocked* ln_gdp*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	title(Determinants of intented and actual visits\label{tab5}) ///
	nonumbers mtitles("Intent" "Visits") ///
	addnote("Notes: Poisson pseudo-likelihood regression with fixed effects is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: Only the dyadic relations of EU members states with neighboring countries.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_p, fmt(0 3) labels("Number of observations" "Pseudo \(R^{2}\)"))
	
*return list
*ereturn list
eststo clear
	
*po-diff added - only EU data (2)
foreach var of varlist $outcomes_events {
	eststo: quietly ppmlhdfe `var' ln_good_total ln_distw ln_gdp* $dummy_vars ln_agree ln_dem_diff ln_po_diff, a(`dummies') cluster($index_vars)
}

esttab est1 est2 using "${here}/output/results_po.tex", replace ///
	label booktabs b(3) p(3) eqlabels(none) collabels(none) width(0.8\linewidth) legend ///
	drop(_cons landlocked* ln_gdp*) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	title(Determinants of intented and actual visits\label{tab5}) ///
	nonumbers mtitles("Intent" "Visits") ///
	addnote("Notes: Poisson pseudo-likelihood regression with fixed effects is used for estimation." "Standard errors: Clustered standard errors are in parantheses." "Sample: Only the dyadic relations within EU members states.") ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_p, fmt(0 3) labels("Number of observations" "Pseudo \(R^{2}\)"))
	
eststo clear
