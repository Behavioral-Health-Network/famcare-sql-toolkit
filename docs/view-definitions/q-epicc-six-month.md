---
front-matter-title: Q_EPICC_SIX_MONTH
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-six-month.sql
last_updated: 2025-11-18
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
  - name: pwepicc6monthfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc6monthfollowup
    type: table
    repo: none
  - name: q_client_bhn
    type: view
    repo: famcare-sql-toolkit
  - name: epicc-types-mat
    type: table
    repo: none
  - name: epicc-program-participation
    type: table
    repo: none
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_EPICC_SIX_MONTH

## Purpose

Extracts and consolidates EPICC 6-month follow-up data for longitudinal engagement tracking, MAT prescribing analysis, and program participation review. Includes client metadata, treatment path, appointment attendance, and transfer outcomes.

## Description

- Pulls structured data from the `PWEPICC6MONTHFOLLOWUP` form.
- Enriches coded fields with descriptive metadata from lookup tables.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of client retention, MAT prescribing, and regional transfer success.

### Logic Summary

- **Source Table:**
  - `PWEPICC6MONTHFOLLOWUP` (aliased as `ESIXM`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN EPICC_PROGRAM_PARTICIPATION` for program participation descriptions
  - `LEFT JOIN EPICC_TYPES_MAT` for MAT type descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Engagement: appointment attendance, communication dates, intake status
  - MAT prescribing: physician appointment, MAT type and description
  - Program participation: code and description
  - Transfer and region: transfer flags, contact success
  - Client status and pregnancy flags

## Maintenance Notes

- Ensure alignment with 30-day and 3-month views for field naming and join logic.
- Monitor for changes in form structure, especially around MAT and transfer fields.
- Consider surfacing diagnostic flags for missing MAT descriptions or ambiguous program codes.

## Changelog

- **2025-11-18**: Adds fields `TREATMENT_PATH_SIX_MONTH_UNABLE_TO_CONTACT`, `MAT_PRESCRIBED_PHYSICIAN_APPT_SIX_MONTH_UNABLE_TO_CONTACT`, `WHAT_MAT_PHYSICIAN_APPT_SIX_MONTH_UNABLE_TO_CONTACT` aliased as `WHAT_MAT_PHYSICIAN_APPT_SIXM_UTC_CODE`, `WHAT_MAT_PHYSICIAN_APPT_SIXM_UTC_DESCRIPTION`, `REASON_NOT_PARTICIPATING_ SIX_MONTH`, `REASON_NOT_ATTENDING_SUD_TX_ SIX_MONTH`, `OTHER_REASON_NOT_ATTENDING_SUD_TX_ SIX_MONTH`, and `ATTENDING_SUD_TX_VERIFY_ SIX_MONTH`. Adds left join to master table `EPICC_TYPES_MAT` aliased as `MAT_UTC` to get descriptions for `WHAT_MAT_PHYSICIAN_APPT_SIX_MONTH_UNABLE_TO_CONTACT`. Updates the list of dependencies in the frontmatter YAML to include joined tables.
- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-09**: Documentation authored and aligned with 30-day and 3-month scaffolds.  
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-07**: Updates to use `Q_CLIENT_BHN` for test client exclusion and standardized field naming.  
- **2025-05-05**: Adds initial view definition to support EPICC 6-month follow-up reporting and longitudinal engagement tracking.
