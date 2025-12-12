---
front-matter-title: Q_COMPLEX_CARE_HOUSING_SUMMATION_EXCEPTIONS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-housing-summation-exceptions.sql
last_updated: 2025-12-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - sql-view
  - summation-view
  - exception-report
  - program-docs
dependencies:
  - name: pwmercybeacnbenchmarks
    type: html
    repo: famcare-html-form-code
  - name: pwmercybeacnbenchmarks
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
  - name: q-complex-care-all-housing-status
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-11-14
last_reviewed: 2025-11-14
schema_version: 1.0
---

# Q_COMPLEX_CARE_HOUSING_SUMMATION_EXCEPTIONS

## Purpose

Generates an **exception report** for Complex Care clients enrolled in the Mercy BEACN program. Tracks whether housing status entries are being completed according to business rules:

- Baseline entry at BEACN enrollment date (not FAMCare enrollment date, which is treated as cohort referral date.).
- Monthly entries for up to twelve months post‑enrollment.  
- Stops tracking after cohort discharge.  

Supports program management by surfacing missing baseline entries, skipped monthly updates, and anomalies in baseline alignment.

## Description

- Built on `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` (program enrollment) with discharge dates from `Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS`.  
- Uses `Q_COMPLEX_CARE_ALL_HOUSING_STATUS` for actual housing entries.  
- Filters to current records (`DOCREVNO = '0'`).  
- Generates expected schedule (baseline + 12 months) and prunes months after discharge.  
- Compares expected vs. actual entries to flag exceptions.  
- Provides traceability through `DOCSERNO`, `TIEDENROLLMENT`, and client identifiers.

### Logic Summary

- **Source Tables/Views:**  
  - `PWMERCYBEACNBENCHMARKS` - enrollment baseline date.  
  - `Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS` - referral and discharge dates.  
  - `Q_COMPLEX_CARE_ALL_HOUSING_STATUS` - actual housing entries.  
  - `Q_CLIENT_BHN` - client demographics.  
- **Joins:**  
  - Episode linkage via `CLIENT_NUMBER` + `DOCSERNO`/`TIEDENROLLMENT`.  
  - Left join to enrollment view for discharge bounding.  
- **Logic:**  
  - Generate baseline + 12 monthly expected dates.  
  - Cut off schedule at discharge date if earlier.  
  - Compare expected vs. actual housing entries.  
  - Flag baseline mismatch if baseline date ≠ expected date.
  - Flag housing status entries with more than one entered with start dates in the same month.
- **Output:**  
  - Client demographics.  
  - Baseline date.  
  - Expected sequence and date.  
  - Actual housing entry date (if present).  
  - Flags for completeness and baseline anomalies.

## Output Fields

| Field Name                | Description |
|---------------------------|-------------|
| `CLIENT_NUMBER`           | Unique client identifier |
| `CLIENT_LAST`, `CLIENT_FIRST` | Client name |
| `BASELINE_DATE`           | Program enrollment date (expected baseline) |
| `EXPECTED_SEQ`            | Sequence number (0 = baseline, 1–12 = monthly follow‑ups) |
| `EXPECTED_DATE`           | Expected date for housing entry |
| `HOUSING_START_DATE_ENTERED` | Actual housing entry date recorded |
| `HAS_EXPECTED_ENTRY`      | 1 if expected entry exists, else 0 |
| `HAS_MULTIPLE_ENTRIES`    | 1 if more than one `HOUSING_START_DATE` has been entered for a client within the same month, else 0 or `NULL` |
| `BASELINE_MISMATCH`       | 1 if baseline date ≠ expected date, else 0 |
| `HAS_BASELINE_ENTRY`      | 1 if baseline entry exists, else 0 |

## Maintenance Notes

- **Business Rules:** Ensure baseline and monthly entry rules remain aligned with program requirements.  
- **Discharge Handling:** Confirm discharge dates from `Q_COMPLEX_CARE_PATHCLIENT_ENROLLMENTS` continue to bound expected schedule correctly.  
- **Form Updates:** If new housing status fields are added to `PWHOUSINGSTATUS`, update this view accordingly.  
- **Audit Integrity:** Continue filtering on `DOCREVNO = ' 0 '` to exclude superseded records.  
- **Episode Integrity:** Always join on `DOCSERNO` or `TIEDENROLLMENT` (as relevant) to prevent mixing episodes for clients with multiple enrollments.

## Changelog

- **2025-12-12**: Adds CTEs `MONTHLYCOUNTS` and `MULTIPLEENTRIES` to count instances where a client has more than one `HOUSING_START_DATE` in the same month and then flags as the exception `HAS_MULTIPLE_ENTRIES`.
- **2025-12-09**: Adds initial view definition to support exception reporting on housing status entry for Complex Care clients. Adds initial Markdown documentation.
