clear 
postfile buffer mean lnN using "kld_sim_onedraw", replace

forval i= 1(1)10000 {
	quietly drop _all
	quietly set obs 100
	quietly generate share = 1/_N
	quietly gen transaction_per_product = rpoisson(`i' * share)
	quietly egen total = total(transaction_per_product)
	quietly gen sample_share = transaction_per_product / total
	quietly gen KLD_component = sample_share * ln(sample_share / share)
	quietly egen KLD = sum(KLD_component)
	quietly sum KLD
	post buffer (r(mean)) (ln(`i'))
}

postclose buffer

use "kld_sim_onedraw", clear

summarize

scatter mean lnN, graphregion(color(white)) ytitle(KLD)
graph export "kld_sim_onedraw.png", replace
