---
front-matter-title: Q_YERE_SIX_MONTH
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-six-month.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags: [value1, value2]
dependencies:
  - name: pwyere6monthfollowuptp
    type: html
    repo: famcare-html-form-code
  - name: pwyere6monthfollowuptp
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

# Q_YERE_SIX_MONTH

## Purpose

Extracts and consolidates YERE 6-month follow-up data for engagement tracking, behavioral health service monitoring, and justice system involvement. Includes client metadata, contact methods, school and residency changes, and intake activity.

## Description

- Pulls structured data from the `PWYERE6MONTHFOLLOWUPTP` form.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of youth engagement, service barriers, school transitions, and justice system contact.

### Logic Summary

- **Source Table:**
  - `PWYERE6MONTHFOLLOWUPTP` (aliased as `YSIXM`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Engagement: respondent name and relationship, BH service status, contact method
  - Residency: change flags, change types, school attendance and transitions
  - Justice system: ED visits, hospitalizations, law enforcement contacts, JJ system involvement
  - Intake and notes: BH intake attendance, qualitative notes, import ID

## Maintenance Notes

- Monitor for changes in form structure, especially around respondent fields and justice system flags.
- Consider surfacing diagnostic flags for missing intake attendance or ambiguous contact methods.
- Ensure alignment with YERE 30-day and 3-month views for naming and logic consistency.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds snitial Markdown documentation to support standardized view tracking.  
- **2025-07-02**: Updates to use `Q_CLIENT_BHN` for test client exclusion and standardized field naming.  
- **2025-05-23**: Adds initial view definition to support YERE 6-month follow-up reporting.
