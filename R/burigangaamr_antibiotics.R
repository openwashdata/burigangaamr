#' Antibiotics tested and their zone diameter breakpoints
#' 
#' The nine antibiotics of the disc diffusion test with their class, disc content and the zone diameter breakpoints used to interpret the results, from supplementary tables S1 and S2.
#' 
#' @format A tibble with 9 rows and 8 variables
#' \describe{
#'   \item{antibiotic_code}{Short code of the antibiotic disc as used in the supplement: PIT, CTX, CPM, GEN, AK, MRP, IPM, TE or CIP.}
#'   \item{antibiotic}{Name of the antibiotic.}
#'   \item{antibiotic_class}{Class of the antibiotic: Penicillins, Cephalosporins, Aminoglycosides, Carbapenems, Tetracyclines or Fluoroquinolones.}
#'   \item{disc_content}{Amount of antibiotic on the disc used in the Kirby-Bauer disc diffusion test, in micrograms, as given in the supplement (100/10 µg for piperacillin-tazobactam).}
#'   \item{breakpoint_resistant_max}{Largest zone diameter in millimetres that is interpreted as resistant, from supplementary table S2.}
#'   \item{breakpoint_intermediate_min}{Smallest zone diameter in millimetres that is interpreted as intermediate, from supplementary table S2.}
#'   \item{breakpoint_intermediate_max}{Largest zone diameter in millimetres that is interpreted as intermediate, from supplementary table S2.}
#'   \item{breakpoint_susceptible_min}{Smallest zone diameter in millimetres that is interpreted as susceptible, from supplementary table S2.}
#' }
#' @source Sharif, D. I., Amin, F., Mehbub, M. H. and Ratul, R. I. (2024). Distribution and antibiotic resistance patterns of Pseudomonas aeruginosa across different point sources of pollution in the Buriganga River, Bangladesh. Journal of Water and Health, 22(12), supplementary tables S1 and S2. <https://doi.org/10.2166/wh.2024.270>, CC BY 4.0.
"burigangaamr_antibiotics"
