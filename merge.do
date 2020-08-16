use "temp/trade-similarity-clean.dta", clear

count

merge 1:1 iso2_o iso2_d year using "temp/aggregated-clean.dta", nogen

merge m:1 iso2_o iso2_d using "temp/geodist-clean.dta", keepusing(iso3_o iso3_d ///
iso3_od contig-distwces distwces area_o dis_int_o landlocked_o ///
continent_o city_en_o area_d dis_int_d landlocked_d continent_d city_en_d) keep(1 3) nogen

merge m:1 iso3_od year using "temp/gdelt-clean.dta", // keep(3) nogen

tab year _merge
tab year _merge if tci_ != .

keep if _merge == 3
drop _merge

count

preserve
foreach type in o d {
	use "temp/qog-clean.dta", clear

	rename ccodealp iso3
	
	foreach var of varlist _all {
		rename `var' `var'_`type'
	}
	
	rename year_`type' year

	tempfile political_`type'
	save `political_`type''
}
restore

merge m:1 iso3_o year using `political_o', nogen keep(1 3)
merge m:1 iso3_d year using `political_d', nogen keep(1 3)

count

foreach var in intent_events visits_events intent_mentions visits_mentions {
	gen `var'_exporter = cond(iso3_o == actor1, `var'1, `var'2)
	drop `var'1 `var'2
}

gen dem_diff = abs(fh_ipolity2_o - fh_ipolity2_d)

save "output/analysis-sample.dta", replace
