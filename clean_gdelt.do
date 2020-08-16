use "input/GDELT/gov2gov-events-by-month.dta", clear

gen year = real(substr(YearMonth, 1, 4))

collapse (sum) Mentions3 Events3 Mentions4 Events4 Mentions5 Events5 Mentions6 Events6, by(Actor1CountryCode Actor2CountryCode year)

gen iso3_od = cond(Actor1CountryCode <= Actor2CountryCode, Actor1CountryCode, Actor2CountryCode) + cond(Actor1CountryCode >= Actor2CountryCode, Actor1CountryCode, Actor2CountryCode)

sum Mentions3 if Actor1CountryCode == "HUN" & Actor2CountryCode == "DEU" & year == 2018
sum Mentions3 if Actor1CountryCode == "DEU" & Actor2CountryCode == "HUN" & year == 2018
sum Mentions3 if iso3_od == "DEUHUN" & year == 2018

*collapse (mean) Mentions3 Events3 Mentions4 Events4 Mentions5 Events5 Mentions6 Events6, by(iso3_od year)
*sum Mentions3 if iso3_od == "DEUHUN" & year == 2018

gen intent_events = Events3 //if !missing(Events3)
egen visits_events = rowtotal(Events4 Events5 Events6) //if !missing(Events4,Events5,Events6)
gen intent_mentions = Mentions3 //if !missing(Events3)
egen visits_mentions = rowtotal(Mentions4 Mentions5 Mentions6) //if !missing(Events4,Events5,Events6)

bys iso3_od year (Actor1CountryCode): gen order = _n
drop Actor2CountryCode Events* Mentions*
reshape wide Actor1CountryCode intent_events visits_events intent_mentions visits_mentions, i(iso3_od year) j(order)

*browse if iso3_od == "DEUHUN"

rename Actor1CountryCode1 actor1
rename Actor1CountryCode2 actor2

save "temp/gdelt-clean.dta", replace
