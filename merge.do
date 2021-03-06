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
import delimited "output/trade/polya-index.csv", clear
generate polya_dummy = (p > 0.5) & !missing(p)
mvdecode polya_dummy if p == ., mv(0)

merge 1:1 iso2_o iso2_d year using "temp/kld-clean.dta", keep(master match) nogen
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
*merge 1:1 iso3_od_dir year using "temp/gdelt-clean.dta", nogen keep(3)
merge 1:1 iso3_od_dir year using "temp/gdelt-clean.dta"

keep if _merge == 3 | year == 2014

count
tab year

merge m:1 iso3_d year using  "temp/gdelt-agency-clean.dta", keep(1 3) nogen

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

merge 1:1 iso2_o iso2_d year using "temp/shipment-clean-aggregated.dta", keep(1 3) keepusing(shipments_large) nogen

count

preserve
import delimited "output/investment/FDI_from_EU_200318_wide_split_eu.csv", clear
rename iso2_o iso3_o
rename iso2_d iso3_d
rename p p_inv
tempfile p_inv
save `p_inv'
restore

merge 1:1 iso3_o iso3_d year using `p_inv', keep(1 3) nogen
generate polya_dummy_inv = ((p_inv > 0.5) & !missing(p_inv))
mvdecode polya_dummy_inv if p_inv == ., mv(0)
count

preserve
import delimited "temp/FDI_from_EU_200318_EU_aggregate.csv", clear
rename o_iso iso3_o
rename d_iso iso3_d
tempfile fdi
save `fdi'
restore

merge 1:1 iso3_o iso3_d year using `fdi', keep(1 3) nogen
count

save "output/analysis-sample.dta", replace
