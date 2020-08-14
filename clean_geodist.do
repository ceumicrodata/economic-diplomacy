use "input/cepii-geodist/geodist.dta", clear

rename iso_o iso3_o
rename iso_d iso3_d

gen iso2_od = cond(iso2_o <= iso2_d, iso2_o, iso2_d) + cond(iso2_o >= iso2_d, iso2_o, iso2_d) 
gen iso3_od = cond(iso3_o <= iso3_d, iso3_o, iso3_d) + cond(iso3_o >= iso3_d, iso3_o, iso3_d) 

drop _*
duplicates drop iso2_o iso2_d, force

save "temp/geodist-clean.dta", replace
