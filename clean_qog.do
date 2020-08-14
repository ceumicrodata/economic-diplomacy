use "input/qog/qog-basic.dta", clear

drop if cname == "France (-1962)"
drop if cname == "Cyprus (-1974)"
drop if cname == "Germany, West"

duplicates tag ccodealp year, gen(duplication)
drop if duplication
drop duplication

save "temp/qog-clean.dta", replace
