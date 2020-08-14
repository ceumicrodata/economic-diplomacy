import delimited "input/respect-trade-similarity/TC_INDEX_EXP_.csv", clear

rename declarant iso2_o
rename partner iso2_d

reshape long tci_, i(iso2_o iso2_d) j(year)

drop v1

gen iso2_od = cond(iso2_o <= iso2_d, iso2_o, iso2_d) + cond(iso2_o >= iso2_d, iso2_o, iso2_d) 

sum tci_ if iso2_o == "HU" & iso2_d == "DE" & year == 2017
sum tci_ if iso2_o == "DE" & iso2_d == "HU" & year == 2017
sum tci_ if iso2_od == "DEHU" & year == 2017

save "temp/trade-similarity-clean.dta", replace
