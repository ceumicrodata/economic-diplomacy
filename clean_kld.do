cd input/respect-trade-similarity

local myfilelist : dir . files"KLD*.csv"

foreach file of local myfilelist {
	import delimited `"`file'"', clear

	gen year = substr(`"`file'"',5,4)
	
	local year = substr(`"`file'"',5,4)
	di `year'
	
	tempfile kld_`year'
	save `kld_`year'', replace
}

use `kld_2001', clear

*FIXME: exceptions
*missing years
append using `kld_2002'
append using `kld_2003'
forval i=2005(1)2012 {
	append using `kld_`i''
}
forval i=2014(1)2017 {
	append using `kld_`i''
}

rename declarant_iso iso2_o
rename partner_iso iso2_d
gen iso2_od = cond(iso2_o <= iso2_d, iso2_o, iso2_d) + cond(iso2_o >= iso2_d, iso2_o, iso2_d) 

destring year, replace

reshape wide kld, i(iso2_o iso2_d year) j(flow_str) string // if kld importer is needed

*keep if flow_str == "exp"
*drop flow_str

*browse if year == 2001 & ((iso2_o == "AT" & iso2_d == "HU") | (iso2_o == "HU" & iso2_d == "AT"))

count

save "../../temp/tsi-clean", replace
