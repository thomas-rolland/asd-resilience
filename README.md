# ASD resilience analyses

You will find here the python and R scripts developped for the analyses reported in Rolland et al. in preparation.
We report here the analyses post-variant calling and quality check.
All the data are available upon request from [SFARI-base](https://sfari.org/sfari-base), [UK-Biobank](https://www.ukbiobank.ac.uk/), and downloadable from [the Autism Sequencing Consortium](https://genome.emory.edu/ASC/) and [gnomAD](https://gnomad.broadinstitute.org/downloads). The full variant calling and quality control pipeline is described in details in the manuscript.

## Software requirements
* pandas
* numpy


## Data requirements

A tabular dataframe containing the variants with at least the following columns:
- chromosome
- position
- ref
- alt
- consequence
- gene_symbol *(official HGNC gene symbol)*
- iid *(individual id)*
- transmission *(denovo, father, mother, unknown)

A tabular dataframe listing the individuals wit a least the following columns:
- iid *(individual id)*
- status *(1-control, 2-case)*
- 
