use "input/trade-bins/trade-bins-eu.dta", clear

destring year, replace

drop if iso2_d == ".."
drop value value_total

sum if iso2_d == "RU" & year == 2017

*drop iso2_d value value_total year
*tostring year, replace
*gen country_year = iso2_d + year
*rename value_share share_
*reshape wide share_, i(chapter) j(country_year) string

save "analysis/simulation/shares", replace
