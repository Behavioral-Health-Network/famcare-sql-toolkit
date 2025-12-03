---
front-matter-title: Q_EPICC_LATEST_SU_TX_AGENCY
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-latest-su-tx-agency.sql
last_updated: 2025-12-03
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
  - active-record-view
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
  - name: q-epicc-pathway-form-docsernos
    type: sql
    repo: none
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_EPICC_LATEST_SU_TX_AGENCY

## Purpose

Returns the most recent substance use treatment agency referral record for each EPICC client. Supports reporting and analysis based on the latest available referral data, including inferred parent form linkage for imported records.

## Description

- Built on `PWSUBROADTREATMENTAGENCY`, filtered to current records (`DOCREVNO = ' 0 '`).
- Uses `Q_CLIENT_BHN` to exclude test clients.
- Enriches agency codes with descriptions via `EPICC_SU_TX_AGENCY`.
- Infers missing `PARENTDOCSERNO` for imported records using form-matching logic.
- Applies tie-breaking logic to ensure one record per client based on `VISITDT`, `DOCSERNO`, and `PARENTDOCSERNO`.
- Adds `FORM_TYPE` to indicate which Pathway Event form was the parent form to enable reporting on patterns in referrals, intakes, and admissions throughout EPICC program participation.
- Includes `SU_TX_INTAKE` indicator for whether client attended intake with `WAS_INTAKE_COMPLETED` to indicate that the intake was conducted and completed, `INTAKE_NOT_COMPLETED` for the reason if the client did not attend intake, and `SU_TX_DATE` if the client did attend intake.
- Includes `COACH_ATTEND_INTAKE` and `CES_ATTEND_INTAKE` indicator columns.

### Logic Summary

- **FORM_MATCH CTE**
  - Matches `START_DATE` to `PATHWAY_DATE` across EPICC forms to infer `DOCSERNO`.

- **INFERREDSUTX CTE**
  - Applies `COALESCE` logic to resolve missing `PARENTDOCSERNO` for imported records.

- **LATESTVISITDATE CTE**
  - Identifies the most recent `VISITDT` per client.

- **LATESTSUTXRECORD CTE**
  - Filters to records with the latest visit date and joins to agency descriptions.

- **FINALSELECTION CTE**
  - Applies final tie-breaking using max `DOCSERNO` and `PARENTDOCSERNO`.

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `CLIENT_NUMBER`                    | Unique client identifier |
| `DOCSERNO`                         | Document reference for the referral |
| `PARENT_DOCSERNO`                  | Reporting interval form (inferred if needed) |
| `FORM_TYPE`                        | Name of the Pathway Event Form that was the parent form/reporting interval form |
| `VISITDT`                          | Date of referral entry |
| `EPICC_SU_TX_AGENCY_CODE`         | Referral agency code |
| `EPICC_SU_TX_AGENCY_DESCRIPTION`  | Human-readable agency name |
| `SU_TX_INTAKE`                          | Indicator for whether client attended a new intake  |
| `WAS_INTAKE_COMPLETED`                          | Indicator for whether the intake was conducted and completed |
| `INTAKE_NOT_COMPLETED`                          | Reason intake was not completed, if relevant |
| `SU_TX_INTAKE_DATE`                          | Intake date |
| `COACH_ATTEND_INTAKE`                          | Indicator for whether the coach attended the intake |
| `CES_ATTEND_INTAKE`                          | Indicator for whether the CES attended the intake |
| `USERID`                           | User who entered the record |

## Maintenance Notes

- **Form Expansion**: Update `FORM_MATCH` if new EPICC forms are added to the workflow.
- **Agency Lookup**: Ensure `EPICC_SU_TX_AGENCY` remains aligned with form codes.
- **Test Client Filtering**: Confirm `Q_CLIENT_BHN` continues to exclude test clients reliably.
- **Parent Inference Logic**: This view does not persist inferred values; consider a data patch routine if needed.

## Changelog

- **2025-12-03**: Adds `WAS_INTAKE_COMPLETED`. Updates the dependencies in the frontmatter. Updates description and matrix of output fields.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-14**: Adds `SU_TX_INTAKE`, `INTAKE_NOT_COMPLETED`, `SU_TX_DATE`, `COACH_ATTEND_INTAKE`, and `CES_ATTEND_INTAKE`.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-05-06**: Adds initial view definition to support reporting on latest substance use treatment referrals for EPICC clients.
