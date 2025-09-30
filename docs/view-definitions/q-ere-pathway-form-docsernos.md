---
front-matter-title: Q_ERE_PATHWAY_FORM_DOCSERNOS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-pathway-form-docsernos.sql
last_updated: 2025-08-008
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - tag1
  - tag2
dependencies:
  - name: pwerereferral
    type: html
    repo: famcare-html-form-code
  - name: pwerereferral
    type: table
    repo: none
  - name: pwereihna
    type: html
    repo: famcare-html-form-code
  - name: pwereihna
    type: table
    repo: none
  - name: pwerethreemonthfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwerethreemonthfollowup
    type: table
    repo: none
  - name: pwyeresixmonthfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwyeresixmonthfollowup
    type: table
    repo: none
  - name: pwerebehavioralhealthservice
    type: html
    repo: famcare-html-form-code
  - name: pwerebehavioralhealthservice
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

# Q_ERE_PATHWAY_FORM_DOCSERNOS

## Purpose

Unions all Pathway form `DOCSERNO` values to allow for joining to summations to identify intervals at which records have been added based on the Pathway Event of the parent forms.

## Description

- Consolidates DOCSERNO values from all ERE Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWEREREFERRAL` (Referral)
  - `PWEREIHNA` (IHNA)
  - `PWERETHREEMONTHFOLLOWUP` (3-Month Follow-Up)
  - `PWERESIXMONTHFOLLOWUP` (6-Month Follow-Up)
  - `PWEREBEHAVIORALHEALTHSERVICE` (BHS)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients.
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All ERE form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `FORM_TYPE`

## Maintenance Notes

- If new ERE form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Confirm that `DOCREVNO = ' 0 '` remains the correct filter for current records.
- Consider adding ordering logic if used in audit workflows or form sequencing.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-08**: Adds initial Markdown documentation.
- **2025-07-23**: Adds initial view definition.
