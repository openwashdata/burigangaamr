# Description ------------------------------------------------------------------
# R script to process the supplementary tables of Sharif et al. (2024),
# "Distribution and antibiotic resistance patterns of Pseudomonas aeruginosa
# across different point sources of pollution in the Buriganga River,
# Bangladesh", Journal of Water and Health 22(12), doi:10.2166/wh.2024.270,
# CC BY 4.0, into three tidy data frames:
#   burigangaamr             one row per isolate and antibiotic (450 rows)
#   burigangaamr_isolates    one row per isolate (50 rows)
#   burigangaamr_antibiotics one row per antibiotic with its breakpoints (9 rows)
# The raw file is the Word supplement jwh0222358supp1.docx as downloaded from
# the journal (sha256 dc0d24bdea80e49503800810dd4d4ca197bebaab5a7a186a506fccf23b84bf5e).
# Its eight tables are: S1 antibiotic classes, S2 breakpoints, S3 zone
# diameters, S4 interpretations, S5 percentages per antibiotic, S6 resistance
# per strain, S7 multidrug resistant isolates per site, S8 percentages per
# site. S5, S7 and S8 are summaries and serve as checks only.
# Load packages ----------------------------------------------------------------
## Run the following code in console if you don't have the packages
## install.packages(c("usethis", "fs", "here", "readr", "openxlsx", "rvest",
##                    "dplyr", "tidyr", "stringr", "rmarkdown"))
library(usethis)
library(fs)
library(here)
library(readr)
library(openxlsx)
library(rvest)
library(dplyr)
library(tidyr)
library(stringr)

# Read data --------------------------------------------------------------------
# pandoc converts the Word file to HTML, rvest reads the tables.
docx <- here::here("data-raw", "jwh0222358supp1.docx")
html <- tempfile(fileext = ".html")
pandoc <- Sys.which("pandoc")
if (pandoc == "") pandoc <- rmarkdown::pandoc_exec()
system2(pandoc, c(shQuote(docx), "-t", "html", "-o", shQuote(html)))
tables <- rvest::html_table(rvest::read_html(html, encoding = "UTF-8"),
                            fill = TRUE, header = FALSE)
stopifnot(length(tables) == 8)

# The first row of every table is its header.
as_table <- function(tb) {
  tb <- as.data.frame(tb, stringsAsFactors = FALSE)
  names(tb) <- str_squish(str_replace_all(unlist(tb[1, ]), "\n", " "))
  tb <- tb[-1, , drop = FALSE]
  rownames(tb) <- NULL
  tb
}
t_classes  <- as_table(tables[[1]])
t_break    <- as_table(tables[[2]])
t_zone     <- as_table(tables[[3]])
t_call     <- as_table(tables[[4]])
t_pct_ab   <- as_table(tables[[5]])
t_strain   <- as_table(tables[[6]])
t_mdr_site <- as_table(tables[[7]])
t_pct_site <- as_table(tables[[8]])

# Tidy data --------------------------------------------------------------------
## Antibiotics: codes used in S3 and S4, names with disc content from S2,
## classes from S1.
codes <- c(PIT = "Piperacillin-tazobactam", CTX = "Cefotaxime",
           CPM = "Cefepime", GEN = "Gentamicin", AK = "Amikacin",
           MRP = "Meropenem", IPM = "Imipenem", TE = "Tetracycline",
           CIP = "Ciprofloxacin")

classes <- t_classes |>
  rename(antibiotic_class = 1, antibiotic_raw = 2) |>
  separate_longer_delim(antibiotic_raw, delim = ", ") |>
  mutate(antibiotic = str_squish(str_remove(antibiotic_raw, "\\s*\\(.*\\)$")),
         disc_content = str_squish(str_extract(antibiotic_raw, "(?<=\\().*(?=\\))")),
         disc_content = str_replace(disc_content, "μg$", " µg")) |>
  select(antibiotic, antibiotic_class, disc_content)

parse_le <- function(x) as.integer(str_extract(x, "\\d+"))
breakpoints <- t_break |>
  rename(antibiotic_raw = 1, resistant = 2, intermediate = 3, susceptible = 4) |>
  mutate(antibiotic = str_squish(str_remove(antibiotic_raw, "\\s*\\(.*\\)$")),
         breakpoint_resistant_max = parse_le(resistant),
         breakpoint_intermediate_min = as.integer(str_extract(intermediate, "^\\d+")),
         breakpoint_intermediate_max = as.integer(str_extract(intermediate, "\\d+$")),
         breakpoint_susceptible_min = parse_le(susceptible)) |>
  select(antibiotic, starts_with("breakpoint_"))

burigangaamr_antibiotics <- tibble(antibiotic_code = names(codes),
                                   antibiotic = unname(codes)) |>
  left_join(classes, by = "antibiotic") |>
  left_join(breakpoints, by = "antibiotic") |>
  mutate(antibiotic_class = factor(antibiotic_class,
                                   levels = unique(t_classes[[1]])))
stopifnot(nrow(burigangaamr_antibiotics) == 9,
          !anyNA(burigangaamr_antibiotics))

## One row per isolate and antibiotic: zone diameter from S3 (a dash means
## no zone of inhibition was measured), interpretation from S4. The two
## tables list the antibiotics in a different order, so both are joined by
## code.
zone_long <- t_zone |>
  rename(isolate_id = 1) |>
  pivot_longer(-isolate_id, names_to = "antibiotic_code", values_to = "zone_raw")
call_long <- t_call |>
  rename(isolate_id = 1) |>
  pivot_longer(-isolate_id, names_to = "antibiotic_code", values_to = "call")

burigangaamr <- zone_long |>
  inner_join(call_long, by = c("isolate_id", "antibiotic_code")) |>
  mutate(zone_mm = as.integer(na_if(zone_raw, "-")),
         site = str_sub(isolate_id, 1, 1),
         interpretation = factor(unname(c(S = "susceptible", I = "intermediate",
                                          R = "resistant")[call]),
                                 levels = c("susceptible", "intermediate",
                                            "resistant"))) |>
  left_join(burigangaamr_antibiotics, by = "antibiotic_code") |>
  mutate(site = factor(site, levels = LETTERS[1:7]),
         antibiotic_code = factor(antibiotic_code, levels = names(codes))) |>
  select(isolate_id, site, antibiotic_code, antibiotic, antibiotic_class,
         disc_content, zone_mm, interpretation) |>
  arrange(isolate_id, antibiotic_code)
stopifnot(nrow(burigangaamr) == 450,
          !anyNA(burigangaamr$interpretation),
          n_distinct(burigangaamr$isolate_id) == 50)

## One row per isolate: the counts reported in S6 and derived from the long
## table, the multidrug resistant flag of S6.
reported <- t_strain |>
  rename(isolate_id = 1, resistant_raw = 2, mdr_raw = 3) |>
  mutate(n_resistant_reported = as.integer(str_extract(resistant_raw, "^\\d+")),
         nonsusceptible_antibiotics = str_squish(str_remove_all(
           str_extract(resistant_raw, "\\(.*\\)"), "[()]")),
         multidrug_resistant = mdr_raw == "Yes") |>
  select(isolate_id, n_resistant_reported, nonsusceptible_antibiotics,
         multidrug_resistant)

derived <- burigangaamr |>
  group_by(isolate_id, site) |>
  summarise(n_resistant = sum(interpretation == "resistant"),
            n_intermediate = sum(interpretation == "intermediate"),
            n_classes_resistant = n_distinct(antibiotic_class[interpretation == "resistant"]),
            .groups = "drop")

## The number S6 reports per strain is the number of antibiotic classes with
## resistance: it equals the derived class count for every isolate, so the
## derived count is kept and the reported one is not duplicated.
isolates_all <- derived |> left_join(reported, by = "isolate_id")
stopifnot(all(isolates_all$n_classes_resistant == isolates_all$n_resistant_reported))
burigangaamr_isolates <- isolates_all |>
  select(isolate_id, site, n_resistant, n_intermediate, n_classes_resistant,
         nonsusceptible_antibiotics, multidrug_resistant) |>
  arrange(isolate_id)
stopifnot(nrow(burigangaamr_isolates) == 50,
          !anyNA(burigangaamr_isolates$multidrug_resistant))

# Checks against the summary tables and the abstract ---------------------------
## S5: percentage of isolates per interpretation and antibiotic.
pct_ab <- burigangaamr |>
  count(antibiotic, interpretation) |>
  group_by(antibiotic) |>
  mutate(pct = round(100 * n / sum(n))) |>
  ungroup() |>
  select(-n) |>
  pivot_wider(names_from = interpretation, values_from = pct, values_fill = 0)
s5 <- t_pct_ab |>
  rename(antibiotic = 1, susceptible = 2, intermediate = 3, resistant = 4) |>
  mutate(across(-antibiotic, ~ as.integer(str_remove(.x, "%"))))
check_s5 <- pct_ab |>
  inner_join(s5, by = "antibiotic", suffix = c("", "_s5")) |>
  mutate(match = susceptible == susceptible_s5 & intermediate == intermediate_s5 &
           resistant == resistant_s5)
stopifnot(all(check_s5$match))
message("S5 percentages per antibiotic reproduced: ", sum(check_s5$match), " of 9")

## S8: percentage of tests per interpretation and site.
pct_site <- burigangaamr |>
  count(site, interpretation) |>
  group_by(site) |>
  mutate(pct = round(100 * n / sum(n), 2)) |>
  ungroup() |>
  select(-n) |>
  pivot_wider(names_from = interpretation, values_from = pct, values_fill = 0)
s8 <- t_pct_site |>
  rename(site = 1, susceptible = 2, intermediate = 3, resistant = 4) |>
  mutate(across(-site, as.numeric), site = factor(site, levels = LETTERS[1:7]))
check_s8 <- pct_site |>
  inner_join(s8, by = "site", suffix = c("", "_s8")) |>
  mutate(match = abs(susceptible - susceptible_s8) < 0.01 &
           abs(intermediate - intermediate_s8) < 0.01 &
           abs(resistant - resistant_s8) < 0.01)
stopifnot(all(check_s8$match))
message("S8 percentages per site reproduced: ", sum(check_s8$match), " of 7")

## S7 and the abstract: multidrug resistant isolates per site.
mdr_site <- burigangaamr_isolates |>
  filter(multidrug_resistant) |>
  count(site, .drop = FALSE)
s7 <- t_mdr_site |> rename(site = 1, n_s7 = 2) |>
  mutate(n_s7 = as.integer(n_s7), site = factor(site, levels = LETTERS[1:7]))
check_s7 <- full_join(mdr_site, s7, by = "site")
message("S7 multidrug resistant isolates per site: S6 flags ",
        paste(check_s7$site, check_s7$n, sep = "=", collapse = " "),
        " (", sum(check_s7$n), " in all); S7 says ",
        paste(check_s7$site, check_s7$n_s7, sep = "=", collapse = " "),
        " (", sum(check_s7$n_s7), " in all); the abstract says 13")
message("S6 multidrug resistant flag equals three or more classes with resistance: ",
        sum(burigangaamr_isolates$multidrug_resistant == (burigangaamr_isolates$n_classes_resistant >= 3)),
        " of 50")
message("Abstract: resistant to both imipenem and meropenem: ",
        burigangaamr |> filter(antibiotic_code %in% c("IPM", "MRP"),
                               interpretation == "resistant") |>
          count(isolate_id) |> filter(n == 2) |> nrow(), " isolates (abstract: 4%, 2 of 50)")

# Export Data ------------------------------------------------------------------
usethis::use_data(burigangaamr, overwrite = TRUE)
usethis::use_data(burigangaamr_isolates, overwrite = TRUE)
usethis::use_data(burigangaamr_antibiotics, overwrite = TRUE)
fs::dir_create(here::here("inst", "extdata"))
for (name in c("burigangaamr", "burigangaamr_isolates", "burigangaamr_antibiotics")) {
  obj <- get(name)
  readr::write_csv(obj, here::here("inst", "extdata", paste0(name, ".csv")))
  openxlsx::write.xlsx(obj, here::here("inst", "extdata", paste0(name, ".xlsx")))
}
