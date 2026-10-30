# Validation checks for the burigangaamr data objects.
#
# Run from the package root: Rscript analysis/validate_data.R
# The script reads data/*.rda directly, so it needs no installed package and
# no package beyond base R. It prints one line per check and stops with an
# error when a check fails. The checks are the cross-field and consistency
# checks of the data review (pkgreview data checklist, issue #3); the known
# supplement inconsistencies are reported as counts, not as failures.

e <- new.env()
for (f in list.files("data", pattern = "[.]rda$", full.names = TRUE)) load(f, envir = e)
long <- e$burigangaamr
iso <- e$burigangaamr_isolates
ab <- e$burigangaamr_antibiotics

check <- function(label, ok, detail = "") {
  cat(sprintf("%-72s %s%s\n", label, if (isTRUE(ok)) "ok" else "FAIL",
              if (nzchar(detail)) paste0(" (", detail, ")") else ""))
  if (!isTRUE(ok)) stop("check failed: ", label)
}

# Dimensions
check("long table: 50 isolates x 9 antibiotics = 450 rows", nrow(long) == 450)
check("long table: (isolate_id, antibiotic_code) is unique",
      !anyDuplicated(long[c("isolate_id", "antibiotic_code")]))
check("isolates: 50 rows, isolate_id unique", nrow(iso) == 50 && !anyDuplicated(iso$isolate_id))
check("antibiotics: 9 rows, antibiotic_code unique", nrow(ab) == 9 && !anyDuplicated(ab$antibiotic_code))
check("every isolate_id of the long table is in isolates and the reverse",
      setequal(long$isolate_id, iso$isolate_id))
check("every antibiotic_code of the long table is in antibiotics",
      setequal(as.character(long$antibiotic_code), ab$antibiotic_code))

# Missing values
check("no NA outside zone_mm (long) and nonsusceptible_antibiotics (isolates)",
      sum(is.na(long[setdiff(names(long), "zone_mm")])) == 0 &&
        sum(is.na(iso[setdiff(names(iso), "nonsusceptible_antibiotics")])) == 0 &&
        sum(is.na(ab)) == 0)
check("every NA zone_mm (no zone of inhibition) is interpreted as resistant",
      all(long$interpretation[is.na(long$zone_mm)] == "resistant"),
      sprintf("%d NA of %d", sum(is.na(long$zone_mm)), nrow(long)))
check("the only NA in nonsusceptible_antibiotics belongs to an isolate with no nonsusceptible result",
      all((iso$n_resistant + iso$n_intermediate == 0) == is.na(iso$nonsusceptible_antibiotics)),
      paste(iso$isolate_id[is.na(iso$nonsusceptible_antibiotics)], collapse = ", "))

# Ranges and breakpoints
check("zone_mm within 1 to 60 mm", all(long$zone_mm >= 1 & long$zone_mm <= 60, na.rm = TRUE),
      paste(range(long$zone_mm, na.rm = TRUE), collapse = " to "))
check("breakpoints contiguous: resistant_max + 1 == intermediate_min",
      all(ab$breakpoint_resistant_max + 1L == ab$breakpoint_intermediate_min))
check("breakpoints contiguous: intermediate_max + 1 == susceptible_min",
      all(ab$breakpoint_intermediate_max + 1L == ab$breakpoint_susceptible_min))

# Interpretation follows the breakpoints
m <- merge(long, ab[c("antibiotic_code", "breakpoint_resistant_max", "breakpoint_susceptible_min")],
           by = "antibiotic_code")
expected <- ifelse(is.na(m$zone_mm) | m$zone_mm <= m$breakpoint_resistant_max, "resistant",
                   ifelse(m$zone_mm >= m$breakpoint_susceptible_min, "susceptible", "intermediate"))
check("interpretation equals the breakpoint rule applied to zone_mm",
      all(expected == as.character(m$interpretation)), sprintf("%d rows", nrow(m)))

# Counts per isolate against the long table
r <- tapply(long$interpretation == "resistant", long$isolate_id, sum)
i <- tapply(long$interpretation == "intermediate", long$isolate_id, sum)
k <- tapply(seq_len(nrow(long)), long$isolate_id, function(idx)
  length(unique(long$antibiotic_class[idx][long$interpretation[idx] == "resistant"])))
check("n_resistant equals the count of resistant results in the long table",
      all(iso$n_resistant == r[iso$isolate_id]))
check("n_intermediate equals the count of intermediate results in the long table",
      all(iso$n_intermediate == i[iso$isolate_id]))
check("n_classes_resistant equals the count of classes with a resistant result",
      all(iso$n_classes_resistant == k[iso$isolate_id]))
check("n_resistant + n_intermediate <= 9 and n_classes_resistant <= n_resistant",
      all(iso$n_resistant + iso$n_intermediate <= 9) && all(iso$n_classes_resistant <= iso$n_resistant))

# Known supplement inconsistencies, reported but not failed
mdr_rule <- iso$n_classes_resistant >= 3
cat(sprintf("%-72s %d isolate(s): %s\n",
            "multidrug_resistant flag (S6) differs from the three-class rule",
            sum(iso$multidrug_resistant != mdr_rule),
            paste(iso$isolate_id[iso$multidrug_resistant != mdr_rule], collapse = ", ")))
listed <- lapply(strsplit(ifelse(is.na(iso$nonsusceptible_antibiotics), "",
                                 iso$nonsusceptible_antibiotics), ",[ ]*"), function(x) x[nzchar(x)])
derived <- lapply(split(long, long$isolate_id), function(d)
  as.character(d$antibiotic_code[d$interpretation != "susceptible"]))
differs <- !mapply(setequal, listed, derived[iso$isolate_id])
cat(sprintf("%-72s %d isolate(s): %s\n",
            "nonsusceptible_antibiotics (S6) differs from the long table (S3, S4)",
            sum(differs), paste(iso$isolate_id[differs], collapse = ", ")))

cat("all checks passed\n")
