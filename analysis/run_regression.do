unab dummies : *_year

reghdfe ln_good_total ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
reghdfe ln_good_total trade_similarity ln_distw $dummy_vars, a(`dummies') cluster($index_vars)

ppmlhdfe trade_similarity ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
ppmlhdfe intent trade_similarity ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
ppmlhdfe visits trade_similarity ln_distw $dummy_vars, a(`dummies') cluster($index_vars)
