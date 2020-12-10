* read EU groups of countries
import delimited "temp/eu-related-countries.csv", varnames(1) clear
replace iso_3166_2 = "GR" if iso_3166_2 == "EL"
replace iso_3166_2 = "GB" if iso_3166_2 == "UK"
replace relation = "EU" if iso_3166_2 == "GB"
tempfile eu

clonevar iso2_o = iso_3166_2
clonevar iso2_d = iso_3166_2
save `eu'

* p is moved to be the base of the dataset
import delimited "temp/p-values-trade.csv", clear 

merge 1:1 iso2_o iso2_d year using "temp/kld-clean.dta", keep(master match)
count

* is the exporter an EU country?
merge m:1 iso2_o using `eu', nogen keep(master match)
rename relation eu_relation_exporter
* is the importer an EU country?
merge m:1 iso2_d using `eu', nogen keep(master match)
rename relation eu_relation_importer

merge 1:1 iso2_o iso2_d year using "temp/aggregated-clean.dta", nogen

merge m:1 iso2_o iso2_d using "temp/geodist-clean.dta", keepusing(iso3_o iso3_d ///
iso3_od contig-distwces distwces area_o dis_int_o landlocked_o ///
continent_o city_en_o area_d dis_int_d landlocked_d continent_d city_en_d) keep(1 3) nogen

*merge m:1 iso3_od year using "temp/gdelt-clean.dta", // keep(3) nogen

*tab year _merge
*tab year _merge if tci_ != .

*keep if _merge == 3
*drop _merge

gen iso3_od_dir = iso3_o + iso3_d
drop if iso3_od_dir == ""
merge 1:1 iso3_od_dir year using "temp/gdelt-clean.dta", nogen keep(3)

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

gen dem_diff = abs(fh_ipolity2_o - fh_ipolity2_d)

merge m:1 iso3_od year using "input/un/un.dta", nogen keep(1 3)

count

preserve
foreach type in o d {
	use "temp/gdp-clean.dta", clear

	rename Country_Code iso3_`type'
	
	rename gdp gdp_`type'

	tempfile economic_`type'
	save `economic_`type''
}
restore

merge m:1 iso3_o year using `economic_o', nogen keep(1 3)
merge m:1 iso3_d year using `economic_d', nogen keep(1 3)

count

*foreach var in intent_events visits_events intent_mentions visits_mentions {
*	gen `var'_exporter = cond(iso3_o == actor1, `var'1, `var'2)
*	drop `var'1 `var'2
*}

merge m:1 iso2_od using "temp/po-clean", nogen keep(1 3)

count

save "output/analysis-sample.dta", replace
