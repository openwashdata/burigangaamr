# Resistance summary per Pseudomonas aeruginosa isolate

One row per isolate with the counts of resistant and intermediate
results, the number of antibiotic classes with resistance, the
antibiotics listed as nonsusceptible in supplementary table S6 and the
multidrug resistance flag of that table.

## Usage

``` r
burigangaamr_isolates
```

## Format

A tibble with 50 rows and 7 variables

- isolate_id:

  Identifier of the Pseudomonas aeruginosa isolate as used in the
  supplement: the sampling site letter (A to G), the water sample number
  at that site (1 to 3) and the colony letter (a to d), for example A1a.

- site:

  Sampling site along the Buriganga River between Sadar Ghat and Midford
  Ghat, coded A to G as in the supplement. The article (Table 2)
  describes each site by the nearby source of pollution: A plastic waste
  and oil spills, B ship dockyard, C household waste, D sewage water of
  Dhaka City, E medical waste, F chemical waste of mills and factories,
  G boat dockyard.

- n_resistant:

  Number of the nine antibiotics to which the isolate is resistant,
  counted from the interpretations in burigangaamr.

- n_intermediate:

  Number of the nine antibiotics with an intermediate result, counted
  from the interpretations in burigangaamr.

- n_classes_resistant:

  Number of antibiotic classes (of six) with at least one resistant
  result, counted from burigangaamr. Equals the count reported per
  strain in supplementary table S6.

- nonsusceptible_antibiotics:

  Codes of the antibiotics with a resistant or intermediate result,
  comma separated, as listed per strain in supplementary table S6.

- multidrug_resistant:

  Whether supplementary table S6 flags the isolate as multidrug
  resistant, which the article defines as resistance to three or more
  antibiotic classes. TRUE for 14 isolates; the abstract and table S7
  count 13, the difference being isolate B1c, which is resistant to two
  classes.

## Source

Sharif, D. I., Amin, F., Mehbub, M. H. and Ratul, R. I. (2024).
Distribution and antibiotic resistance patterns of Pseudomonas
aeruginosa across different point sources of pollution in the Buriganga
River, Bangladesh. Journal of Water and Health, 22(12), supplementary
table S6 and counts derived from tables S3 and S4.
<https://doi.org/10.2166/wh.2024.270>, CC BY 4.0.

## Examples

``` r
head(burigangaamr_isolates)
#> # A tibble: 6 × 7
#>   isolate_id site  n_resistant n_intermediate n_classes_resistant
#>   <chr>      <fct>       <int>          <int>               <int>
#> 1 A1a        A               2              1                   2
#> 2 A1b        A               2              0                   2
#> 3 A1c        A               2              1                   2
#> 4 A1d        A               3              1                   2
#> 5 A2a        A               2              0                   2
#> 6 A2b        A               1              1                   1
#> # ℹ 2 more variables: nonsusceptible_antibiotics <chr>,
#> #   multidrug_resistant <lgl>
# multidrug resistant isolates per site
table(burigangaamr_isolates$site, burigangaamr_isolates$multidrug_resistant)
#>    
#>     FALSE TRUE
#>   A     8    0
#>   B     3    1
#>   C     4    0
#>   D     4    4
#>   E     5    3
#>   F     3    5
#>   G     9    1
```
