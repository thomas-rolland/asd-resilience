# ASD resilience analyses

You will find here the python and R scripts developped for the post-processing analyses reported in Rolland et al. in preparation:
- Annotating variants with pext score
- Attributable risk and relative risk
- Linear and ordinal regression between risk and socio-economic features in UK-Biobank
- Clustering of genes and brain regions based on MRI-derived brain volumes in UK-Biobank
- Distribution of individuals in terciles of ASD-PGS scores

All raw genetic data are available upon request from [SFARI-base](https://sfari.org/sfari-base), [UK-Biobank](https://www.ukbiobank.ac.uk/), and downloadable from [the Autism Sequencing Consortium](https://genome.emory.edu/ASC/) and [gnomAD](https://gnomad.broadinstitute.org/downloads). The full variant calling and quality control pipeline is described in details in the manuscript. All phenotypic data for SSC and SPARK cohorts are available upon request from [SFARI-base](https://sfari.org/sfari-base). All functioning/cognitive metrics and MRI-based brain volumes for UK-Biobank individuals are available upon request from [UK-Biobank](https://www.ukbiobank.ac.uk/).


## Software requirements
* pandas (https://pandas.pydata.org/)
* numpy (https://numpy.org/)
* pyliftover (https://pypi.org/project/pyliftover/)
* MASS R package (https://cran.r-project.org/web/packages/MASS/index.html)
* stats R package (https://stat.ethz.ch/R-manual/R-devel/library/stats/html/00Index.html)

## Data requirements

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
- transmission *(denovo, father, mother, unknown)*

#### A tabular file listing the individuals with a least the following columns -> individual_table.tsv
- iid *(individual id)*
- fid *(family id)*
- family_relationship *(proband, sibling, father, mother, unknown)*
- status *(1-control, 2-case)*
- age *(age of individual)*
- sex *(1-male, 2-female)*
- cohort *(in case multiple cohorts are analysed)*
- ASD_PGS *(z-scored polygenic score values for ASD)*

*Functioning/cognitive features for regression analyses amongst UK-Biobank individuals:*
- fluid_intelligence_score *(Fluid intelligence score provided by UK-Biobank)*
- townsend_index *(Townsend deprivation index provided by UK-Biobank)*
- income *(Income before tax score provided by UK-Biobank)*
- qualification *(Highest qualification level provided by UK-Biobank)*

*Brain volumes for MRI-based gene clustering amongst UK-Biobank individuals:*
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

#### A tabular file listing the sample sizes with a least the following columns -> sample_table.tsv
- cohort *(in case multiple cohorts are analysed)*
- status *(1-control, 2-case)*
- N *(number of individuals)*

#### A tabular file listing the genes of interest with a least the following column -> gene_table.tsv
- gene_symbol *(official HGNC gene symbol)*


## Annotating variants with pext score
```
annotateVariantsPext.py
```
This script will match the pext score to the tabular file containing variants.

## Attributable risk and relative risk
```
attributableRiskRelativeRisk.R
```
This script will calculate gene-level attributable risk and relative risk.


## Linear and ordinal regression between LoF presence and outcomes
```
linearOrdinalRegression.R
```
This script will provide regression coefficients associated to specific covariates, including LoF presence.


## Clustering of genes and brain regions based on MRI-derived brain volumes in UK-Biobank
```
geneClusteringMRI.R
```
This script will provide a dataframe summarizing brain volume differences between LoF carriers and non-carriers by gene.


## Distribution of individuals in terciles of ASD-PGS scores
```
distributionIndividualsGPS.R
```
This script will provide the fraction of individuals in each quantile of ASD-GPS (default to 3 quantiles).



