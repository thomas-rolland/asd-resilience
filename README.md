# ASD resilience analyses

You will find here the python and R scripts developped for the analyses reported in Rolland et al. in preparation:
- Annotating variants with pext
- Attributable risk and relative risk
- Linear and ordinal regression between risk and socio-economic features in UK-Biobank
- Distribution of individuals in terciles of ASD-PGS scores

All raw genetic data are available upon request from [SFARI-base](https://sfari.org/sfari-base), [UK-Biobank](https://www.ukbiobank.ac.uk/), and downloadable from [the Autism Sequencing Consortium](https://genome.emory.edu/ASC/) and [gnomAD](https://gnomad.broadinstitute.org/downloads). The full variant calling and quality control pipeline is described in details in the manuscript. All phenotypic data for SSC and SPARK cohorts are available upon request from [SFARI-base](https://sfari.org/sfari-base). All functioning/cognitive metrics and MRI-based brain volumes for UK-Biobank individuals are available upon request from [UK-Biobank](https://www.ukbiobank.ac.uk/).

## Software requirements
* pandas (https://pandas.pydata.org/)
* numpy (https://numpy.org/)
* pyliftover (https://pypi.org/project/pyliftover/)


## Data requirements

#### The base-level pext score from the gnomAD website (https://gnomad.broadinstitute.org/downloads#v2-pext)

#### A tabular file containing the variants with at least the following columns:
- chromosome
- position
- ref
- alt
- gene_symbol *(official HGNC gene symbol)*
- consequence
- iid *(individual id)*
- transmission *(denovo, father, mother, unknown)*

#### A tabular file listing the individuals with a least the following columns:
- iid *(individual id)*
- fid *(family id)*
- family_relationship *(proband, sibling, father, mother, unknown)*
- status *(1-control, 2-case)*
- sex *(1-male, 2-female)*
- cohort *(if multiple cohorts are analysed)*
