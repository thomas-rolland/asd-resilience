# ASD resilience analyses

You will find here the python and R scripts developped for the post-processing analyses reported in Rolland et al. in preparation:
- Annotating variants with pext score
- Attributable risk and relative risk
- Linear and ordinal regression between risk and socio-economic features in UK-Biobank
- Clustering of genes and brain regions based on MRI-derived brain volumes in UK-Biobank
- Distribution of individuals in quantiles of ASD-PGS scores

All raw genetic data are available upon request from [SFARI-base](https://sfari.org/sfari-base), [UK-Biobank](https://www.ukbiobank.ac.uk/), and downloadable from [the Autism Sequencing Consortium](https://genome.emory.edu/ASC/) and [gnomAD](https://gnomad.broadinstitute.org/downloads). The full variant calling and quality control pipeline is described in details in the manuscript. All phenotypic data for SSC and SPARK cohorts are available upon request from [SFARI-base](https://sfari.org/sfari-base). All functioning/cognitive metrics and MRI-based brain volumes for UK-Biobank individuals are available upon request from [UK-Biobank](https://www.ukbiobank.ac.uk/).


## Software requirements
* pandas python library (https://pandas.pydata.org/)
* numpy python library (https://numpy.org/)
* pyliftover python library (https://pypi.org/project/pyliftover/)
* MASS R package (https://cran.r-project.org/web/packages/MASS/index.html)
* stats R package (https://stat.ethz.ch/R-manual/R-devel/library/stats/html/00Index.html)

## Minimal data requirements

#### The base-level pext score from the gnomAD website (GRCh37, https://gnomad.broadinstitute.org/downloads#v2-pext) -> all.baselevel.pext.tsv

#### A tabular file containing the variants with at least the following columns (GRCh38) -> variant_table.tsv
- chromosome
- position
- ref
- alt
- gene_symbol *(official HGNC gene symbol)*
- consequence *(such as provided by [VEP](https://www.ensembl.org/Tools/VEP))*
- strand *(strand of the gene)*
- relative_position *(as a percentage on encoded protein, from [loftee](https://github.com/konradjk/loftee) or [vep](https://www.ensembl.org/Tools/VEP)/[biomart](https://www.ensembl.org/biomart/martview/))*
- iid *(individual id)*

#### A tabular file listing the individuals with a least the following columns -> individual_table.tsv
- iid *(individual id)*
- status *(1-control, 2-case)*
- age *(age of individual)*
- sex *(1-male, 2-female)*

#### A tabular file listing the sample sizes with a least the following columns -> sample_table.tsv
- cohort *(in case multiple cohorts are analysed)*
- status *(1-control, 2-case)*
- N *(number of individuals)*

#### A tabular file listing the genes of interest with a least the following column -> gene_table.tsv
- gene_symbol *(official HGNC gene symbol)*


## Additional data requirements for specific analyses

#### A tabular file listing the individuals with a least the following columns -> outcomes_table.tsv
- iid *(individual id)*
- fluid_intelligence_score *(Fluid intelligence score provided by UK-Biobank)*
- townsend_index *(Townsend deprivation index provided by UK-Biobank)*
- income *(Income before tax score provided by UK-Biobank)*
- qualification *(Highest qualification level provided by UK-Biobank)*

#### A tabular file listing the MRI-based volumes with a least the following columns -> mri_table.tsv
- iid *(individual id)*
- IntraCranial
- TotalBrain
- CerebralCortex
- CerebralWhiteMatter
- Thalamus
- CaudateNucleus
- Putamen
- Pallidum
- Hippocampus
- Amygdala
- NucleusAccumbens
- CorpusCallosum
- CerebellumCortex
- CerebellumWhiteMatter

#### A tabular file listing the individuals with a least the following columns -> asd_gps_table.tsv
- iid *(individual id)*
- ASD_PGS *(z-scored polygenic score values for ASD)*


## Annotating variants with pext score
```
annotateVariantsPext.py
```
This script will match the pext score to the tabular file containing variants.
- Input: variant_table.tsv, all.baselevel.pext.tsv
- Output: variant_table.pext.tsv (adding hg19_position and pext columns)

## Attributable risk and relative risk
```
attributableRiskRelativeRisk.R
```
This script will calculate gene-level attributable risk and relative risk.
- Input: variant_table.pext.tsv, sample_table.tsv, gene_table.tsv, variant type (HC-R-LoF or HC-S-LoF, default to HC-S-LoF)
- Output: R dataframe with, for each gene, fraction of carriers among cases and controls, relative risk and attributable risk with 95% CI

## Linear and ordinal regression between variant presence and outcomes
```
linearOrdinalRegression.R
```
This script will provide regression coefficients associated to specific covariates and variant presence.
- Input: variant_table.pext.tsv, outcome_table.tsv, outcome of interest, vector of covariates (e.g. sex, age), variant type (HC-R-LoF or HC-S-LoF, default to HC-S-LoF)
- Output: R dataframe with regression coefficients associated to each covariate and variant presence, 95% CIs and p-value


## Clustering of genes and brain regions based on MRI-derived brain volumes in UK-Biobank
```
geneClusteringMRI.R
```
This script will provide a dataframe summarizing brain volume differences between variant carriers and non-carriers by gene.
- Input: variant_table.pext.tsv, gene_table.tsv, mri_table.tsv, variant type (HC-R-LoF or HC-S-LoF, default to HC-S-LoF)
- Output: R dataframe with, for each gene, the number of carriers, volume differences in each brain region and clustering results


## Distribution of individuals in quantiles of ASD-PGS scores
```
distributionIndividualsGPS.R
```
This script will provide the fraction of individuals in each quantile of ASD-GPS.
- Input: variant_table.pext.tsv, asd_gps_table.tsv, number of quantiles for GPS (default to 3 quantiles), carriers or not (boolean, default to TRUE), variant type (HC-R-LoF or HC-S-LoF, default to HC-S-LoF)
- Output: R dataframe with, for each quantile, the number and fraction of individuals and the standard error of the proportion



