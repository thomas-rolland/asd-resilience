
#=========================================================================
# geneClusteringMRI.R
# Functions to provide a dataframe summarizing brain volume differences between LoF carriers and non-carriers
#=========================================================================

geneClusteringMRI = function()
{
  for (gene in genes)
	{
		d$n[d$gene == gene] = length(tMRI$LoF_gene[tMRI$has_LoF == "Yes" & tMRI$RR > RR & tMRI$LoF_gene == gene])
		for (i in 10:23)
		{
			test = wilcox.test(tMRI[tMRI$has_LoF == "Yes" & tMRI$RR > RR & tMRI$LoF_gene == gene, i], tMRI[tMRI$has_LoF == "No", i], conf.int = TRUE)
			pval_sig = ""
			if (test$p.value < 0.05)
				pval_sig = "*"
			if (test$p.value < 0.01)
				pval_sig = "**"
			if (test$p.value < 0.001)
				pval_sig = "***"
			d[d$gene == gene, names(d) == paste(names(tMRI)[i], "_stat", sep = "")] = as.double(test$estimate)
			d[d$gene == gene, names(d) == paste(names(tMRI)[i], "_pval", sep = "")] = as.double(test$p.value)
			d[d$gene == gene, names(d) == paste(names(tMRI)[i], "_sig", sep = "")] = pval_sig
		}
	}
	for (i in 1:dim(d)[2])
	{
		if (grepl("stat", names(d)[i]) | grepl("pval", names(d)[i]))
			d[, i] = as.double(d[, i])
		else
			d[, i] = as.character(d[, i])
	}

	d = as.data.frame(cbind(d, micro = NA, macro = NA, color = NA))
	d$macro[d$gene %in% macroceph$Gene] = "darkorange3"
	d$micro[d$gene %in% microceph$Gene & ! d$gene %in% macroceph$Gene] = "darkblue"
	d$color[!is.na(d$macro)] = "darkorange3"
	d$color[!is.na(d$micro)] = "darkblue"
	d$color[is.na(d$micro) & is.na(d$macro)] = "black"

	d_tmp = d[d$n > 0,]
	# Clustering genes
	dd <- dist(as.data.frame(d_tmp[, 3:16]), method = "euclidean")
	hc <- hclust(dd, method = "ward.D2")
	# tc = cutreeDynamic(hc, minClusterSize = 1, method = "tree", deepSplit = 1)
	tc = cutree(hc, k = 2)
	colors = brewer.pal(n = max(tc) + 1, name = "Set1")
	tc_colors = rep(0, length(tc))
	for (i in 1:length(tc))
		tc_colors[i] = colors[tc[i] + 1]
	d_tmp = d_tmp[order(as.integer(tc)),]
	tc_genes_colors = tc_colors[order(as.integer(tc))]
	# Clustering regions
	dd <- dist(as.data.frame(t(d_tmp[, c(3, seq(5, 16))])), method = "euclidean")
	hc <- hclust(dd, method = "ward.D2")
	# tc = cutreeDynamic(hc, minClusterSize = 1, method = "tree", deepSplit = 1)
	tc = cutree(hc, k = 3)
	colors = brewer.pal(n = max(tc) + 1, name = "Set2")
	tc_colors = rep(0, length(tc))
	for (i in 1:length(tc))
		tc_colors[i] = colors[tc[i] + 1]
	tmp = d_tmp[, c(3, seq(5, 16))]
	tmp = tmp[,order(as.integer(tc))]
	d_tmp[, 3] = d_tmp[, 4]
	d_tmp[, 4:16] = tmp
	for (i in 3:16)
		d_tmp[,i] = as.double(d_tmp[,i])
	colnames(d_tmp)[3] = colnames(d_tmp)[4]
	colnames(d_tmp)[4:16] = names(tmp)
	tc_regions_colors = c("white", tc_colors[order(as.integer(tc))])


	pdf(paste("../data_new/10_", VARIANT_TYPE, "_MRI_UKB_RR", RR, "_heatmap.pdf", sep = ""), 15, 15)

	pal <- colorRampPalette(c("darkblue", "white", "darkorange3"))(100)
	h = heatmap.2(as.matrix(d_tmp[, 3:16]),
						Rowv = FALSE, Colv = FALSE, dendrogram = "none",
						col = pal,
						labRow = paste(d_tmp[, 1], " (n=", as.character(d_tmp$n), ")", sep = ""),
						labCol = names(d_tmp)[3:16],
						trace = "none", density.info = "none",
						cellnote = d_tmp[, 31:44], notecol = "black", notecex = 2,
						colRow = d_tmp$color,
						margins = c(12,8),
						RowSideColors = tc_genes_colors,
						ColSideColors = tc_regions_colors)
	dev.off()

}
