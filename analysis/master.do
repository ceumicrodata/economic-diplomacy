* save variable lists to be used in transormations and regressions
global log_vars good_total distw
global level_vars Events*1 tci_
global dummy_vars contig comlang_off colony comcol landlocked_o landlocked_d 
global index_vars iso3_o iso3_d

* find project root folder
here

use "${here}/output/analysis-sample.dta", clear
do "${here}/analysis/create_variables.do"
do "${here}/analysis/run_regression.do"

