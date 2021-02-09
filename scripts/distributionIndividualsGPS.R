
#=========================================================================
# distributionIndividualsGPS.R
# Function to plot the distribution of the fraction of individuals in GPS terciles
#=========================================================================


# Quantiles of values, not of distribution
value_quantile = function(distrib, n_quantiles)
{
  mini = min(distrib, na.rm = TRUE)
  maxi = max(distrib, na.rm = TRUE)
  quant = (maxi - mini) / n_quantiles
  q = seq(mini, maxi, quant)
  q = c(q[1], q[length(q) - 1], q[length(q)])
  q[length(q)] = maxi + 1
  return (q)
}

# Get fraction of individuals in each quantile
distrib_individual_GPS = function(individual_table, n_quantiles = 3, cohort, status, transmission)
{
	# n_quantiles = Number of quantiles to split the distribution
	# cohort = Cohort of interest
	# status = Status of interest ("case", "control")
	# transmission = Vector of transmission types to consider (NA for non-carriers, "denovo", "father", "mother", "unknown")
	
	individual_table = individual_table[! is.na(individual_table$ASD_GPS),]
	
	# Get quantiles based on values, not on distribution of individuals
	q = value_quantile(individual_table$ASD_GPS, n_quantiles)
 
	n = rep(NA, length(q) - 1)
	f = rep(NA, length(q) - 1)
	sep = rep(NA, length(q) - 1)
	
	# Get number of individuals in each quantile
	for (i in 2:length(q))
		n[i - 1] = length(unique(as.character(individual_table$iid[individual_table$ASD_GPS >= q[i - 1] & individual_table$ASD_GPS < q[i] & individual_table$cohort == cohort & individual_table$status == status & individual_table$transmission %in% transmission])))

	# Get fraction of individuals in each quantile, and corresponding standard errors of proportion
	for (i in 2:length(q))
	{
		f[i - 1] = n[i - 1] / sum(n)
		sep[i - 1] = sqrt((f[i - 1] * (1 - f[i - 1])) / sum(n))
	}

	df = cbind(seq(2, length(q)), n, f, sep)
	colnames(df) = c("quantile", "n_individuals", "fraction_individuals", "standard_error")

	return (as.data.frame(df))
}

