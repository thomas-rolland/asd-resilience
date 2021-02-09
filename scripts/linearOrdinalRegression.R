
#=========================================================================
# linearOrdinalRegression.R
# Functions to calculate regression coefficient associated to variant presence
#=========================================================================

library(MASS)

# Linear regression
linear_regression = function(individual_table, variant_table, response, covariates)
{
	# response = column containing response variable
	# covariates = vector containing list of covariates (e.g. age, sex)
	
	# Adding column for variant presence
	individual_table = cbind(individual_table, has_variant = "No")
	individual_table$has_variant[individual_table$iid %in% variant_table$iid] = "Yes"
	covariates = c("has_variant", covariates)
	
	df = matrix(nrow = length(covariates), ncol = 5, data = NA)
	colnames(df) = c("covariate", "coefficient", "CI_lower", "CI_upper", "p.value")
	
	# Running regression analysis for specific outcome
	formula = as.formula(paste(response, "~", paste(covariates, collapse = "+")))
	model = glm(formula, data = individual_table, na.action = na.omit)

	# Get regression coefficients, CIs and p-values
	for (i in 1:length(covariates))
		df[i, ] = c(covariates[i], summary(model)$coefficients[grepl(covariates[i], row.names(summary(model)$coefficients)),1], as.double(conf_int(model)[grepl(covariates[i], row.names(summary(model)$coefficients)),]), summary(model)$coefficients[grepl(covariates[i], row.names(summary(model)$coefficients)), 4])

	return (as.data.frame(df))
}


# Ordinal regression
ordinal_regression = function(individual_table, variant_table, response, covariates)
{
	# response = column containing response variable
	# covariates = vector containing list of covariates (e.g. age, sex)

	# Adding column for variant presence
	individual_table = cbind(individual_table, has_variant = "No")
	individual_table$has_variant[individual_table$iid %in% variant_table$iid] = "Yes"
	covariates = c("has_variant", covariates)
	
	df = matrix(nrow = length(covariates), ncol = 5, data = NA)
	colnames(df) = c("covariate", "coefficient", "CI_lower", "CI_upper", "p.value")
	
	# Running regression
	m <- polr(form, data = tmp, Hess = TRUE, na.action = na.omit)
	ctable <- coef(summary(m))
	p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
	ctable <- cbind(ctable, "p value" = p)
	ci = conf_int(m)
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
