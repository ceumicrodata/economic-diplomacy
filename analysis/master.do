* save variable lists  and different samples to be used in transormations and regressions
global log_vars good_total distw dem_diff agree po_diff
global log_vars_single gdp_o gdp_d
global level_vars intent* visits* kld* eu_relation_exporter eu_relation_importer
global dummy_vars contig comlang_off colony comcol landlocked_o landlocked_d 
global index_vars iso3_o iso3_d

global all !missing(iso3_o)
global eu_neighbor eu_relation_exporter == "EU" & eu_relation_importer != "EU"  & !missing(eu_relation_importer)
global eu_eu eu_relation_exporter == "EU" & eu_relation_importer == "EU"

global outcomes intent*exporter visits*exporter
global outcomes_events intent_events_exporter visits_events_exporter

* find project root folder
here

use "${here}/output/analysis-sample.dta", clear
do "${here}/analysis/create_variables.do"
do "${here}/analysis/run_regression.do"
do "${here}/analysis/run_regression_slides.do"
