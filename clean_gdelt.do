use "input/GDELT/gov2gov-events-by-month.dta", clear

gen year = real(substr(YearMonth, 1, 4))

collapse (sum) Mentions3 Events3 Mentions4 Events4 Mentions5 Events5 Mentions6 Events6, by(Actor1CountryCode Actor2CountryCode year)

gen iso3_od = cond(Actor1CountryCode <= Actor2CountryCode, Actor1CountryCode, Actor2CountryCode) + cond(Actor1CountryCode >= Actor2CountryCode, Actor1CountryCode, Actor2CountryCode)
gen iso3_od_dir = Actor1CountryCode + Actor2CountryCode

sum Mentions3 if Actor1CountryCode == "HUN" & Actor2CountryCode == "DEU" & year == 2018
sum Mentions3 if Actor1CountryCode == "DEU" & Actor2CountryCode == "HUN" & year == 2018
sum Mentions3 if iso3_od == "DEUHUN" & year == 2018

*collapse (mean) Mentions3 Events3 Mentions4 Events4 Mentions5 Events5 Mentions6 Events6, by(iso3_od year)
*sum Mentions3 if iso3_od == "DEUHUN" & year == 2018

gen intent_events = Events3 //if !missing(Events3)
egen visits_events = rowtotal(Events4 Events5 Events6) //if !missing(Events4,Events5,Events6)
gen intent_mentions = Mentions3 //if !missing(Events3)
egen visits_mentions = rowtotal(Mentions4 Mentions5 Mentions6) //if !missing(Events4,Events5,Events6)

drop Actor2CountryCode Events* Mentions*

rename Actor1CountryCode actor
*rename Actor2CountryCode actor2

*reshape long actor, i(iso3_od_dir year) j(country)
*reshape wide actor intent_events visits_events intent_mentions visits_mentions, i(iso3_od_dir year) j(country)

bys iso3_od year (actor): gen order = _n

sum intent_mentions if actor == "HUN" & iso3_od == "DEUHUN" & year == 2018
sum intent_mentions if actor == "DEU" & iso3_od == "DEUHUN" & year == 2018
sum intent_mentions if iso3_od == "DEUHUN" & year == 2018

reshape wide actor iso3_od_dir intent_events visits_events intent_mentions visits_mentions, i(iso3_od year) j(order)

sum intent_mentions1 if iso3_od == "DEUHUN" & year == 2018 
sum intent_mentions2 if iso3_od == "DEUHUN" & year == 2018 

expand 2
bys iso3_od year: gen order = _n
foreach var in actor iso3_od_dir intent_events visits_events intent_mentions visits_mentions {
	clonevar `var'1_original = `var'1
	replace `var'1 = `var'2 if order == 2
	replace `var'2 = `var'1_original if order == 2
	drop `var'1_original
	rename `var'1 `var'_exporter
	rename `var'2 `var'_importer	
}

*browse if iso3_od == "DEUHUN"

rename iso3_od_dir_exporter iso3_od_dir
drop if iso3_od_dir == ""

count
count if missing(actor_exporter)
count if missing(actor_importer)

replace actor_importer = substr(iso3_od_dir,4,3) if actor_importer == ""

count if missing(actor_importer)

gen eu = 0
foreach iso in AUT BEL BGR CYP CZE DEU DNK ESP EST FIN FRA GBR GRC HRV HUN IRL ITA LTU LUX LVA MLT NLD POL PRT ROM SVK SVN SWE {
	replace eu = 1 if actor_exporter == "`iso'"
}

bys actor_importer year: egen intent_events_eu = mean(intent_events_exporter) if eu
bys actor_importer year: egen visits_events_eu = mean(visits_events_exporter) if eu

drop iso3_od_dir_importer actor_exporter actor_importer order iso3_od eu

save "temp/gdelt-clean.dta", replace
