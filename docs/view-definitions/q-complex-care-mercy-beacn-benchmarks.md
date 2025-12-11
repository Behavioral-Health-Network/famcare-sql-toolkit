---
front-matter-title: Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-mercy-beacn-benchmarks.sql
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
  - milestone-tracking
  - cohort-definition
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
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-11-14
last_reviewed: 2025-11-14
schema_version: 1.0
---

# Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS

## Purpose

Provides a full record of **benchmark milestones** for Complex Care clients enrolled in the Mercy Beacon program.  
Captures dates for referral, enrollment, evaluation, and treatment team assignment to support program monitoring and reporting.

## Description

- Built on `PWMERCYBEACNBENCHMARKS`, scoped to Complex Care clients.  
- Filters to current records (`DOCREVNO = '0'`).  
- Outputs key milestone dates and enrollment indicators.  
- Provides traceability through `DOCSERNO`, `PARENTDOCSERNO`, and visit metadata.

### Logic Summary

- **Source Table:** `PWMERCYBEACNBENCHMARKS`.  
- **Client Join:** `CLIENTNUMBER` aligns with `Q_CLIENT_BHN`.  
- **Filters:** `DOCREVNO = '0'` excludes revised/voided records.  
- **Output:**  
  - Visit metadata (`VISIT_DATE`, `VISITTM`, `USERID`).  
  - Pathway and cohort dates.  
  - Enrollment and post‑enrollment contact dates.  
  - Admission service and evaluation dates.  
  - Treatment team assignment date.  
  - Tie‑to‑enrollment indicator (`TIEDENROLLMENT`).  

## Output Fields

| Field Name                          | Description |
|-------------------------------------|-------------|
| `ID`                                | Internal record identifier |
| `DOCSERNO`                          | Document serial number |
| `VISIT_DATE`, `VISITTM`, `USERID`   | Metadata for audit and traceability |
| `PARENTDOCSERNO`                    | Parent form reference |
| `CLIENT_NUMBER`                     | Unique client identifier |
| `PATHWAY_DATE`                      | Date of pathway form |
| `ADDED_COHORT_DATE`                 | Date client was added to cohort |
| `FIRST_POST_REFERRAL_CONTACT_DATE`  | First contact after referral |
| `ENROLLMENT_DATE`                   | Date of program enrollment |
| `FIRST_POST_ENROLLMENT_CONTACT_DATE`| First contact after enrollment |
| `COMPLETE_ADMISSION_SERVICE_DATE`   | Date admission service completed |
| `PSYCH_EVAL_DATE`                   | Date of psychiatric evaluation |
| `TREATMENT_TEAM_ASSIGNMENT_DATE`    | Date treatment team assigned |
| `TIEDENROLLMENT`                    | Indicator for tie‑to‑enrollment |

## Maintenance Notes

- **Benchmark Tracking:** Ensure milestone dates remain aligned with program reporting requirements.  
- **Form Updates:** If new benchmark fields are added to `PWMERCYBEACNBENCHMARKS`, update this view accordingly.  
- **Client Scope:** Confirm linkage to Complex Care clients remains valid.  
- **Audit Integrity:** Continue filtering on `DOCREVNO = '0'` to exclude superseded records.  

## Changelog

- **2025-12-09**: Adds `INNER JOIN` to filter out test clients.
- **2025-11-14**: Adds initial view definition to support full housing status history reporting for Complex Care clients. Adds initial Markdown documentation.
