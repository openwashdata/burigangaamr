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

  Sampling site along the Buriganga River, coded A to G as in the
  supplement. The article describes seven sites that differ in their
  point source of pollution (industrial, medical waste and municipal
  waste discharges among them); the supplement does not name them.

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
