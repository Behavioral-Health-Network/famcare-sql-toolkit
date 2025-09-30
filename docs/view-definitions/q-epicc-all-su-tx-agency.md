---
front-matter-title: Q_EPICC_ALL_SU_TX_AGENCY
category: view-definitions
category-label: View Definitions
source_file: code/view-definitions/q-epicc-all-su-tx-agency.sql
last_updated: 2025-08-22
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - epicc-su-tx-agency
  - view-layer
  - summation-view
  - slowly-changing-dimension
  - historical-record-view
  - pathway-event
  - enrollment-join
  - provider-placement
dependencies:
  - name: pwsubroadtreatmentagency
    type: html
    repo: famcare-html-form-code
  - name: pwsubroadtreatmentagency
    type: table
    repo: none
  - name: epicc-su-tx-agency
    type: table
    repo: none
  - name: q-epicc-ic
    type: sql
    repo: famcare-sql-toolkit
  - name: pwepiccinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwepiccinitialcontact
    type: table
    repo: none
  - name: q-epicc-two-week
    type: sql
    repo: famcare-sql-toolkit
  - name: pwepicc2weekfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc2weekfollowup
    type: table
    repo: none
  - name: q-epicc-thirty-days
    type: sql
    repo: famcare-sql-toolkit
  - name: pwepicc30dayfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc30dayfollowup
    type: table
    repo: none
  - name: q-epicc-three-month
    type: sql
    repo: famcare-sql-toolkit
  - name: pwepicc3monthfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc3monthfollowup
    type: table
    repo: none
  - name: q-epicc-six-month
    type: sql
    repo: famcare-sql-toolkit
  - name: pwepicc6monthfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc6monthfollowup
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: q-epicc-pathclient-enrollments
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
  - internal-review-required
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-22
last_reviewed: 2025-08-22
schema_version: 1.0
---

# Q_EPICC_ALL_SU_TX_AGENCY

## Purpose

Returns all substance use treatment agency referral records for EPICC clients. Supports longitudinal tracking of referrals, intake outcomes, and agency engagement across multiple forms.

## Description

- Built on `PWSUBROADTREATMENTAGENCY`, which includes only EPICC records.
- Filters to current records (`DOCREVNO = ' 0 '`).
- Joins with `Q_CLIENT_BHN` to exclude test clients.
- Enriches agency codes with descriptions via `EPICC_SU_TX_AGENCY`.
- Uses `CTE_FORM_MATCH` to infer missing `PARENTDOCSERNO` for imported records.
- Joins to `Q_EPICC_PATHCLIENT_ENROLLMENTS` to retrieve `PWY_EVENT`, `ENROLLMENT_STARTING_DATE`, and `PP_DOCSERNO` to allow for joins in R.

### Logic Summary

- **FORM_MATCH CTE**
  - Matches `START_DATE` to `PATHWAY_DATE` across EPICC forms to infer `DOCSERNO`.

- **Parent Form Inference**
  - Applies conditional logic to replace missing `PARENTDOCSERNO` for imported records using matched form data.

- **Agency Description**
  - Joins to `EPICC_SU_TX_AGENCY` for both referral and PFH facility descriptions.

- **Date Casting**
  - Casts all relevant dates to `DATE` format for consistency.

## Output Fields

|                                       Field Name                                       |                         Description                        |
|:---------------------------------------------------------------------------------------|:-----------------------------------------------------------|
| `CLIENT_NUMBER`                                                                          | Unique client identifier                                   |
| `DOCSERNO`                                                                               | Document reference for the referral                      |
| `PARENT_DOCSERNO`                                                                        | Reporting interval form (inferred if needed)             |
| `PWY_EVENT`                                                                              | Name of the pathway event associated with the enrollment |
| `PP_DOCSERNO`                                                                            | Document reference for Provider Placement form           |
| `ENROLLMENT_STARTING_DATE`                                                               | Start date of EPICC enrollment                             |
| `VISITDT`, `START_DATE`, `END_DATE`, `PATHWAY_DATE`                                          | Referral timing and linkage                                |
| `EPICC_SU_TX_AGENCY_CODE`, `EPICC_SU_TX_AGENCY_DESCRIPTION`                                | Referral agency                                            |
| `PFH_TX_FACILITY_CODE`, `PFH_TX_FACILITY_DESCRIPTION`                                      | PFH facility                                               |
| `SU_TX_INTAKE_DATE`, `SU_TX_INTAKE`                                                        | Intake date and status                                     |
| `WAS_INTAKE_COMPLETED`, `INTAKE_NOT_COMPLETED`, `INTAKE_NOT_COMPLETED_OTHER`                 | Intake outcome                                             |
| `COACH_ATTEND_INTAKE`, `CES_ATTEND_INTAKE`, `COACH_NOT_ATTEND_INTAKE`, `CES_NOT_ATTEND_INTAKE` | Attendance flags                                           |
| `IF_OTHER_SPECIFY`                                                                       | Free-text agency specification                             |
| `USERID`                                                                                 | User who entered the record                                |

## Maintenance Notes

- **Form Expansion**: Update `CTE_FORM_MATCH` if new EPICC forms are added to the workflow.
- **Agency Lookup**: Ensure `EPICC_SU_TX_AGENCY` remains aligned with form codes.
- **Enrollment Join**: Validate `Q_EPICC_PATHCLIENT_ENROLLMENTS` logic if enrollment metadata changes.
- **Test Client Filtering**: Confirm `Q_CLIENT_BHN` continues to exclude test clients reliably.

## Changelog

- **2025-08-22**: Adds join to `Q_EPICC_PATHCLIENT_ENROLLMENTS` for `PWY_EVENT`, `ENROLLMENT_STARTING_DATE`, and `PP_DOCSERNO`.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-06-09**: Adds initial view definition to support full referral tracking to substance use treatment agencies for EPICC clients.
