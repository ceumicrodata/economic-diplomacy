unab dummies : *_year

reghdfe ln_good_total ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
reghdfe ln_good_total trade_similarity ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
reghdfe ln_good_total trade_similarity ln_distw ln_dem_diff $dummy_vars, a(`dummies') cluster($index_vars)

reghdfe trade_similarity ln_distw ln_dem_diff $dummy_vars, a(`dummies') cluster($index_vars)
ppmlhdfe trade_similarity ln_distw ln_dem_diff $dummy_vars, a(`dummies') cluster($index_vars)

ppmlhdfe intent_events_exporter trade_similarity ln_distw ln_dem_diff $dummy_vars, a(`dummies') cluster($index_vars)
ppmlhdfe visits_events_exporter trade_similarity ln_distw ln_dem_diff $dummy_vars, a(`dummies') cluster($index_vars)

ppmlhdfe intent_mentions_exporter trade_similarity ln_distw ln_dem_diff $dummy_vars, a(`dummies') cluster($index_vars)
ppmlhdfe visits_mentions_exporter trade_similarity ln_distw ln_dem_diff $dummy_vars, a(`dummies') cluster($index_vars)
