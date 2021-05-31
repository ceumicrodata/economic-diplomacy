cap ssc install heatplot
cap ssc install palettes, replace
cap ssc install colrspace, replace

import delimited "output/spain-KLD.csv", clear
rename p p_kld

preserve
	import delimited "output/spain-MLQ.csv", clear
	rename p p_mlq
	tempfile mlq
	save `mlq'
restore

preserve
	import delimited "output/spain-SAD.csv", clear
	rename p p_sad
	tempfile sad
	save `sad'
restore

preserve
	import delimited "output/spain-SSD.csv", clear
	rename p p_ssd
	tempfile ssd
	save `ssd'
restore

merge 1:1 region_o using `mlq', nogen
merge 1:1 region_o using `sad', nogen
merge 1:1 region_o using `ssd', nogen

preserve
	import delimited "external/regions.csv", clear
	rename region_od region_o
	tempfile region
	save `region'
restore

merge 1:1 region_o using `region', nogen

save "output/spain-merged", replace
