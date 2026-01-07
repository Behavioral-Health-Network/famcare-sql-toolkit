---
front-matter-title: Q_EPICC_ALL_SU_TX_AGENCY
category: view-definitions
category-label: View Definitions
source_file: code/view-definitions/q-epicc-all-su-tx-agency.sql
last_updated: 2025-12-19
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

Returns all substance use treatment agency referral records for EPICC clients. Supports longitudinal tracking of referrals, intake outcomes, and agency engagement across multiple forms. Emphasizes consistent linkage to Pathway events even for imported records lacking parent form references.

## Description

- Built on `PWSUBROADTREATMENTAGENCY`, which includes only EPICC records.
- Filters to current records (`DOCREVNO = ' 0 '`).
- Normalizes `PARENTDOCSERNO` in `SUTX_BASE`:
  - `PARENTDOCSERNO_CLEAN` trims blanks and converts empty strings to `NULL`.
  - `PARENTDOCSERNO_ISNULL` provides a flag for missing parent references.
- Introduces `PATHWAY_DATE_JOINKEY` in `SUTX_BASE`:
  - Cast once to `DATE` for reuse in all join predicates.
  - Resolves to `PATHWAY_DATE` when present; otherwise falls back to `START_DATE`.
- Uses `CTE_FORM_MATCH` to infer missing `PARENTDOCSERNO` for imported records by matching `PATHWAY_DATE_JOINKEY` to milestone forms.
- Joins to `Q_CLIENT_BHN` to exclude test clients.
- Enriches agency codes with descriptions via `EPICC_SU_TX_AGENCY`.
- Joins to `Q_EPICC_PATHCLIENT_ENROLLMENTS` for to retrieve `PWY_EVENT`, `ENROLLMENT_STARTING_DATE`, and `PP_DOCSERNO` to allow for downstream analysis requiring reproducible exports and joins in R.

### Logic Summary

- **SUTX_BASE CTE**
  - Normalizes parent references and casts join key once.
- **FORM_MATCH CTE**
  - Matches `PATHWAY_DATE_JOINKEY` to milestone form `PATHWAY_DATE` when parent is missing.
  - Uses `PARENTDOCSERNO_CLEAN` for direct DOCSERNO joins when parent is present.
- **Parent Form Inference**
  - Imported records: infer parent via (`CLIENTNUMBER`, `PATHWAY_DATE_JOINKEY`).
  - Front‑end records: join directly on `DOCSERNO`.
- **Agency Description**
  - Joins to `EPICC_SU_TX_AGENCY` for referral and PFH facility descriptions.
- **Date Casting**
  - Outer `SELECT` casts display dates to `DATE` for consistency; join predicates rely on `PATHWAY_DATE_JOINKEY`.

## Output Fields

| Field Name  | Description  |
|:------------|:-------------|
| `CLIENT_NUMBER` | Unique client identifier |
| `DOCSERNO` | Document reference for the referral |
| `PARENT_DOCSERNO` | Reporting interval form (inferred if needed) |
| `PARENT_PWY_EVENT` | Name of the pathway event associated with the parent form |
| `VISITDT`, `START_DATE`, `END_DATE` | Referral timing fields |
| `PATHWAY_DATE` | Derived join key (`PATHWAY_DATE_JOINKEY` cast to DATE) |
| `EPICC_SU_TX_AGENCY_CODE`, `EPICC_SU_TX_AGENCY_DESCRIPTION` | Referral agency |
| `PFH_TX_FACILITY_CODE`, `PFH_TX_FACILITY_DESCRIPTION` | PFH facility |
| `SU_TX_INTAKE_DATE`, `SU_TX_INTAKE` | Intake date and status |
| `WAS_INTAKE_COMPLETED`, `INTAKE_NOT_COMPLETED`, `INTAKE_NOT_COMPLETED_OTHER` | Intake outcome |
| `COACH_ATTEND_INTAKE`, `CES_ATTEND_INTAKE`, `COACH_NOT_ATTEND_INTAKE`, `CES_NOT_ATTEND_INTAKE` | Attendance flags |
| `IF_OTHER_SPECIFY` | Free‑text agency specification |
| `USERID` | User who entered the record |

> Sources: Derived field descriptions reflect the addition of `PATHWAY_DATE_JOINKEY` and parent inference updates.

## Maintenance Notes

- **Effective Date Governance**:
  - `PATHWAY_DATE_JOINKEY = COALESCE(PATHWAY_DATE, START_DATE)` ensures imported rows resolve to the correct milestone form.
  - Indexed on (`CLIENTNUMBER`, `PATHWAY_DATE_JOINKEY`) to enable seeks in form‑matching joins.
- **Form Expansion**: Update `CTE_FORM_MATCH` if new EPICC forms are added.
- **Agency Lookup**: Ensure `EPICC_SU_TX_AGENCY` remains aligned with form codes.
- **Enrollment Join**: Validate `Q_EPICC_PATHCLIENT_ENROLLMENTS` logic if enrollment metadata changes.
- **QA workflow**:
  - Investigate unresolved matches (`NULL` `PARENT_PWY_EVENT`) as anomalies.
  - Spot‑check clients with later‑interval referrals to confirm inference works.

## Governance Notes

- `PATHWAY_DATE_JOINKEY` exists to normalize joins between imported summation records and pathway event forms.  
- `PARENTDOCSERNO_CLEAN` and `PARENTDOCSERNO_ISNULL` simplify join logic and improve readability.  
- Contributors should always use `PATHWAY_DATE_JOINKEY` in join predicates rather than casting inline.  
- Document changes to effective date logic in both the data dictionary and view docs.

## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-19**: Refactors `PWY_PARENT_EVENT` to match the values saved to `Q_EPICC_PATHCLIENT_ENROLLMENTS` view definition: 'EPICC Initial Contact', 'EPICC 2 Week', 'EPICC 30 Day', 'EPICC 3 Month', and 'EPICC 6 Month'.
- **2025-11-24**: Refactors view to introduce `SUTX_BASE` CTE for normalized parent references and join key casting. Updates join logic to use `PATHWAY_DATE_JOINKEY` consistently. Documentation updated to reflect contributor guidance and governance notes.
- **2025-11-20**: Introduces `PATHWAY_DATE_JOINKEY` (persisted computed column) in `PWSUBROADTREATMENTAGENCY` and indexes (`CLIENTNUMBER`, `PATHWAY_DATE_JOINKEY`) for performant form matching. Refactors join logic to use `PATHWAY_DATE_JOINKEY` for inference when `PARENTDOCSERNO` is absent. Adds `PARENT_PWY_EVENT` distribution guidance and `NULL`‑case QA notes. Updates maintenance and governance notes to reflect schema annotation and contributor usage.
- **2025-10-22**: Adds join conditions for `LEFT JOIN` between `PWSUBROADTREATMENTAGENCY` and each EPICC milestone form (`EIC`, `ETWOW`, `ETHIRTYD`, `ETHREEM`, and `ESIXM`) by joining `PWSUBROADTREATMENTAGENCY.START_DATE` to `FOOFORM.PATHWAY_DATE` when `PWSUBROADTREATMENTAGENCY.PARENTDOCSERNO` is `NULL` (which will always be true for imported records) and otherwise joining `PWSUBROADTREATMENTAGENCY.PARENTDOCSERNO` = `FORFORM.DOCSERNO` when `PWSUBROADTREATMENTAGENCY.PARENTDOCSERNO` is not `NULL` (which should always be true for form data entered using the FAMCare front end forms). Adds `PARENT_PWY_EVENT` column to identify the parent form when a `PWSUBROADTREATMENTAGENCY.PARENTDOCSERNO` join is possible.
- **2025-08-22**: Adds join to `Q_EPICC_PATHCLIENT_ENROLLMENTS` for `PWY_EVENT`, `ENROLLMENT_STARTING_DATE`, and `PP_DOCSERNO`.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-06-09**: Adds initial view definition to support full referral tracking to substance use treatment agencies for EPICC clients.

</details>
</details>
