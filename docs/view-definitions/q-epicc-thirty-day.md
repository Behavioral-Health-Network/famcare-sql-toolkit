---
front-matter-title: Q_EPICC_THIRTY_DAY
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-thirty-day.sql
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
  - name: pwepicc30dayfollowup
    type: html
    repo: famcare-html-form-code
  - name: pwepicc30dayfollowup
    type: table
    repo: none
  - name: q_client_bhn
    type: view
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_EPICC_THIRTY_DAY

## Purpose

Extracts and consolidates EPICC 30-day follow-up data for reporting, program tracking, and MAT engagement analysis. Includes client metadata, treatment path, program participation, and physician-prescribed MAT details.

## Description

- Pulls structured data from the `PWEPICC30DAYFOLLOWUP` form.
- Enriches coded fields with descriptive metadata from lookup tables.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of client engagement, MAT prescribing, and regional transfers.

### Logic Summary

- **Source Table:**
  - `PWEPICC30DAYFOLLOWUP` (aliased as `ETHIRTYD`)

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
  - Transfer and region: transfer flags, contact success, reengagement specialist date
  - Client status and pregnancy flags

## Maintenance Notes

- If new MAT types or program codes are introduced, ensure lookup tables are updated and joins remain valid.
- Monitor for changes in form structure, especially around transfer logic and appointment tracking.
- Consider surfacing diagnostic flags for missing MAT descriptions or ambiguous program participation codes.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-07-07**: Updates to use `Q_CLIENT_BHN` instead of `Q_CLIENT` for test client exclusion and standardized field naming.  
- **2025-05-05**: Adds initial view definition to support EPICC 30-day follow-up reporting and MAT engagement tracking.
