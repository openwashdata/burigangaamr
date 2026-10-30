# Antibiotics tested and their zone diameter breakpoints

The nine antibiotics of the disc diffusion test with their class, disc
content and the zone diameter breakpoints used to interpret the results,
from supplementary tables S1 and S2.

## Usage

``` r
burigangaamr_antibiotics
```

## Format

A tibble with 9 rows and 8 variables

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

- breakpoint_resistant_max:

  Largest zone diameter in millimetres that is interpreted as resistant,
  from supplementary table S2.

- breakpoint_intermediate_min:

  Smallest zone diameter in millimetres that is interpreted as
  intermediate, from supplementary table S2.

- breakpoint_intermediate_max:

  Largest zone diameter in millimetres that is interpreted as
  intermediate, from supplementary table S2.

- breakpoint_susceptible_min:

  Smallest zone diameter in millimetres that is interpreted as
  susceptible, from supplementary table S2.

## Source

Sharif, D. I., Amin, F., Mehbub, M. H. and Ratul, R. I. (2024).
Distribution and antibiotic resistance patterns of Pseudomonas
aeruginosa across different point sources of pollution in the Buriganga
River, Bangladesh. Journal of Water and Health, 22(12), supplementary
tables S1 and S2. <https://doi.org/10.2166/wh.2024.270>, CC BY 4.0.

## Examples

``` r
burigangaamr_antibiotics
#> # A tibble: 9 × 8
#>   antibiotic_code antibiotic              antibiotic_class disc_content
#>   <chr>           <chr>                   <fct>            <chr>       
#> 1 PIT             Piperacillin-tazobactam Penicillins      100/10 µg   
#> 2 CTX             Cefotaxime              Cephalosporins   30 µg       
#> 3 CPM             Cefepime                Cephalosporins   30 µg       
#> 4 GEN             Gentamicin              Aminoglycosides  10 µg       
#> 5 AK              Amikacin                Aminoglycosides  30 µg       
#> 6 MRP             Meropenem               Carbapenems      10 µg       
#> 7 IPM             Imipenem                Carbapenems      10 µg       
#> 8 TE              Tetracycline            Tetracyclines    30 µg       
#> 9 CIP             Ciprofloxacin           Fluoroquinolones 5 µg        
#> # ℹ 4 more variables: breakpoint_resistant_max <int>,
#> #   breakpoint_intermediate_min <int>, breakpoint_intermediate_max <int>,
#> #   breakpoint_susceptible_min <int>
```
