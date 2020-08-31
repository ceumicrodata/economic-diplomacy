* save variable lists to be used in transormations and regressions
global log_vars good_total distw dem_diff agree
global level_vars intent* visits* tci_ eu_relation_exporter eu_relation_importer
global dummy_vars contig comlang_off colony comcol landlocked_o landlocked_d 
global index_vars iso3_o iso3_d

* find project root folder
here

use "${here}/output/analysis-sample.dta", clear
do "${here}/analysis/create_variables.do"
do "${here}/analysis/run_regression.do"

