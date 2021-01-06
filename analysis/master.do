* save variable lists  and different samples to be used in transormations and regressions
global log_vars good_total distw dem_diff agree po_diff kld* // p
global log_vars_single gdp_o gdp_d
global level_vars intent* visits* kld* eu_relation_exporter eu_relation_importer p* shipments_large polya_dummy
global dummy_vars contig comlang_off colony comcol landlocked_o landlocked_d 
global index_vars iso3_o iso3_d
global index_vars_iso2 iso2_o iso2_d

global all !missing(iso3_o)
global neighbor eu_relation_exporter == "EU" & (eu_relation_importer == "ENP" | eu_relation_importer == "ENP-South" | eu_relation_importer == "EFTA" | eu_relation_importer == "candidate")
global eu eu_relation_exporter == "EU" & eu_relation_importer == "EU"
global other eu_relation_exporter == "EU" & (eu_relation_importer == "other" | eu_relation_importer == "")

global outcomes intent*exporter visits*exporter
global outcomes_events intent_events_exporter visits_events_exporter
global outcomes_simple intent visits

* find project root folder
here

* p change over time checked
do "${here}/analysis/graph_p.do"

*use "${here}/output/analysis-sample.dta", clear
*do "${here}/analysis/inspect_p.do"

use "${here}/output/analysis-sample.dta", clear
do "${here}/analysis/create_variables.do"
do "${here}/analysis/run_regression_p.do"
*do "${here}/analysis/graph_hungary.do"
*do "${here}/analysis/run_regression.do"
*do "${here}/analysis/run_regression_slides.do"
*do "${here}/analysis/run_regression_russia.do"
*do "${here}/analysis/run_regression_examples.do"

use "${here}/output/analysis-sample.dta", clear
do "${here}/analysis/create_variables.do"
do "${here}/analysis/run_regression_inv.do"

