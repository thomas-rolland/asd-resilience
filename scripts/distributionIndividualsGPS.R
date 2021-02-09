
#=========================================================================
# distributionIndividualsGPS.R
# Function to plot the distribution of the fraction of individuals in GPS terciles
#=========================================================================

distrib_individual_GPS = function(individuals, column, n_quantiles, inherited, bks, colors, title)
{
{
  q = value_quantile(individuals[, column], n_quantiles)
 
  # ALL = as.double(individuals$PRS)
  # P1C = as.double(individuals$PRS[individuals$status == "P1" & individuals$inherited %in% inherited])
  # S1C = as.double(individuals$PRS[individuals$status == "S1" & individuals$pop != "UKB" & individuals$inherited %in% inherited])
  # UKC = as.double(individuals$PRS[individuals$status == "S1" & individuals$pop == "UKB" & individuals$inherited %in% inherited])
  # P1NC = as.double(individuals$PRS[individuals$status == "P1" & ! individuals$inherited %in% inherited])
  # S1NC = as.double(individuals$PRS[individuals$status == "S1" & individuals$pop != "UKB" & ! individuals$inherited %in% inherited])
  # UKNC = as.double(individuals$PRS[individuals$status == "S1" & individuals$pop == "UKB" & ! individuals$inherited %in% inherited])
  #
  # plot(0, type = "n", xlim = c(0.5, 7.5), ylim = c(0, 0.04), xlab = "Quantile", ylab = "Prevalence", axes = FALSE, main = title)
	# axis(1, at = seq(1, 7), c("<10", "<33", "<50", "All", "50<", "66<", "90<"))
	# axis(2, at = seq(0, 0.04, 0.01), seq(0, 4, 1))
  #
  # ind = 1
  # for (k in c(11, 34, 51))
  # {
  #   points(ind-0.2, length(P1C[P1C < q[k]]) / (length(P1C[P1C < q[k]]) + length(P1NC[P1NC < q[k]])), col = "black", pch = 19)
  #   p = length(P1C[P1C < q[k]]) / (length(P1C[P1C < q[k]]) + length(P1NC[P1NC < q[k]]))
  #   sep = sqrt(p * (1 - p) / (length(P1C[P1C < q[k]]) + length(P1NC[P1NC < q[k]])))
  #   lines(c(ind-0.2, ind-0.2), c(p - sep, p + sep), col = "black")
  #   points(ind, length(S1C[S1C < q[k]]) / (length(S1C[S1C < q[k]]) + length(S1NC[S1NC < q[k]])), col = "black", pch = 15)
  #   p = length(S1C[S1C < q[k]]) / (length(S1C[S1C < q[k]]) + length(S1NC[S1NC < q[k]]))
  #   sep = sqrt(p * (1 - p) / (length(S1C[S1C < q[k]]) + length(S1NC[S1NC < q[k]])))
  #   lines(c(ind, ind), c(p - sep, p + sep), col = "black")
  #   points(ind+0.2, length(UKC[UKC < q[k]]) / (length(UKC[UKC < q[k]]) + length(UKNC[UKNC < q[k]])), col = "black", pch = 17)
  #   p = length(UKC[UKC < q[k]]) / (length(UKC[UKC < q[k]]) + length(UKNC[UKNC < q[k]]))
  #   sep = sqrt(p * (1 - p) / (length(UKC[UKC < q[k]]) + length(UKNC[UKNC < q[k]])))
  #   lines(c(ind+0.2, ind+0.2), c(p - sep, p + sep), col = "black")
  #   ind = ind + 1
  # }
  # points(ind-0.2, length(P1C) / (length(P1C) + length(P1NC)), col = "black", pch = 19)
  # lines(c(0.5, 7.5), c(length(P1C) / (length(P1C) + length(P1NC)), length(P1C) / (length(P1C) + length(P1NC))), lty = 3, col = "black")
  # p = length(P1C) / (length(P1C) + length(P1NC))
  # print (c("P1", length(P1C), length(P1NC)))
  # sep = sqrt(p * (1 - p) / (length(P1C) + length(P1NC)))
  # lines(c(ind-0.2, ind-0.2), c(p - sep, p + sep), col = "black")
  # points(ind, length(S1C) / (length(S1C) + length(S1NC)), col = "black", pch = 15)
  # lines(c(0.5, 7.5), c(length(S1C) / (length(S1C) + length(S1NC)), length(S1C) / (length(S1C) + length(S1NC))), lty = 3, col = "black")
  # p = length(S1C) / (length(S1C) + length(S1NC))
  # print (c("S1", length(S1C), length(S1NC)))
  # sep = sqrt(p * (1 - p) / (length(S1C) + length(S1NC)))
  # lines(c(ind, ind), c(p - sep, p + sep), col = "black")
  # points(ind+0.2, length(UKC) / (length(UKC) + length(UKNC)), col = "black", pch = 17)
  # lines(c(0.5, 7.5), c(length(UKC) / (length(UKC) + length(UKNC)), length(UKC) / (length(UKC) + length(UKNC))), lty = 3, col = "black")
  # p = length(UKC) / (length(UKC) + length(UKNC))
  # print (c("UK", length(UKC), length(UKNC)))
  # sep = sqrt(p * (1 - p) / (length(UKC) + length(UKNC)))
  # lines(c(ind+0.2, ind+0.2), c(p - sep, p + sep), col = "black")
  # ind = ind + 1
  # for (k in c(51, 67, 91))
  # {
  #   points(ind-0.2, length(P1C[P1C > q[k]]) / (length(P1C[P1C > q[k]]) + length(P1NC[P1NC > q[k]])), col = "black", pch = 19)
  #   p = length(P1C[P1C > q[k]]) / (length(P1C[P1C > q[k]]) + length(P1NC[P1NC > q[k]]))
  #   if (k == 67)
  #     print (c("P1", length(P1C[P1C > q[k]]), (length(P1NC[P1NC > q[k]]))))
  #   sep = sqrt(p * (1 - p) / (length(P1C[P1C > q[k]]) + length(P1NC[P1NC > q[k]])))
  #   lines(c(ind-0.2, ind-0.2), c(p - sep, p + sep), col = "black")
  #   points(ind, length(S1C[S1C > q[k]]) / (length(S1C[S1C > q[k]]) + length(S1NC[S1NC > q[k]])), col = "black", pch = 15)
  #   p = length(S1C[S1C > q[k]]) / (length(S1C[S1C > q[k]]) + length(S1NC[S1NC > q[k]]))
  #   if (k == 67)
  #     print (c("S1", length(S1C[S1C > q[k]]), (length(S1NC[S1NC > q[k]]))))
  #   sep = sqrt(p * (1 - p) / (length(S1C[S1C > q[k]]) + length(S1NC[S1NC > q[k]])))
  #   lines(c(ind, ind), c(p - sep, p + sep), col = "black")
  #   points(ind+0.2, length(UKC[UKC > q[k]]) / (length(UKC[UKC > q[k]]) + length(UKNC[UKNC > q[k]])), col = "black", pch = 17)
  #   p = length(UKC[UKC > q[k]]) / (length(UKC[UKC > q[k]]) + length(UKNC[UKNC > q[k]]))
  #   if (k == 67)
  #     print (c("UK", length(UKC[UKC > q[k]]), (length(UKNC[UKNC > q[k]]))))
  #   sep = sqrt(p * (1 - p) / (length(UKC[UKC > q[k]]) + length(UKNC[UKNC > q[k]])))
  #   lines(c(ind+0.2, ind+0.2), c(p - sep, p + sep), col = "black")
  #   ind = ind + 1
  # }

	mP1 = matrix(nrow = length(q) - 1, ncol = 1)
	mP1no = matrix(nrow = length(q) - 1, ncol = 1)
	mS1 = matrix(nrow = length(q) - 1, ncol = 1)
	mS1no = matrix(nrow = length(q) - 1, ncol = 1)
	mUK = matrix(nrow = length(q) - 1, ncol = 1)
	mUKno = matrix(nrow = length(q) - 1, ncol = 1)

	for (i in 2:length(q))
	{
		mP1[i - 1, 1] = length(unique(as.character(individuals$IID[! is.na(individuals[, column]) & individuals[, column] >= qP1[i - 1] & individuals[, column] < qP1[i] & individuals$status == "P1" & individuals$inherited %in% inherited])))
		mP1no[i - 1, 1] = length(unique(as.character(individuals$IID[! is.na(individuals[, column]) & individuals[, column] >= qP1[i - 1] & individuals[, column] < qP1[i] & individuals$status == "P1" & individuals$inherited == "none"])))
		mS1[i - 1, 1] = length(unique(as.character(individuals$IID[! is.na(individuals[, column]) & individuals[, column] >= qS1[i - 1] & individuals[, column] < qS1[i] & individuals$status != "P1" & individuals$pop != "UKB" & individuals$inherited %in% inherited])))
		mS1no[i - 1, 1] = length(unique(as.character(individuals$IID[! is.na(individuals[, column]) & individuals[, column] >= qS1[i - 1] & individuals[, column] < qS1[i] & individuals$status != "P1" & individuals$pop != "UKB" & individuals$inherited == "none"])))
		mUK[i - 1, 1] = length(unique(as.character(individuals$IID[! is.na(individuals[, column]) & individuals[, column] >= qUK[i - 1] & individuals[, column] < qUK[i] & individuals$status == "S1" & individuals$pop == "UKB" & individuals$inherited %in% inherited])))
		mUKno[i - 1, 1] = length(unique(as.character(individuals$IID[! is.na(individuals[, column]) & individuals[, column] >= qUK[i - 1] & individuals[, column] < qUK[i] & individuals$status == "S1" & individuals$pop == "UKB" & individuals$inherited == "none"])))
	}
  print (c("Total P1", sum(mP1)))
  print (c("Total S1", sum(mS1)))
  print (c("Total UK", sum(mUK)))

	# f_P1 = rep(NA, length(q) - 1)
  # sep_P1 = rep(NA, length(q) - 1)
	# f_S1 = rep(NA, length(q) - 1)
  # sep_S1 = rep(NA, length(q) - 1)
  # OR_S1 = rep(NA, length(q) - 1)
	# f_UK = rep(NA, length(q) - 1)
  # sep_UK = rep(NA, length(q) - 1)
  # OR_UK = rep(NA, length(q) - 1)

	# for (i in 2:length(q))
	# {
  #   f_P1[i - 1] = mP1[i - 1, 1] / sum(mP1[, 1])
  #   sep_P1[i - 1] = sqrt((f_P1[i - 1] * (1 - f_P1[i - 1])) / sum(mP1[, 1]))
	# 	f_S1[i - 1] = mS1[i - 1, 1] / sum(mS1[, 1])
  #   sep_S1[i - 1] = sqrt((f_S1[i - 1] * (1 - f_S1[i - 1])) / sum(mS1[, 1]))
  #   test = fisher.test(matrix(nrow = 2, ncol = 2, data = c(mS1[i - 1, 1], sum(mS1[, 1]) - mS1[i - 1, 1], mP1[i - 1, 1], sum(mP1[, 1]) - mP1[i - 1, 1])))
  #   if (i == length(q))
  #     test = fisher.test(matrix(nrow = 2, ncol = 2, data = c(mP1[i - 1, 1], sum(mP1[, 1]) - mP1[i - 1, 1], mS1[i - 1, 1], sum(mS1[, 1]) - mS1[i - 1, 1])))
  #   OR_S1[i - 1] = paste("OR=", format(test$estimate, digits = 2), "\np=", format(test$p.value, digits = 2), sep = "")
  #   f_UK[i - 1] = mUK[i - 1, 1] / sum(mUK[, 1])
  #   sep_UK[i - 1] = sqrt((f_UK[i - 1] * (1 - f_UK[i - 1])) / sum(mUK[, 1]))
  #   test = fisher.test(matrix(nrow = 2, ncol = 2, data = c(mUK[i - 1, 1], sum(mUK[, 1]) - mUK[i - 1, 1], mP1[i - 1, 1], sum(mP1[, 1]) - mP1[i - 1, 1])))
  #   if (i == length(q))
  #     test = fisher.test(matrix(nrow = 2, ncol = 2, data = c(mP1[i - 1, 1], sum(mP1[, 1]) - mP1[i - 1, 1], mUK[i - 1, 1], sum(mUK[, 1]) - mUK[i - 1, 1])))
  #   OR_UK[i - 1] = paste("OR=", format(test$estimate, digits = 2), "\np=", format(test$p.value, digits = 2), sep = "")
	# }

	# plot(0, type = "n", xlim = c(0.5, length(q) - 0.5), ylim = c(0, 1), xlab = "Quantile", ylab = "Fraction of carriers", axes = FALSE, main = title)
	# axis(1, at = seq(1, length(q) - 1), seq(1, length(q) - 1))
	# axis(2, at = seq(0, 1, 0.2), seq(0, 1, 0.2))
	# points(seq(1, length(q) - 1) + bks[1], f_P1, pch = 19, col = colors[1])
	# points(seq(1, length(q) - 1) + bks[2], f_S1, pch = 15, col = colors[2])
	# points(seq(1, length(q) - 1) + bks[3], f_UK, pch = 17, col = colors[3])
  #
  # for (i in seq(1, length(q) - 1))
  # {
  #   lines(c(i + bks[1], i + bks[1]), c(f_P1[i] - sep_P1[i], f_P1[i] + sep_P1[i]), col = colors[1])
  #   lines(c(i + bks[2], i + bks[2]), c(f_S1[i] - sep_S1[i], f_S1[i] + sep_S1[i]), col = colors[2])
  #   lines(c(i + bks[3], i + bks[3]), c(f_UK[i] - sep_UK[i], f_UK[i] + sep_UK[i]), col = colors[3])
  #
  #   text(i + bks[2], f_S1[i] + sep_S1[i] + 0.005, OR_S1[i])
  #   text(i + bks[3], f_UK[i] + sep_UK[i] + 0.005, OR_UK[i])
  # }

  plot(0, type = "n", xlim = c(0.5, 1.5), ylim = log10(c(0.1, 100)), xlab = "Tercile", ylab = "Odds ratio", axes = FALSE, main = title)
	axis(1, at = 1, "Top tercile")
	axis(2, at = log10(c(0.1, 1, 10, 100)), c(0.1, 1, 10, 100))
  lines(c(0.5, 1.5), log10(c(1, 1)), lty = 3)

  test = fisher.test(matrix(nrow = 2, ncol = 2, data = c(mP1[length(q) - 1, 1], sum(mP1[, 1]) - mP1[length(q) - 1, 1], mS1[length(q) - 1, 1], sum(mS1[, 1]) - mS1[length(q) - 1, 1])))
  points(1 + bks[2], log10(test$estimate), pch = 15, col = colors[2])
  lines(c(1 + bks[2], 1 + bks[2]), log10(c(test$conf.int[1], test$conf.int[2])), col = colors[2])

  print (c(test$conf.int[1], test$conf.int[2]))

  test = fisher.test(matrix(nrow = 2, ncol = 2, data = c(mP1[length(q) - 1, 1], sum(mP1[, 1]) - mP1[length(q) - 1, 1], mUK[length(q) - 1, 1], sum(mUK[, 1]) - mUK[length(q) - 1, 1])))
  points(1 + bks[3], log10(test$estimate), pch = 17, col = colors[3])
  lines(c(1 + bks[3], 1 + bks[3]), log10(c(test$conf.int[1], test$conf.int[2])), col = colors[3])

	# legend("bottomleft", box.lty = 0, pch = c(19, 19, 17), col = colors, c("Affected - ASD population", "Unaffected - ASD population", "Unaffected - UKB population"))

	# return (cbind(f_P1, f_S1, f_UK))
}

