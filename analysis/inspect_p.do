keep p kldexp iso2_o iso2_d year

reshape wide p kldexp, i(iso2_o iso2_d) j(year)

corr p2016 p2017
corr kldexp2017 p2017
corr kldexp2016 p2016

twoway (scatter p2017 p2016)
