import excel "input/public-opinion/ebs_491.xls", sheet("QA1") clear

drop in 1/8
keep if _n == 1 | _n == 3 | _n == 5 | _n == 7| _n == 9
drop A - D I K AI - GP

foreach var of varlist * {
    rename `var' `=`var'[1]'
}

drop in 1

foreach var of varlist * {
    local new = "country_" + "`var'"
    rename `var' `new'
}

gen weight = 4 - _n

reshape long country_, i(weight) j(country) string

destring(country_), replace

collapse (mean) weight [fw = country_], by(country)
gen merged = 1 

preserve

clonevar j = country

reshape wide country weight, i(merged) j(j) string

tempfile countries
save `countries'

restore

merge m:1 merged using `countries', nogen

rename weight original
foreach var of varlist weight* {
	replace `var' = original - `var'
}

drop original merged
rename country iso2_o

reshape long country weight, i(iso2_o) j(j) string

drop j
rename country iso2_d
rename weight po_diff

drop if iso2_o == iso2_d

gen iso2_od = cond(iso2_o <= iso2_d, iso2_o, iso2_d) + cond(iso2_o >= iso2_d, iso2_o, iso2_d)
replace po_diff = abs(po_diff)
duplicates drop iso2_od, force

count
compress

save "temp/po-clean", replace
