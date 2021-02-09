
#=========================================================================
# geneClusteringMRI.R
# Functions to provide a dataframe summarizing brain volume differences between LoF carriers and non-carriers by gene
#=========================================================================

gene_clustering_MRI = function(gene_table, mri_table, variant_table)
{
	brain_regions = c("TotalBrain", "IntraCranial", "CerebralCortex", "CerebralWhiteMatter", "Thalamus", "CaudateNucleus", "Putamen", "Pallidum", "Hippocampus", "Amygdala", "NucleusAccumbens", "CorpusCallosum", "CerebellumCortex", "CerebellumWhiteMatter")
	df = as.data.frame(cbind(gene = gene_table$gene_symbol, NC = NA, cluster = NA))
	for (region in brain_regions)
		df = as.data.frame(cbind(df, region = NA))
	colnames(df) = c("gene", "NC", brain_regions)
	
	# Calculate Wilcoxon estimate of difference between LoF carriers and non-carriers per gene and per brain region
	for (gene in gene_table$gene_symbol)
	{
		df$NC[df$gene == gene] = length(unique(variant_table$iid[variant_table$gene == gene]))
		for (region in brain_regions)
		{
			test = wilcox.test(mri_table[mri_table$iid %in% variant_table$iid[variant_table$gene == gene], names(mri_table) == region], mri_table[! mri_table$iid %in% variant_table$iid[variant_table$gene == gene], names(mri_table) == region], conf.int = TRUE)
			df[df$gene == gene, names(df) == region] = as.double(test$estimate)
		}
	}

	# Removing genes for which no carrier was found
	df = df[df$NC > 0,]
	
	# Clustering genes
	dd <- dist(as.data.frame(df[, names(df) %in% brain_regions]), method = "euclidean")
	hc <- hclust(dd, method = "ward.D2")
	tc = cutree(hc, k = 2)
	df = df[order(as.integer(tc)),]
	df$cluster = tc

	return (as.data.frame(df))
}
