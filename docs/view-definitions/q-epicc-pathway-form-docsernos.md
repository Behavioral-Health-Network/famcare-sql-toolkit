---
front-matter-title: Q_EPICC_PATHWAY_FORM_DOCSERNOS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-pathway-form-docsernos.sql
last_updated: 2025-08-09
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
  - `TREATMENT_PATH` (nullable; populated only when present on form)
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All EPICC form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `TREATMENT_PATH`, `FORM_TYPE`

## Maintenance Notes

- If new EPICC form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in source table structures, especially `TREATMENT_PATH` field naming.
- Consider indexing or materializing if used in high-volume reporting.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-05-01**: Adds initial view definition.
