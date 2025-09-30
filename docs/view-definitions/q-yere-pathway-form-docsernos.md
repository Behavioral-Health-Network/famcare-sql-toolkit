---
front-matter-title: Q_YERE_PATHWAY_FORM_DOCSERNOS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-pathway-form-docserno.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags: [value1, value2]
dependencies:
  - name: pwyerereferral
    type: html
    repo: famcare-html-form-code
  - name: pwyerereferral
    type: table
    repo: none
  - name: pwyereinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwyereinitialcontact
    type: table
    repo: none
  - name: pwyerehospitalvisitnote
    type: html
    repo: famcare-html-form-code
  - name: pwyerehospitalvisitnote
    type: table
    repo: none
  - name: pwyere30dayfollowuptp
    type: html
    repo: famcare-html-form-code
  - name: pwyere30dayfollowuptp
    type: table
    repo: none
  - name: pwyere3monthfollowuptp
    type: html
    repo: famcare-html-form-code
  - name: pwyere3monthfollowuptp
    type: table
    repo: none
  - name: pwyere6monthfollowuptp
    type: html
    repo: famcare-html-form-code
  - name: pwyere6monthfollowuptp
    type: table
    repo: none
  - name: pwyerebehavioralhealthservicestp
    type: html
    repo: famcare-html-form-code
  - name: pwyerebehavioralhealthservicestp
    type: table
    repo: none
  - name: q_client_bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_YERE_PATHWAY_FORM_DOCSERNOS

## Purpose

Unions all Pathway form `DOCSERNO` values to allow for joining to summations to identify intervals at which records have been added based on the Pathway Event of the parent forms.

## Description

- Consolidates `DOCSERNO` values from all YERE Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWYEREREFERRAL` (Referral)
  - `PWYEREHOSPITALVISITNOTE` (Hospital Visit Note)
  - `PWYEREINITIALCONTACT` (Initial Contact)
  - `PWYERE30DAYFOLLOWUPTP` (30-Day Follow-Up)
  - `PWYERE3MONTHFOLLOWUPTP` (3-Month Follow-Up)
  - `PWYERE6MONTHFOLLOWUPTP` (6-Month Follow-Up)
  - `PWYEREBEHAVIORALHEALTHSERVICESTP` (YBHS)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients.
- Orders results by `CLIENTNUMBER` and `DOCSERNO` to support consistency checks and audit review.
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All YERE form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `FORM_TYPE`

## Maintenance Notes

- If new YERE form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Confirm that `DOCREVNO = ' 0 '` remains the correct filter for current records.
- Consider indexing or materializing if used in high-volume reporting or audit workflows.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-05-01**: Adds initial view definition.
