---
front-matter-title: Q_BCR_PATHWAY_FORM_DOCSERNOS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-pathway-form-docsernos.sql
last_updated: 2025-05-01
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - tag1
  - tag2
dependencies:
  - name: pwbcrreferral
    type: html
    repo: famcare-html-form-code
  - name: pwbcrreferral
    type: table
    repo: none
  - name: pwbcrinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwbcrinitialcontact
    type: table
    repo: none
  - name: pwbcrreferralsplaced
    type: html
    repo: famcare-html-form-code
  - name: pwbcrreferralsplaced
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

# Q_BCR_PATHWAY_FORM_DOCSERNOS

## Purpose

Unions all Pathway form `DOCSERNO` values to allow for joining to summations to identify intervals at which records have been added based on the Pathway Event of the parent forms.

## Description

- Consolidates DOCSERNO values from multiple BCR Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWBCRREFERRAL` (BCR Referral)
  - `PWBCRINITIALCONTACT` (BCR Initial Contact)
  - `PWBCRREFERRALSPLACED` (BCR Referrals Placed)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`).
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - `PWBCRREFERRAL`, `PWBCRINITIALCONTACT`, `PWBCRREFERRALSPLACED`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `FORM_TYPE`

## Maintenance Notes

- If new BCR form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in source table structures that could affect field availability or naming.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-05-01**: Adds initial view definition.
