use "output/spain-merged", clear

corr kld mlq sad ssd
matrix C0 = r(C)

corr p*
matrix C1 = r(C)

corr kld mlq sad ssd p*
matrix C2 = r(C)

heatplot C0, values(format(%9.3f)) color(hcl, diverging intensity(.6)) legend(off) aspectratio(1) lower nodiagonal graphregion(color(white)) title("Correlation of different statistics", color(black))
graph export "output/heatmap_stat.png", replace

heatplot C1, values(format(%9.3f)) color(hcl, diverging intensity(.6)) legend(off) aspectratio(1) lower nodiagonal graphregion(color(white)) title("Correlation of different p-values", color(black))
graph export "output/heatmap_p.png", replace

heatplot C2, values(format(%9.3f)) color(hcl, diverging intensity(.6)) legend(off) aspectratio(1) lower nodiagonal graphregion(color(white)) title("Correlation of different indices", color(black))
graph export "output/heatmap_all.png", replace

twoway (histogram p_kld, color(green%30) bin(20)) (histogram p_mlq, color(red%30) bin(20)) (histogram p_sad, color(blue%30) bin(20)) (histogram p_ssd, color(black%30) bin(20)), legend(order(1 "p_kld" 2 "p_mlq" 3 "p_sad" 4 "p_ssd")) graphregion(color(white)) ytitle("") xtitle("") title("Distribution of different p-values", color(black))
graph export "output/hist_indices.png", replace
