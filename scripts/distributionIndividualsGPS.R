
#=========================================================================
# distributionIndividualsGPS.R
# Function to calculate the fraction of individuals in GPS quantiles
#=========================================================================


# Quantiles of values, not of individuals
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
distrib_individual_GPS = function(variant_table, asd_gps_table, n_quantiles = 3, carriers = TRUE)
{
	# n_quantiles = Number of quantiles to split the distribution
	# carriers = Whether carriers or non-carriers are considered (boolean)

	asd_gps_table = asd_gps_table[! is.na(asd_gps_table$asd_gps),]

	# Get quantiles based on values, not on distribution of individuals
	q = value_quantile(asd_gps_table$asd_gps, n_quantiles)

	n = rep(NA, length(q) - 1)
	f = rep(NA, length(q) - 1)
	sep = rep(NA, length(q) - 1)

	# Restrict individuals to those carrying or not carrying variant
	if (carriers == TRUE)
		asd_gps_table = asd_gps_table[asd_gps_table$iid %in% variant_table$iid,]
	else
		asd_gps_table = asd_gps_table[! asd_gps_table$iid %in% variant_table$iid,]

	# Get number of individuals in quantiles
	for (i in 2:length(q))
		n[i - 1] = length(unique(as.character(asd_gps_table$iid[asd_gps_table$asd_gps >= q[i - 1] & asd_gps_table$asd_gps < q[i]])))

	# Get fraction of individuals in each quantile, and corresponding standard errors of proportion
	for (i in 2:length(q))
	{
		f[i - 1] = n[i - 1] / sum(n)
		sep[i - 1] = sqrt((f[i - 1] * (1 - f[i - 1])) / sum(n))
	}

	df = cbind(paste(seq(1, length(q) - 1), seq(2, length(q)), sep = "-"), n, f, sep)
	colnames(df) = c("quantile", "n_individuals", "fraction_individuals", "standard_error")

	return (as.data.frame(df))
}
