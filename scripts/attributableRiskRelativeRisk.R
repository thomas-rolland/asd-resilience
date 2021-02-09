
#=========================================================================
# attributableRiskRelativeRisk.R
# Functions to calculate AR and RR with confidence intervals
#=========================================================================

# Number of individuals carrying variants per gene
variant2gene = function(variant_table, sample_table, gene_table)
{
	# Creating dataframe per gene, stratified by cohort and status
	tab_gene = as.data.frame(cbind(expand.grid(gene_table$gene_symbol, unique(sample_table$cohort), unique(sample_table$status)), NC = 0, N = 0))
  	colnames(tab_gene) = c("gene", "cohort", "status", "NC", "N")

	# Formatting columns
	tab_gene$gene = as.character(tab_gene$gene)
	tab_gene$cohort = as.character(tab_gene$cohort)
	tab_gene$status = as.character(tab_gene$status)
	tab_gene$N = as.double(tab_gene$N)
	tab_gene$NC = as.double(tab_gene$NC)

	# Calculate number of variants per gene stratified by cohort and status
	for (gene in unique(tab_gene$gene))
	{
		for (cohort in unique(tab_gene$cohort))
  		{
			for (status in unique(tab_gene$status))
			{
				tab_gene$NC[tab_gene$gene == gene & tab_gene$cohort == cohort & tab_gene$status == status] = length(unique(variant_table$IID[variant_table$gene == gene & variant_table$cohort == cohort & variant_table$status == status]))
				tab_gene$N[tab_gene$gene == gene & tab_gene$cohort == cohort & tab_gene$status == status] = sample_table$N[sample_table$cohort == cohort & sample_table$status == status]
			}
		}
	}
	
	return (tab_gene)
}


# Calculate attributable and relative risk
gene2risk = function(tab_gene, sample_table, RR_Inf = TRUE, RR_zero = FALSE)
{
	# tab_gene = Dataframe provided by variant2gene function above
	# RR_Inf = Boolean indicating whether infinite relative risk values due to absent carrier controls should be artificially set to 1 to avoid infinite RR
	# RR_zero = Boolean indicating whether genes for which no carrier cases were identified should be removed
	
	tab_risk = as.data.frame(cbind(gene = as.character(unique(tab_gene$gene)), case = 0, control = 0, RR = 0, logRR_CI_low = 0, logRR_CI_high = 0, AR = 0, AR_CI_low = 0, AR_CI_high = 0))

	# Format columns
	tab_risk$gene = as.character(tab_risk$gene)
	for (k in 2:dim(tab_risk)[2])
		tab_risk[,k] = as.double(tab_risk[,k])

	# Calculate AR/RR
	for (gene in unique(tab_risk$gene))
	{
		IE = tab_gene$NC[tab_gene$gene == gene & tab_gene$status == "Case"]
		CE = tab_gene$NC[tab_gene$gene == gene & tab_gene$status == "Control"]
		IN = tab_gene$N[tab_gene$gene == gene & tab_gene$status == "Case"] - IE
		CN = tab_gene$N[tab_gene$gene == gene & tab_gene$status == "Control"] - CE

		# If no control carriers, set CE to 1 so that relative risk is not infinite
		if (RR_Inf == FALSE & CE == 0 & IE > 0)
		{
			CE = 1
			CN = sample_table$N[sample_table$status == "Control"] - CE
		}
    
		# Fraction of cases and controls with variant
		tab_risk$case[tab_risk$gene == gene] = IE / (IE + IN)
		tab_risk$control[tab_risk$gene == gene] = CE / (CE + CN)

		# Measure AR and RR
		RR = (IE / (IE + IN)) / (CE / (CE + CN))
		AR = (IE / (IE + IN)) - (CE / (CE + CN))
		logRR_SE = sqrt((IN / (IE * (IE + IN))) + (CN / (CE * (CE + CN))))
		AR_SE = sqrt(((IE * IN) / (IE + IN)^3) + ((CE * CN) / (CE + CN)^3))
		tab_risk$RR[tab_risk$gene == gene] = RR
		tab_risk$logRR_CI_low[tab_risk$gene == gene] = log(RR) - logRR_SE * 0.95
		tab_risk$logRR_CI_high[tab_risk$gene == gene] = log(RR) + logRR_SE * 0.95
		tab_risk$AR[tab_risk$gene == gene] = AR
		tab_risk$AR_CI_low[tab_risk$gene == gene] = AR - AR_SE * 0.95
		tab_risk$AR_CI_high[tab_risk$gene == gene] = AR + AR_SE * 0.95
	}

	# Remove genes for which no case and no control carriers were found
	tab_risk = tab_risk[! is.na(tab_risk$RR),]

	# Remove genes for which no case carriers were found
	if (RR_zero == FALSE)
		tab_risk = tab_risk[tab_risk$RR > 0,]

	return (tab_risk)
}

