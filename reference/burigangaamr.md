# Antibiotic susceptibility of Pseudomonas aeruginosa isolates from the Buriganga River

Zone diameters and interpretations of the Kirby-Bauer disc diffusion
test for 50 Pseudomonas aeruginosa isolates from surface water at seven
sites along the Buriganga River, Bangladesh, tested against nine
antibiotics (450 observations). Tidied from the supplementary tables S3
and S4 of Sharif et al. (2024), doi:10.2166/wh.2024.270, CC BY 4.0.

## Usage

``` r
burigangaamr
```

## Format

A tibble with 450 rows and 8 variables

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

- antibiotic_code:

  Short code of the antibiotic disc as used in the supplement: PIT, CTX,
  CPM, GEN, AK, MRP, IPM, TE or CIP.

- antibiotic:

  Name of the antibiotic.

- antibiotic_class:

  Class of the antibiotic: Penicillins, Cephalosporins, Aminoglycosides,
  Carbapenems, Tetracyclines or Fluoroquinolones.

- disc_content:

  Amount of antibiotic on the disc used in the Kirby-Bauer disc
  diffusion test, in micrograms, as given in the supplement (100/10 µg
  for piperacillin-tazobactam).

- zone_mm:

  Diameter of the zone of inhibition around the disc in millimetres,
  from supplementary table S3. NA where the supplement shows a dash,
  which means no zone of inhibition was recorded; every such test is
  interpreted as resistant.

- interpretation:

  Interpretation of the zone diameter against the breakpoints in
  burigangaamr_antibiotics, as given in supplementary table S4:
  susceptible, intermediate or resistant.

## Source

Sharif, D. I., Amin, F., Mehbub, M. H. and Ratul, R. I. (2024).
Distribution and antibiotic resistance patterns of Pseudomonas
aeruginosa across different point sources of pollution in the Buriganga
River, Bangladesh. Journal of Water and Health, 22(12), supplementary
tables S3 and S4. <https://doi.org/10.2166/wh.2024.270>, CC BY 4.0.

## Examples

``` r
head(burigangaamr)
#> # A tibble: 6 × 8
#>   isolate_id site  antibiotic_code antibiotic      antibiotic_class disc_content
#>   <chr>      <fct> <fct>           <chr>           <fct>            <chr>       
#> 1 A1a        A     PIT             Piperacillin-t… Penicillins      100/10 µg   
#> 2 A1a        A     CTX             Cefotaxime      Cephalosporins   30 µg       
#> 3 A1a        A     CPM             Cefepime        Cephalosporins   30 µg       
#> 4 A1a        A     GEN             Gentamicin      Aminoglycosides  10 µg       
#> 5 A1a        A     AK              Amikacin        Aminoglycosides  30 µg       
#> 6 A1a        A     MRP             Meropenem       Carbapenems      10 µg       
#> # ℹ 2 more variables: zone_mm <int>, interpretation <fct>
# interpretations per antibiotic
table(burigangaamr$antibiotic_code, burigangaamr$interpretation)
#>      
#>       susceptible intermediate resistant
#>   PIT          50            0         0
#>   CTX           2            4        44
#>   CPM          23            3        24
#>   GEN          49            1         0
#>   AK           46            3         1
#>   MRP          47            1         2
#>   IPM          48            0         2
#>   TE            2            4        44
#>   CIP          31            7        12
```
