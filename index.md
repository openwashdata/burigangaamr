# burigangaamr

The goal of burigangaamr is to provide the antibiotic susceptibility
test results of 50 *Pseudomonas aeruginosa* isolates from surface water
at seven sites along the Buriganga River, Bangladesh, sampled from March
to May 2023, as tidy data. The isolates were tested against nine
antibiotics with the Kirby-Bauer disc diffusion method. The data are
republished from the supplementary tables of Sharif, Amin, Mehbub and
Ratul (2024), published under CC BY 4.0 in the Journal of Water and
Health (see Source and changes below).

**Draft.** This package is not released, has no DOI and may still
change. The original authors will be notified before the first release.

## Installation

You can install the development version of burigangaamr from
[GitHub](https://github.com/) with:

``` r

# install.packages("devtools")
devtools::install_github("openwashdata/burigangaamr")
```

``` r

## Run the following code in console if you don't have the packages
## install.packages(c("dplyr", "knitr", "readr", "stringr", "gt", "kableExtra"))
library(dplyr)
library(knitr)
library(readr)
library(stringr)
library(gt)
library(kableExtra)
```

Alternatively, you can download the individual datasets as a CSV or XLSX
file from the table below.

1.  Click Download CSV. A window opens that displays the CSV in your
    browser.
2.  Right-click anywhere inside the window and select “Save Page As…”.
3.  Save the file in a folder of your choice.

| dataset | CSV | XLSX |
|:---|:---|:---|
| burigangaamr_antibiotics | [Download CSV](https://github.com/openwashdata/burigangaamr/raw/main/inst/extdata/burigangaamr_antibiotics.csv) | [Download XLSX](https://github.com/openwashdata/burigangaamr/raw/main/inst/extdata/burigangaamr_antibiotics.xlsx) |
| burigangaamr_isolates | [Download CSV](https://github.com/openwashdata/burigangaamr/raw/main/inst/extdata/burigangaamr_isolates.csv) | [Download XLSX](https://github.com/openwashdata/burigangaamr/raw/main/inst/extdata/burigangaamr_isolates.xlsx) |
| burigangaamr | [Download CSV](https://github.com/openwashdata/burigangaamr/raw/main/inst/extdata/burigangaamr.csv) | [Download XLSX](https://github.com/openwashdata/burigangaamr/raw/main/inst/extdata/burigangaamr.xlsx) |

## Data

The package provides access to three data objects. `burigangaamr` holds
one row per isolate and antibiotic, `burigangaamr_isolates` one row per
isolate, and `burigangaamr_antibiotics` one row per antibiotic with the
breakpoints used to interpret the zone diameters.

``` r

library(burigangaamr)
```

### burigangaamr

The dataset `burigangaamr` contains the zone diameter and its
interpretation (susceptible, intermediate or resistant) for every
isolate and antibiotic. It has 450 observations and 8 variables

``` r

burigangaamr |> 
  head(3) |> 
  gt::gt() |>
  gt::as_raw_html()
```

| isolate_id | site | antibiotic_code | antibiotic | antibiotic_class | disc_content | zone_mm | interpretation |
|:---|:--:|:--:|:---|:--:|:---|---:|:--:|
| A1a | A | PIT | Piperacillin-tazobactam | Penicillins | 100/10 µg | 29 | susceptible |
| A1a | A | CTX | Cefotaxime | Cephalosporins | 30 µg | NA | resistant |
| A1a | A | CPM | Cefepime | Cephalosporins | 30 µg | 23 | susceptible |

For an overview of the variable names, see the following table.

| variable_name | variable_type | description |
|:---|:---|:---|
| isolate_id | character | Identifier of the Pseudomonas aeruginosa isolate as used in the supplement: the sampling site letter (A to G), the water sample number at that site (1 to 3) and the colony letter (a to d), for example A1a. |
| site | factor | Sampling site along the Buriganga River between Sadar Ghat and Midford Ghat, coded A to G as in the supplement. The article (Table 2) describes each site by the nearby source of pollution: A plastic waste and oil spills, B ship dockyard, C household waste, D sewage water of Dhaka City, E medical waste, F chemical waste of mills and factories, G boat dockyard. |
| antibiotic_code | factor | Short code of the antibiotic disc as used in the supplement: PIT, CTX, CPM, GEN, AK, MRP, IPM, TE or CIP. |
| antibiotic | character | Name of the antibiotic. |
| antibiotic_class | factor | Class of the antibiotic: Penicillins, Cephalosporins, Aminoglycosides, Carbapenems, Tetracyclines or Fluoroquinolones. |
| disc_content | character | Amount of antibiotic on the disc used in the Kirby-Bauer disc diffusion test, in micrograms, as given in the supplement (100/10 µg for piperacillin-tazobactam). |
| zone_mm | integer | Diameter of the zone of inhibition around the disc in millimetres, from supplementary table S3. NA where the supplement shows a dash, which means no zone of inhibition was recorded; every such test is interpreted as resistant. |
| interpretation | factor | Interpretation of the zone diameter against the breakpoints in burigangaamr_antibiotics, as given in supplementary table S4: susceptible, intermediate or resistant. |

### burigangaamr_isolates

The dataset `burigangaamr_isolates` contains one row per isolate with
the number of resistant and intermediate results, the number of
antibiotic classes with resistance, the antibiotics listed as
nonsusceptible in the supplement and the multidrug resistance flag. It
has 50 observations and 7 variables

``` r

burigangaamr_isolates |> 
  head(3) |> 
  gt::gt() |>
  gt::as_raw_html()
```

| isolate_id | site | n_resistant | n_intermediate | n_classes_resistant | nonsusceptible_antibiotics | multidrug_resistant |
|:---|:--:|---:|---:|---:|:---|:--:|
| A1a | A | 2 | 1 | 2 | CIP, TE, CTX | FALSE |
| A1b | A | 2 | 0 | 2 | TE, CTX | FALSE |
| A1c | A | 2 | 1 | 2 | CPM, TE, CTX | FALSE |

For an overview of the variable names, see the following table.

| variable_name | variable_type | description |
|:---|:---|:---|
| isolate_id | character | Identifier of the Pseudomonas aeruginosa isolate as used in the supplement: the sampling site letter (A to G), the water sample number at that site (1 to 3) and the colony letter (a to d), for example A1a. |
| site | factor | Sampling site along the Buriganga River between Sadar Ghat and Midford Ghat, coded A to G as in the supplement. The article (Table 2) describes each site by the nearby source of pollution: A plastic waste and oil spills, B ship dockyard, C household waste, D sewage water of Dhaka City, E medical waste, F chemical waste of mills and factories, G boat dockyard. |
| n_resistant | integer | Number of the nine antibiotics to which the isolate is resistant, counted from the interpretations in burigangaamr. |
| n_intermediate | integer | Number of the nine antibiotics with an intermediate result, counted from the interpretations in burigangaamr. |
| n_classes_resistant | integer | Number of antibiotic classes (of six) with at least one resistant result, counted from burigangaamr. Equals the count reported per strain in supplementary table S6. |
| nonsusceptible_antibiotics | character | Codes of the antibiotics with a resistant or intermediate result, comma separated, as listed per strain in supplementary table S6. |
| multidrug_resistant | logical | Whether supplementary table S6 flags the isolate as multidrug resistant, which the article defines as resistance to three or more antibiotic classes. TRUE for 14 isolates; the abstract and table S7 count 13, the difference being isolate B1c, which is resistant to two classes. |

### burigangaamr_antibiotics

The dataset `burigangaamr_antibiotics` contains the nine antibiotics
with their class, the disc content and the zone diameter breakpoints for
resistant, intermediate and susceptible. It has 9 observations and 8
variables

``` r

burigangaamr_antibiotics |> 
  head(3) |> 
  gt::gt() |>
  gt::as_raw_html()
```

| antibiotic_code | antibiotic | antibiotic_class | disc_content | breakpoint_resistant_max | breakpoint_intermediate_min | breakpoint_intermediate_max | breakpoint_susceptible_min |
|:---|:---|:--:|:---|---:|---:|---:|---:|
| PIT | Piperacillin-tazobactam | Penicillins | 100/10 µg | 17 | 18 | 21 | 22 |
| CTX | Cefotaxime | Cephalosporins | 30 µg | 14 | 15 | 22 | 23 |
| CPM | Cefepime | Cephalosporins | 30 µg | 14 | 15 | 17 | 18 |

For an overview of the variable names, see the following table.

| variable_name | variable_type | description |
|:---|:---|:---|
| antibiotic_code | character | Short code of the antibiotic disc as used in the supplement: PIT, CTX, CPM, GEN, AK, MRP, IPM, TE or CIP. |
| antibiotic | character | Name of the antibiotic. |
| antibiotic_class | factor | Class of the antibiotic: Penicillins, Cephalosporins, Aminoglycosides, Carbapenems, Tetracyclines or Fluoroquinolones. |
| disc_content | character | Amount of antibiotic on the disc used in the Kirby-Bauer disc diffusion test, in micrograms, as given in the supplement (100/10 µg for piperacillin-tazobactam). |
| breakpoint_resistant_max | integer | Largest zone diameter in millimetres that is interpreted as resistant, from supplementary table S2. |
| breakpoint_intermediate_min | integer | Smallest zone diameter in millimetres that is interpreted as intermediate, from supplementary table S2. |
| breakpoint_intermediate_max | integer | Largest zone diameter in millimetres that is interpreted as intermediate, from supplementary table S2. |
| breakpoint_susceptible_min | integer | Smallest zone diameter in millimetres that is interpreted as susceptible, from supplementary table S2. |

## Example

The figure `resistance-shares` shows, for each antibiotic, the share of
the 50 isolates that tested susceptible, intermediate or resistant.
Resistance is concentrated in cefotaxime and tetracycline, where 88
percent of the isolates were resistant, while every isolate was
susceptible to piperacillin-tazobactam.

``` r

library(burigangaamr)
library(dplyr)
library(ggplot2)

shares <- burigangaamr |>
  count(antibiotic, interpretation) |>
  group_by(antibiotic) |>
  mutate(share = n / sum(n)) |>
  ungroup()

antibiotic_order <- shares |>
  group_by(antibiotic) |>
  summarise(resistant = sum(share[interpretation == "resistant"])) |>
  arrange(resistant) |>
  pull(antibiotic)

shares |>
  mutate(antibiotic = factor(antibiotic, levels = antibiotic_order)) |>
  ggplot(aes(x = share, y = antibiotic, fill = interpretation)) +
  geom_col() +
  scale_x_continuous(labels = scales::label_percent()) +
  scale_fill_manual(values = c(susceptible = "#5B8E7D",
                               intermediate = "#E1B12C",
                               resistant = "#B5473B")) +
  labs(x = "Share of the 50 isolates", y = NULL, fill = NULL,
       title = "Disc diffusion results per antibiotic") +
  theme_minimal()
```

![Horizontal stacked bar chart of the share of the 50 isolates that
tested susceptible, intermediate or resistant to each of the nine
antibiotics, ordered from the lowest to the highest share
resistant](reference/figures/README-resistance-shares-1.png)

## Source and changes

The data come from the supplementary material of Sharif, D. I., Amin,
F., Mehbub, M. H. and Ratul, R. I. (2024). Distribution and antibiotic
resistance patterns of *Pseudomonas aeruginosa* across different point
sources of pollution in the Buriganga River, Bangladesh. *Journal of
Water and Health*, 22(12). <https://doi.org/10.2166/wh.2024.270>. The
article and its supplement are published under the Creative Commons
Attribution 4.0 licence. The original authors are listed in the package
as data contributors; they have not reviewed this package.

We changed the material. The eight Word tables of the supplement were
read into R (the script is in `data-raw/data_processing.R`). The two
isolate by antibiotic matrices (zone diameters in table S3,
interpretations in table S4) were reshaped into one observation per
isolate and antibiotic, the antibiotic codes were expanded with names,
classes and disc contents from tables S1 and S2, the breakpoints of
table S2 were split into numbers, and the counts per isolate were
derived from the observations. Tables S5, S7 and S8 are summaries and
are not republished; the processing script reproduces every percentage
of S5 and S8 from the data.

Two statements of the supplement and the article do not agree with each
other, and the package keeps the supplement as it is:

- Table S6 flags 14 isolates as multidrug resistant, while table S7 and
  the abstract count 13. The difference is isolate B1c, which is
  resistant to two antibiotic classes.
- The abstract reports that 4 percent of the isolates (two) were
  resistant to both imipenem and meropenem; in table S4 one isolate is.
- Table S6 lists ciprofloxacin (CIP) among the nonsusceptible
  antibiotics of isolate G3a, while tables S3 and S4 record a 35 mm zone
  and a susceptible result for ciprofloxacin and a resistant result for
  cefotaxime (CTX) instead. The counts per isolate come from tables S3
  and S4; the listed codes come from table S6.

Surface water was sampled from 1 March to 15 May 2023, in the
pre-monsoon season, at seven points along the river between Sadar Ghat
and Midford Ghat, each chosen for a nearby source of pollution (article,
Methods and Table 2); 70 *P. aeruginosa* isolates were obtained and 50
of them were tested against the nine antibiotics. The site descriptions
of Table 2 are in the dictionary under `site`.

## License

Data are available as
[CC-BY](https://github.com/openwashdata/burigangaamr/blob/main/LICENSE.md).

## Citation

Please cite this package using:

``` r

citation("burigangaamr")
#> If you use this dataset, please cite both the data package and the
#> original article listed under references.
#> 
#>   Schöbitz L (2026). "burigangaamr: Antibiotic Resistance of P.
#>   aeruginosa from the Buriganga River."
#>   <https://github.com/openwashdata/burigangaamr>.
#> 
#>   Sharif D, Amin F, Mehbub M, Ratul R (2024). "Distribution and
#>   antibiotic resistance patterns of Pseudomonas aeruginosa across
#>   different point sources of pollution in the Buriganga River,
#>   Bangladesh." _Journal of Water and Health_, *22*(12), 2358-2369.
#>   doi:10.2166/wh.2024.270 <https://doi.org/10.2166/wh.2024.270>.
#> 
#> To see these entries in BibTeX format, use 'print(<citation>,
#> bibtex=TRUE)', 'toBibtex(.)', or set
#> 'options(citation.bibtex.max=999)'.
```
