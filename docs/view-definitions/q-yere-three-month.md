---
front-matter-title: Q_YERE_THREE_MONTH
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-three-month.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags: [value1, value2]
dependencies:
  - name: pwyere3monthfollowuptp
    type: html
    repo: famcare-html-form-code
  - name: pwyere3monthfollowuptp
    type: table
    repo: none
  - name: q_client_bhn
    type: view
    repo: famcare-sql-toolkit
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_YERE_THREE_MONTH

## Purpose

Extracts and consolidates YERE 3-month follow-up data for engagement tracking, service utilization, school involvement, and behavioral health intake monitoring. Includes client metadata, residency changes, justice system involvement, and DLA-20 scoring.

## Description

- Pulls structured data from the `PWYERE3MONTHFOLLOWUPTP` form.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of youth engagement, service barriers, school transitions, and health access.

### Logic Summary

- **Source Table:**
  - `PWYERE3MONTHFOLLOWUPTP` (aliased as `THREEM`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Engagement: active status, contact method, intake attendance
  - Residency: change flags, change types, barrier alignment
  - School: attendance, grade level, school changes, equivalency status
  - Justice system: ED visits, hospitalizations, law enforcement contacts, JJ system involvement
  - Health access: PCP visits, provider details, DLA-20 score and date
  - Staffing and services: guardian meetings, collaboration staffing, service extension
  - Notes and qualitative input

## Maintenance Notes

- Monitor for changes in form structure, especially around justice system and health access fields.
- Consider surfacing diagnostic flags for missing DLA-20 scores or ambiguous provider entries.
- Ensure alignment with YERE 30-day view for naming and logic consistency.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation to support standardized view tracking.  
- **2025-07-07**: Updates to use `Q_CLIENT_BHN` for test client exclusion and standardized field naming.  
- **2025-05-23**: Adds initial view definition to support YERE 3-month follow-up reporting.
