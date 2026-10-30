# burigangaamr (development version)

- Metadata review: the package records the pkgreview standard it is reviewed against (1.7.0, openwashdata profile) in `CLAUDE.md`, the first data contributor carries her ORCID in DESCRIPTION, and the citation files were regenerated with `washr::update_citation()` (#1).
- Data review: the data objects, their CSV and XLSX exports and the dictionary are unchanged; `analysis/validate_data.R` holds the consistency checks of the review and reports the two supplement inconsistencies (isolates B1c and G3a) (#3).
