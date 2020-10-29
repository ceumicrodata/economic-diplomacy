clear

set seed 12345

postfile buffer mean obs using "kld_sim_manydraw", replace

local balls 1 10 100 1000 10000
foreach b of local balls { 
	forval draw = 1(1)1000 {
	quietly drop _all
	quietly set obs 100
	quietly generate share = 1/_N
	quietly gen transaction_per_product = rpoisson(`b' * share)
	quietly egen total = total(transaction_per_product)
	quietly gen sample_share = transaction_per_product / total
	quietly gen KLD_component = sample_share * ln(sample_share / share)
	quietly egen KLD = sum(KLD_component)
	quietly sum KLD
	post buffer (r(mean)) (`b')
	}
}

postclose buffer

use "kld_sim_manydraw", clear

summarize

levelsof obs, local(levels) 
	foreach l of local levels {
		sum mean if obs == `l'
		hist mean if obs == `l', title("Number of balls: `l'") graphregion(fcolor(white))
		graph export "analysis/simulation/kld_sim_manydraw_`l'.png", replace
}

*twoway (histogram mean if obs == 1, bin(10)) (histogram mean if obs == 10, bin(10)) (histogram mean if obs == 100, bin(10)) (histogram mean if obs == 1000, bin(10)) (histogram mean if obs == 10000, bin(10)) 
histogram mean, bin(10) kdensity by(, graphregion(fcolor(white))) by(obs, yrescale xrescale) subtitle(, fcolor(white) lcolor(white))

graph export "analysis/simulation/kld_sim_manydraw_total.png", replace
