here
local here = r(here)

cap log close
log using "`here'/output/run_regression_spain", text replace

use "`here'/output/analysis-sample-spain.dta", clear

foreach X of varlist distw gdp* good_total {
	generate ln_`X' = ln(`X')
}

reghdfe p ln_distw ln_gdp*, noabsorb cluster(region_o iso2_d)
reghdfe p ln_distw ln_gdp* ln_good_total, noabsorb cluster(region_o iso2_d)

log close
