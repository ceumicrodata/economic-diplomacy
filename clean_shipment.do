use "input/trade_data_chapter/trade-data-chapter.dta", clear

destring year, replace

count
count if eu_relation_exporter == "EU"

duplicates report iso2_o iso2_d year chapter

gen shipment_size = 12000
generate shipments = ceil(good_total / shipment_size)

*collapse (sum) shipments, by(iso2_d year chapter)
collapse (sum) shipments, by(iso2_o iso2_d year chapter)

*reshape wide shipments, i(iso2_d year) j(chapter)
reshape wide shipments, i(iso2_o iso2_d year) j(chapter)

drop if iso2_o == ".." | iso2_o == "" | iso2_d == ".." | iso2_d == ""
mvencode shipments1-shipments99, mv(0) override
sort iso2_d iso2_o year
count

save "temp/shipment-clean.dta", replace
export delimited using "temp/shipment-clean.csv", replace
