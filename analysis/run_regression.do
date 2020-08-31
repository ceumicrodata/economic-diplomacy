unab dummies : *_year

reghdfe ln_good_total ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
reghdfe ln_good_total trade_similarity ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
reghdfe ln_good_total trade_similarity ln_distw ln_dem_diff agree $dummy_vars, a(`dummies') cluster($index_vars)

reghdfe trade_similarity ln_distw ln_dem_diff agree $dummy_vars, a(`dummies') cluster($index_vars)
ppmlhdfe trade_similarity ln_distw ln_dem_diff agree $dummy_vars, a(`dummies') cluster($index_vars)

foreach var in intent_events_exporter visits_events_exporter intent_mentions_exporter visits_mentions_exporter {
	ppmlhdfe `var' trade_similarity ln_distw ln_dem_diff ln_agree $dummy_vars, a(`dummies') cluster($index_vars)
}
