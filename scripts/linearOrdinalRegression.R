
#=========================================================================
# linearOrdinalRegression.R
# Functions to calculate regression coefficient associated to variant presence
#=========================================================================

# Linear regression
linear_regression = function(individual_table, formula)
{
df = matrix(nrow = 1, ncol = 4, data = NA)

  # if (dim(tmp[tmp$variant == 1,])[1] == 0)
  #   return (df)

  # Running regression analysis
  model = glm(form, data = tmp, na.action = na.omit)

  # Returning coefficient, CI and p-value
  for (i in 1:length(covariates))
  {
    df[i, ] = c(summary(model)$coefficients[grepl(covariates[i], row.names(summary(model)$coefficients)),1], as.double(conf_int(model)[grepl(covariates[i], row.names(summary(model)$coefficients)),]), summary(model)$coefficients[grepl(covariates[i], row.names(summary(model)$coefficients)), 4])
  }
  df = as.data.frame(df)

  return (df)
}


#################
# Ordinal regression
#################
ordinal_regression = function(t_indiv, form, populations, status, covariates)
{
  df = matrix(nrow = length(covariates), ncol = 4, data = NA)

  # Formatting data frame
  tmp = t_indiv[t_indiv$pop %in% populations & t_indiv$status == status, ]

  # if (dim(tmp[tmp$variant == 1,])[1] == 0)
  #   return (df)

  # Running regression
  m <- polr(form, data = tmp, Hess = TRUE, na.action = na.omit)
  ctable <- coef(summary(m))
	p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
	ctable <- cbind(ctable, "p value" = p)
	ci = conf_int(m)
  ctable = cbind(OR = exp(coef(m)) - 1, exp(ci) - 1, pval = p[names(p) %in% covariates])

  # Returning coefficient, CI and p-value
  for (i in 1:length(covariates))
  {
    row = NA
    for (row in 1:length(row.names(ctable)))
      if (grepl(covariates[i], row.names(ctable)[row]) & ! grepl(":", row.names(ctable)[row]))
        break

    df[i, ] = ctable[row, ]
  }
  df = as.data.frame(df)

  return (df)
}
