# Two pass test of the washr skill (openwashdata/washr#115, pkgreview#90):
# the package built by hand (this directory) and the same package built with
# the /washr skill from the same drafts (the skill pass directory) must differ
# only in prose. Compared: the .rda objects, NAMESPACE, man/*.Rd and the
# dictionary columns other than description.
#   Rscript dev/compare_skill_pass.R ../burigangaamr-skillpass
args <- commandArgs(trailingOnly = TRUE)
other <- if (length(args)) args[1] else "../burigangaamr-skillpass"
here <- "."
ok <- TRUE
report <- function(what, same) {
  cat(sprintf("%-55s %s\n", what, if (isTRUE(same)) "identical" else "DIFFERS"))
  if (!isTRUE(same)) ok <<- FALSE
}
# .rda objects
for (f in list.files(file.path(here, "data"), pattern = "\\.rda$")) {
  a <- new.env(); b <- new.env()
  load(file.path(here, "data", f), envir = a)
  o <- file.path(other, "data", f)
  if (!file.exists(o)) { report(paste("data/", f), FALSE); next }
  load(o, envir = b)
  report(paste0("data/", f), identical(as.list(a), as.list(b)))
}
# NAMESPACE
report("NAMESPACE", identical(readLines(file.path(here, "NAMESPACE")),
                             readLines(file.path(other, "NAMESPACE"))))
# man pages: compare the structure only (name, docType, format header and
# the variable items); title, description, source and examples are prose
strip_prose <- function(lines) {
  keep <- grepl("^\\\\(name|docType|alias|format)\\{", lines) |
    grepl("^\\s*\\\\item\\{", lines)
  lines <- lines[keep]
  # an item line keeps its variable name only; the description is prose
  sub("^(\\s*\\\\item\\{[^}]*\\}).*$", "\\1", lines)
}
for (f in list.files(file.path(here, "man"), pattern = "\\.Rd$")) {
  o <- file.path(other, "man", f)
  if (!file.exists(o)) { report(paste0("man/", f), FALSE); next }
  report(paste0("man/", f, " (structure, items)"),
         identical(strip_prose(readLines(file.path(here, "man", f))),
                   strip_prose(readLines(o))))
}
# dictionary: every column except description
d2_path <- file.path(other, "data-raw", "dictionary.csv")
if (file.exists(d2_path)) {
  d1 <- read.csv(file.path(here, "data-raw", "dictionary.csv"), stringsAsFactors = FALSE)
  d2 <- read.csv(d2_path, stringsAsFactors = FALSE)
  keep <- setdiff(union(names(d1), names(d2)), "description")
  report("dictionary.csv columns other than description",
         identical(d1[intersect(keep, names(d1))], d2[intersect(keep, names(d2))]))
  cat(sprintf("%-55s %s\n", "dictionary.csv descriptions (prose, informational)",
              if (identical(d1$description, d2$description)) "identical" else "differ"))
} else {
  report("dictionary.csv present in the skill pass", FALSE)
}
cat(if (ok) "\nRESULT: the two passes differ only in prose\n" else "\nRESULT: differences beyond prose, see above\n")
