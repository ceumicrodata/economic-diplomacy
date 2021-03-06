import delimited "temp/eu-related-countries.csv", varnames(1) clear
replace iso_3166_2 = "GR" if iso_3166_2 == "EL"
replace iso_3166_2 = "GB" if iso_3166_2 == "UK"
replace relation = "EU" if iso_3166_2 == "GB"
tempfile eu

clonevar iso2_o = iso_3166_2
clonevar iso2_d = iso_3166_2
save `eu'

import delimited "output/trade/polya-index.csv", clear

merge m:1 iso2_o using `eu', nogen keep(master match)
rename relation eu_relation_exporter

merge m:1 iso2_d using `eu', nogen keep(master match)
rename relation eu_relation_importer

*histogram p, fcolor(green%30) lcolor(green%30) ytitle("") xtitle("p-values") bin(100) graphregion(color(white))
histogram p, color(green%30) ytitle("") xtitle("p-values") bin(100) graphregion(color(white))
graph export "output/hist_p_all.png", replace

bys iso2_o iso2_d: egen early_p = mean(p) if year >= 2001 & year <= 2009
bys iso2_o iso2_d: egen late_p = mean(p) if year >= 2010 & year <= 2017

collapse (firstnm) early_p late_p eu_relation_exporter eu_relation_importer, by(iso2_o iso2_d)

*gen iso2_od = iso2_o + "-" + iso2_d

twoway (scatter late_p early_p, mcolor(green%10)) (lfit late_p early_p, color(red) lwidth(thick)), graphregion(color(white)) xtitle("early_p") ytitle("late_p") note("Country pairs." "All countries.") legend(off)
graph export "output/scatter_p_all.png", replace

twoway (scatter late_p early_p, mcolor(green%10)) (lfit late_p early_p, color(red) lwidth(thick)) if (eu_relation_importer == "EU"), graphregion(color(white)) xtitle("early_p") ytitle("late_p") note("Country pairs." "EU importer countries.") legend(off)
graph export "output/scatter_p_eu.png", replace

twoway (scatter late_p early_p, mcolor(green%10)) (lfit late_p early_p, color(red) lwidth(thick)) if (eu_relation_importer == "ENP" | eu_relation_importer == "ENP-South" | eu_relation_importer == "EFTA" | eu_relation_importer == "candidate"), graphregion(color(white)) xtitle("early_p") ytitle("late_p") note("Country pairs." "Neighbor importer countries.") legend(off)
graph export "output/scatter_p_neighbor.png", replace
