
#################
# From variant table to gene table
#################
variant2gene = function(t, total_individuals, t_gene)
{
  # Creating data frame per gene, stratified by population and status
	tab = as.data.frame(cbind(expand.grid(t_gene$gene, unique(total_individuals$population), unique(total_individuals$status)), NC = 0, N = 0, tada = NA, LOEUF = NA, pLI = NA))
  colnames(tab) = c("gene", "population", "status", "NC", "N", "tada", "LOEUF", "pLI")

  # Formatting columns
  tab$gene = as.character(tab$gene)
  tab$population = as.character(tab$population)
  tab$status = as.character(tab$status)
	tab$N = as.double(tab$N)
	tab$NC = as.double(tab$NC)

  # Calculate number of variants per gene stratified by status
  for (gene in unique(tab$gene))
	{
    for (population in unique(tab$population))
  	{
      for (status in unique(tab$status))
      {
        # Number of carriers and number of individuals
  			tab$NC[tab$gene == gene & tab$population == population & tab$status == status] = length(unique(t$IID[t$gene == gene & t$population == population & t$status == status]))
  			tab$N[tab$gene == gene & tab$population == population & tab$status == status] = total_individuals$N[total_individuals$population == population & total_individuals$status == status]

        # Deleteriousness scores
  			tab$tada[tab$gene == gene & tab$population == population & tab$status == status] = unique(t_gene$TADA[t_gene$gene == gene])
  			tab$LOEUF[tab$gene == gene & tab$population == population & tab$status == status] = unique(t_gene$LOEUF[t_gene$gene == gene])
  			tab$pLI[tab$gene == gene & tab$population == population & tab$status == status] = unique(t_gene$pLI[t_gene$gene == gene])
  	  }
  	}
  }

  # Formatting columns
  tab$gene = as.character(tab$gene)
  tab$NC = as.integer(tab$NC)
  tab$N = as.integer(tab$N)
	tab$tada = as.double(tab$tada)
	tab$LOEUF = as.double(tab$LOEUF)
	tab$pLI = as.double(tab$pLI)

	return (tab)
}


#################
# Measure of penetrance and relative/attributable risk
#################
gene2penetrance = function(genes, total_individuals, Inf_RR = TRUE, rm_noCase = FALSE)
{
	tab = as.data.frame(cbind(gene = as.character(unique(genes$gene)), tada = NA, LOEUF = NA, pLI = NA, aff = 0, unaff = 0, penetrance = 0, penetrance_sd = 0, RR = 0, logRR_CI_low = 0, logRR_CI_high = 0, AR = 0, AR_CI_low = 0, AR_CI_high = 0))

  # Format columns
  tab$gene = as.character(tab$gene)
  for (k in 2:dim(tab)[2])
    tab[,k] = as.double(tab[,k])

  # Measure penetrance and RR/AR
	for (gene in unique(tab$gene))
	{
    # Get deleteriousness scores
    tab$tada[tab$gene == gene] = genes$tada[genes$gene == gene & genes$status == "Case"]
    tab$LOEUF[tab$gene == gene] = genes$LOEUF[genes$gene == gene & genes$status == "Case"]
    tab$pLI[tab$gene == gene] = genes$pLI[genes$gene == gene & genes$status == "Case"]

    # Number of carriers and non-carriers
  	IE = genes$NC[genes$gene == gene & genes$status == "Case"]
		CE = genes$NC[genes$gene == gene & genes$status == "Control"]
		IN = genes$N[genes$gene == gene & genes$status == "Case"] - IE
		CN = genes$N[genes$gene == gene & genes$status == "Control"] - CE

    # If no control found, add one manually so that penetrance/RR are not infinite
    if (Inf_RR == FALSE & CE == 0 & IE > 0)
		{
			CE = 1
			CN = total_individuals$N[total_individuals$status == "Control"] - CE
		}

    # Fraction of cases and controls with variant
		tab$aff[tab$gene == gene] = IE / (IE + IN)
		tab$unaff[tab$gene == gene] = CE / (CE + CN)

    # Measure penetrance
    if (tab$aff[tab$gene == gene] + tab$unaff[tab$gene == gene] > 0)
    {
		  tab$penetrance[tab$gene == gene] = tab$aff[tab$gene == gene] / (tab$aff[tab$gene == gene] + tab$unaff[tab$gene == gene])
      tab$penetrance_sd[tab$gene == gene] = sqrt((tab$penetrance[tab$gene == gene] * (1 - tab$penetrance[tab$gene == gene])) / (tab$aff[tab$gene == gene] + tab$unaff[tab$gene == gene]))
    }

    # Measure RR and AR
    RR = (IE / (IE + IN)) / (CE / (CE + CN))
		RD = (IE / (IE + IN)) - (CE / (CE + CN))
		logRR_SE = sqrt((IN / (IE * (IE + IN))) + (CN / (CE * (CE + CN))))
		RD_SE = sqrt(((IE * IN) / (IE + IN)^3) + ((CE * CN) / (CE + CN)^3))
		tab$RR[tab$gene == gene] = RR
		tab$logRR_CI_low[tab$gene == gene] = log(RR) - logRR_SE * 0.95
		tab$logRR_CI_high[tab$gene == gene] = log(RR) + logRR_SE * 0.95
		tab$AR[tab$gene == gene] = RD
		tab$AR_CI_low[tab$gene == gene] = RD - RD_SE * 0.95
		tab$AR_CI_high[tab$gene == gene] = RD + RD_SE * 0.95
	}

  # Remove genes for which no cases and no controls were found
  tab = tab[! is.na(tab$RR),]

  # Remove genes for which no cases were found
  if (rm_noCase == TRUE)
    tab = tab[tab$RR > 0,]

	return (tab)
}

