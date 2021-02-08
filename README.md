# ASD resilience analyses

You will find here the python and R scripts developped for the analyses reported in Rolland et al. in preparation.
We report here the analyses post-variant calling and quality check.
All the data are available upon request from [SFARI-base](https://sfari.org/sfari-base), [UK-Biobank](https://www.ukbiobank.ac.uk/), [the Autism Sequencing Consortium](https://genome.emory.edu/ASC/) and [gnomAD](https://gnomad.broadinstitute.org/downloads), and the calling pipeline is described in details in the manuscript.

## Software requirements
* pandas
* numpy


## Data requirements

A tabular dataframe containing the variants with at least the following columns:
- chromosome
- position
- ref
- alt
- gene
