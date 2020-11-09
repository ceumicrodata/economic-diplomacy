use "input/trade_data_chapter/trade-data-chapter.dta", clear

destring year, replace

count
count if eu_relation_exporter == "EU"

gen shipment_size = 12000

generate shipments = ceil(good_total / shipment_size)
collapse (sum) shipments, by(iso2_d year chapter)
reshape wide shipments, i(iso2_d year) j(chapter)

drop if iso2_d == ".." | iso2_d == ""

save "temp/shipment-clean.dta", replace
export delimited using "temp/shipment-clean.csv", replace
