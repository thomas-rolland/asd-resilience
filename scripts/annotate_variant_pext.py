#!/bin/python3
# Author: Thomas Rolland	jerikoo75@gmail.com

#=========================================================================
# annotate_variant_pext.py
# Get pext score for each variant of tabular file
#=========================================================================

import pandas as pd
from numpy import mean
from pyliftover import LiftOver

input_file = "variant_table.tsv"
input_pext = "all.baselevel.pext.tsv"
output_file = "variant_table_pext.tsv"

#=========================================================================
# Loading liftover because pext is on hg19
#=========================================================================
lo = LiftOver('hg38', 'hg19')

#=========================================================================
# Loading hg38-based variants into dataframe and create column with hg19 position
#=========================================================================
VCF = pd.read_csv(input_file, sep = "\t", dtype = str)
VCF["hg19_position"] = "NA"
for i in range(0, VCF.shape[0]):
	position = int(VCF["position"][i])
	if (VCF["consequence"][i] == "splice_donor_variant"):
		if VCF["strand"][i] == "1":
			position = position - 3
		else:
			position = position + 3
	if (VCF["consequence"][i] == "splice_acceptor_variant"):
		if VCF["strand"][i] == "1":
			position = position + 3
		else:
			position = position - 3
	hg19_position = lo.convert_coordinate('chr' + VCF["chromosome"][i], position)[0][1]
	VCF["hg19_position"][i] = str(hg19_position)
vcf = pd.DataFrame(pd.concat([VCF["chromosome"].reset_index(drop=True), VCF["hg19_position"].reset_index(drop=True), VCF["ref"].reset_index(drop=True), VCF["alt"].reset_index(drop=True), VCF["consequence"].reset_index(drop=True), VCF["gene"].reset_index(drop=True)], axis = 1))
vcf.columns = "chromosome position ref alt consequence gene".split()
vcf["chrpos"] = vcf["chromosome"] + ":" + vcf["position"]
vcf = vcf.drop_duplicates()
print ("\tVCF variants:", VCF.shape, "unique:", vcf.shape)

# Loading pext (114,944,599 lines)
print ("Loading pext ...")
brain = ["Brain_FrontalCortex_BA9_", "Brain_Hippocampus", "Brain_Nucleusaccumbens_basalganglia_", "Brain_Spinalcord_cervicalc_1_", "Brain_CerebellarHemisphere", "Brain_Cerebellum", "Brain_Cortex", "Brain_Substantianigra", "Brain_Anteriorcingulatecortex_BA24_", "Brain_Putamen_basalganglia_", "Brain_Caudate_basalganglia_", "Brain_Amygdala"]
#brain = [8, 14, 16, 18, 21, 22, 40, 41, 43, 49, 50, 51, 57]
n_annots = 10
len_of_annot = 59
iter_csv = pd.read_csv(input_pext, iterator = True, chunksize = 1000000, sep = "\t", dtype = str)
all_variants = pd.DataFrame()
for chunk in iter_csv:
	print (chunk.shape)
	position = chunk["locus"].str.split(':', n = 2, expand = True)
	chunk["chr"] = position[0]
	chunk["position"] = position[1]
	chunk["chrpos"] = chunk["chr"] + ":" + chunk["position"]
	chunk = chunk[chunk["chrpos"].isin(vcf["chrpos"])].reset_index(drop=True)
	if (chunk.shape[0] == 0):
		continue

	print ("Found some variants:", chunk.shape)
	chunk["pext"] = "NA"
	for i in range(0, chunk.shape[0]):
		mn = []
		for j in brain:
			if (pd.isna(chunk[j][i])):
				continue
			value = chunk[j][i]
			if (value != "NaN"):
				mn.append(float(value))
		if len(mn) > 0:
			chunk["pext"][i] = max(mn)
	chunk = pd.DataFrame(pd.concat([chunk["chr"].reset_index(drop = True), chunk["position"].reset_index(drop = True), chunk["pext"].reset_index(drop = True), chunk["chrpos"].reset_index(drop = True)], axis = 1))
	all_variants = pd.concat([all_variants, chunk])
	all_variants = all_variants.drop_duplicates()

	print ("All variants with pext :", all_variants.shape)

# Matching to original VCF file
print ("Matching to original VCF file ...")
VCF["chrpos_hg19"] = VCF["chromosome"] + ":" + VCF["hg19_position"]
VCF["pext"] = "NA"
for i in range(0, VCF.shape[0]):
	if (len(all_variants["pext"][all_variants["chrpos"].isin([VCF["chrpos_hg19"][i]])]) > 0):
		VCF["pext"][i] = all_variants["pext"][all_variants["chrpos"].isin([VCF["chrpos_hg19"][i]])].reset_index(drop=True)[0]
VCF.to_csv(output_file, sep = "\t", header = True, index = False)
