---
front-matter-title: Q_YERE_THIRTY_DAY
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-thirty-day.sql
last_updated: 2025-10-02
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags: [value1, value2]
dependencies:
  - name: pwyere30dayfollowuptp
    type: html
    repo: famcare-html-form-code
  - name: pwyere30dayfollowuptp
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

# Q_YERE_THIRTY_DAY

## Purpose

Extracts and consolidates YERE 30-day follow-up data for engagement tracking, residency changes, and behavioral health intake monitoring. Includes client metadata, contact methods, school and residency changes, and collaboration indicators.

## Description

- Pulls structured data from the `PWYERE30DAYFOLLOWUPTP` form.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of youth engagement, service plan barriers, and staffing coordination.

### Logic Summary

- **Source Table:**
  - `PWYERE30DAYFOLLOWUPTP` (aliased as `YTHIRTYD`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Engagement: active status, contact method, intake attendance
  - Residency: change flags, change types, barrier alignment
  - School and staffing: school changes, collaboration staffing, guardian meetings
  - Behavioral health: engagement indicators, notes

## Maintenance Notes

- Monitor for changes in form structure, especially around residency and staffing fields.
- Consider surfacing diagnostic flags for ambiguous contact methods or missing intake attendance.
- Ensure alignment with other YERE follow-up views for naming and logic consistency.

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

- **2025-12-12**: Adds collapsible `<details>` elements to the Changelog section.
- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation to support standardized view tracking.  
- **2025-07-07**: Updates to use `Q_CLIENT_BHN` for test client exclusion and standardized field naming.  
- **2025-05-23**: Adds initial view definition to support YERE 30-day follow-up reporting.

</details>
</details>
