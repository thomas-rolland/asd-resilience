
#=========================================================================
# linearOrdinalRegression.R
# Functions to calculate regression coefficient associated to variant presence
#=========================================================================

library(MASS)

# Linear regression
linear_regression = function(variant_table, outcomes_table, outcome, covariates)
{
	# outcome = column containing response variable
	# covariates = vector containing list of covariates (e.g. age, sex)

	# Adding column for variant presence
	outcomes_table = cbind(outcomes_table, has_variant = 0)
	outcomes_table$has_variant[outcomes_table$iid %in% variant_table$iid] = 1
	covariates = c("has_variant", covariates)

	df = matrix(nrow = length(covariates), ncol = 5, data = NA)
	colnames(df) = c("covariate", "coefficient", "CI_lower", "CI_upper", "p.value")

	# Running regression analysis for specific outcome
	formula = as.formula(paste(outcome, "~", paste(covariates, collapse = "+")))
	model = glm(formula, data = outcomes_table, na.action = na.omit)

	# Get regression coefficients, CIs and p-values
	for (i in 1:length(covariates))
		df[i, ] = c(covariates[i], summary(model)$coefficients[grepl(covariates[i], row.names(summary(model)$coefficients)),1], as.double(confint(model)[grepl(covariates[i], row.names(summary(model)$coefficients)),]), summary(model)$coefficients[grepl(covariates[i], row.names(summary(model)$coefficients)), 4])

	return (as.data.frame(df))
}


# Ordinal regression
ordinal_regression = function(variant_table, outcomes_table, outcome, covariates)
{
	# outcome = column containing response variable
	# covariates = vector containing list of covariates (e.g. age, sex)

	# Adding column for variant presence
	outcomes_table = cbind(outcomes_table, has_variant = 0)
	outcomes_table$has_variant[outcomes_table$iid %in% variant_table$iid] = 1
	covariates = c("has_variant", covariates)

	df = matrix(nrow = length(covariates), ncol = 5, data = NA)
	colnames(df) = c("covariate", "coefficient", "CI_lower", "CI_upper", "p.value")

	# Running regression
	outcomes_table[, colnames(outcomes_table) == outcome] = factor(outcomes_table[, colnames(outcomes_table) == outcome])
	formula = as.formula(paste(outcome, "~", paste(covariates, collapse = "+")))
	m <- polr(formula, data = outcomes_table, Hess = TRUE, na.action = na.omit)
	ctable <- coef(summary(m))
	p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
	ctable <- cbind(ctable, "p value" = p)
	ci = confint(m)
	ctable = cbind(OR = exp(coef(m)) - 1, exp(ci) - 1, pval = p[names(p) %in% covariates])

	# Get regression coefficients, CIs and p-values
	for (i in 1:length(covariates))
	{
		for (row in 1:length(row.names(ctable)))
			if (grepl(covariates[i], row.names(ctable)[row]) & ! grepl(":", row.names(ctable)[row]))
				break
		df[i, ] = c(covariates[i], ctable[row, ])
	}

	return (as.data.frame(df))
}
