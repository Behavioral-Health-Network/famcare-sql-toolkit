---
front-matter-title: Q_EPICC_PATHWAY_FORM_DOCSERNOS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-pathway-form-docsernos.sql
last_updated: 2025-12-22
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags:
  - tag1
  - tag2
dependencies:
  - name: pwepiccreferral
    type: html
    repo: famcare-html-form-code
  - name: pwepiccreferral
    type: table
    repo: none
  - name: pwepiccinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwepiccinitialcontact
    type: table
    repo: none
  - name: pwepicc2weekfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc2weekfollowup
    type: table
    repo: none
  - name: pwepicc30dayfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc30dayfollowup
    type: table
    repo: none
  - name: pwepicc3monthfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc3monthfollowup
    type: table
    repo: none
  - name: pwepicc6monthfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc6monthfollowup
    type: table
    repo: none
  - name: q_client_bhn
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_EPICC_PATHWAY_FORM_DOCSERNOS

## Purpose

Unions all Pathway form `DOCSERNO` values to allow for joining to summations to identify intervals at which records have been added based on the Pathway Event of the parent forms.

## Description

- Consolidates DOCSERNO values from all EPICC Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWEPICCREFERRAL` (Referral)
  - `PWEPICCINITIALCONTACT` (Initial Contact)
  - `PWEPICC2WEEKFOLLOWUP` (2-Week Follow-Up)
  - `PWEPICC30DAYFOLLOWUP` (30-Day Follow-Up)
  - `PWEPICC3MONTHFOLLOWUP` (3-Month Follow-Up)
  - `PWEPICC6MONTHFOLLOWUP` (6-Month Follow-Up)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients.
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `TIEDENROLLMENT`
  - `PROGRAM_PARTICIPATION_CODE`
  - `PROGRAM_PARTICIPATION_DESCRIPTION`
  - `TREATMENT_PATH` (shows as 'N/A' when `TREATMENT_PATH_FOO` is hidden on the form by design)
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All EPICC form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `LEFT JOIN EPICC_PROGRAM_PARTICIPATION` for adding the program participation descriptions.

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `TIEDENROLLMENT`, `PROGRAM_PARTICIPATION_CODE`, `PROGRAM_PARTICIPATION_DESCRIPTION`, `TREATMENT_PATH`, `FORM_TYPE`

## Maintenance Notes

- If new EPICC form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in source table structures, especially `TREATMENT_PATH` field naming and updates to form workflows involving changes to `PROGRAM_PARTICIPATION_FOO`.
- Consider indexing or materializing if used in high-volume reporting.

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

- **2025-12-22**: Adds field `TIEDENROLLMENT`.
- **2025-11-20**: Adds fields `PROGRAM_PARTICIPATION_CODE` and `PROGRAM_PARTICIPATION_DESCRIPTION` to provide context for rows where `TREATMENT_PATH` is 'N/A'. Adds conditional CASE logic to return 'N/A' when the `TREATMENT_PATH_FOO` is missing by design because the field was hidden on the form and should not have a value.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-05-01**: Adds initial view definition.

</details>
</details>
