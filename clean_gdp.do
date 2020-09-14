import excel "input/gdp/gdp.xls", sheet("Data") clear

drop in 1/3

*foreach var of varlist * {
*    rename `var' `=`var'[1]'
*}

foreach var of varlist * {
    rename `var' `=strtoname(`var'[1])'
}

drop in 1
keep Country_Code _1960-_2019

*foreach var of varlist _1960-_2019 {
*	local new = substr("`var'",2,4)
*	rename `var' `new'
*}

reshape long _, i(Country_Code) j(year)
rename _ gdp
destring gdp, replace

save "temp/gdp-clean", replace
