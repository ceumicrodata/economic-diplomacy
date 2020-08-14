use "input/GDELT/gov2gov-events-by-month.dta", clear

gen year = real(substr(YearMonth, 1, 4))

collapse (sum) Mentions3 Events3 Mentions4 Events4 Mentions5 Events5 Mentions6 Events6, by(Actor1CountryCode Actor2CountryCode year)

gen iso3_od = cond(Actor1CountryCode <= Actor2CountryCode, Actor1CountryCode, Actor2CountryCode) + cond(Actor1CountryCode >= Actor2CountryCode, Actor1CountryCode, Actor2CountryCode)

sum Mentions3 if Actor1CountryCode == "HUN" & Actor2CountryCode == "DEU" & year == 2018
sum Mentions3 if Actor1CountryCode == "DEU" & Actor2CountryCode == "HUN" & year == 2018
sum Mentions3 if iso3_od == "DEUHUN" & year == 2018

*collapse (mean) Mentions3 Events3 Mentions4 Events4 Mentions5 Events5 Mentions6 Events6, by(iso3_od year)
*sum Mentions3 if iso3_od == "DEUHUN" & year == 2018

bys iso3_od year (Actor1CountryCode): gen order = _n
drop Actor2CountryCode
reshape wide Actor1CountryCode Mentions3 Events3 Mentions4 Events4 Mentions5 Events5 Mentions6 Events6, i(iso3_od year) j(order)

save "temp/gdelt-clean.dta", replace
