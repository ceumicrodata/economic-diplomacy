import delimited "temp/eu-related-countries.csv", varnames(1) clear
replace iso_3166_2 = "GR" if iso_3166_2 == "EL"
replace iso_3166_2 = "GB" if iso_3166_2 == "UK"
replace relation = "EU" if iso_3166_2 == "GB"
tempfile eu

clonevar iso2_o = iso_3166_2
clonevar iso2_d = iso_3166_2
save `eu'

import delimited "temp/p-values.csv", clear

merge m:1 iso2_o using `eu', nogen keep(master match)
rename relation eu_relation_exporter

merge m:1 iso2_d using `eu', nogen keep(master match)
rename relation eu_relation_importer

*xtline p if iso2_o == "HU", i(iso2_d) t(year) xtitle("") ytitle("") byopts(title("Hungary")) graphregion(color(white))

*forval i = 1(1)24 {
*	global plot plot`i'opts(lcolor(white) lwidth(thin))
*}

*di "${plot}"
	
*xtline p if iso2_o == "HU", i(iso2_d) t(year) overlay xtitle("") ytitle("") title("Hungary") graphregion(color(white)) legend(off) plot`i'opts(lcolor(white) lwidth(thin))

twoway (line p year if iso2_o == "HU" & (eu_relation_importer == "ENP" | eu_relation_importer == "ENP-South"), lcolor(black%10) xtitle("")), graphregion(color(white)) title(Hungary, color(black))
graph export "output/panel_p_hungary.png", replace
