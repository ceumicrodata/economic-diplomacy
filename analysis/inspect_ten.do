use "input/trade_data_chapter/trade-data-chapter.dta", clear

destring year, replace

count
count if eu_relation_exporter == "EU"

gen shipment_size = 12000
generate shipments = ceil(good_total / shipment_size)

*collapse (sum) shipments, by(iso2_d year chapter)
collapse (sum) shipments, by(iso2_o iso2_d year chapter)

bys iso2_d year chapter: egen shipments_eu = mean(shipments)

preserve
import delimited "temp/p-values.csv", clear
tempfile p
save `p'
restore

merge m:1 iso2_o iso2_d year using `p', keep(3) nogen

gen shipments_diff = abs(shipments - shipments_eu)

merge m:1 iso2_o iso2_d using "temp/geodist-clean.dta", keepusing(iso3_o iso3_d) keep(3) nogen

preserve
foreach type in o d {
	use "temp/gdp-clean.dta", clear

	rename Country_Code iso3_`type'
	
	rename gdp gdp_`type'

	tempfile economic_`type'
	save `economic_`type''
}
restore

merge m:1 iso3_o year using `economic_o', nogen keep(3)
merge m:1 iso3_d year using `economic_d', nogen keep(3)

save "temp/inspect", replace

reg shipments_diff i.chapter##c.p i.year gdp_o gdp_d, cluster(iso2_d)

