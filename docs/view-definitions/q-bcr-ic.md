# Q_BCR_IC

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-ic.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Consolidates BCR Initial Contact form data for reporting and analysis.  
Captures client demographics, program participation, psychosocial assessments, and justice involvement.

## Description

- Extracts structured data from the `PWBCRINITIALCONTACT` form.
- Enriches coded fields with descriptive metadata from multiple lookup tables.
- Supports eligibility tracking, grant attribution, and behavioral health screening metrics.

### Logic Summary

- **Source Table:**
  - `PWBCRINITIALCONTACT` (aliased as `BIC`)

- **Joins:**
  - `LEFT JOIN Q_CLIENT_BHN` for client names and test client exclusion
  - `LEFT JOIN BCR_PROG_PARTICIPATION` for program participation descriptions
  - `LEFT JOIN BCR_CHURCHES` for church affiliation descriptions
  - `LEFT JOIN EMPLOYMENTSTATUS` for employment status descriptions
  - `LEFT JOIN EDUCATIONLEVEL` for education level descriptions
  - `LEFT JOIN BCR_GRANT` for grant attribution descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Contact metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `ZIP_OF_INITIAL_CONTACT`
  - Client info: `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST`
  - Assessment flags: `PHQ9_COMPLETED`, `CAGE_AID_ADMINISTERED`, `DASS_ADMINISTERED`
  - Justice involvement: recent/past arrests, probation, parole history
  - Eligibility: `REASON_IF_INELIGIBLE_IC`, `BCR_GRANT`, `BCR_PROG_PARTICIPATION`

## Maintenance Notes

- If new codes are added to lookup tables, ensure joins remain valid and descriptions are surfaced.
- Monitor for changes in form structure, especially around assessment scoring and eligibility logic.
- Consider surfacing null flags or diagnostic hooks for missing assessments or grant mismatches.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.
- **2025-05-16**: Initial view definition authored to support BCR Initial Contact reporting and eligibility tracking.  
