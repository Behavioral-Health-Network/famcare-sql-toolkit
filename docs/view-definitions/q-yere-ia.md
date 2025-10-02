---
front-matter-title: Q_YERE_IA
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-ia.sql
last_updated: 2025-10-02
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags: [value1, value2]
dependencies:
  - name: pwyereinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwyereinitialcontact
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_YERE_IA

## Purpose

Supports reporting and analytics for YERE Initial Assessments (formerly Initial Contact). Captures client demographics, assessment details, trauma history, school discipline, and behavioral health concerns.

## Description

- Extracts structured data from the `PWYEREINITIALCONTACT` form.
- Enriches coded fields with descriptive metadata for school discipline types.
- Filters out test clients and non-current records.
- Enables analysis of youth engagement, service needs, and referral pathways.

### Logic Summary

- **Source Table:**
  - `PWYEREINITIALCONTACT` (aliased as `YIA`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN YERE_TYPE_OF_SCHOOL_DISCIPLINE` for discipline code descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Contact metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Referral and hospital engagement: discharge flags, contact methods, residency changes
  - System involvement: ED visits, hospitalizations, law enforcement, juvenile justice
  - School data: attendance, grade level, truancy, discipline types and durations
  - Trauma exposure: types, severity, and history
  - Physical and psychiatric health: PCP and psychiatrist access, provider types
  - Mental health concerns: diagnostic flags, co-occurring conditions
  - Substance use history: types, treatment recommendations, tobacco use
  - Functional assessment: DLA-20 score and date
  - Referral outcomes: family support specialist, notes

## Maintenance Notes

- If new discipline codes are introduced, ensure `YERE_TYPE_OF_SCHOOL_DISCIPLINE` is updated and joined correctly.
- Monitor for changes in form structure, especially around trauma flags and diagnostic fields.
- Consider surfacing diagnostic flags for missing DLA-20 scores or ambiguous provider types.

## Changelog

- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-07-01**: Refactors join to use `Q_CLIENT_BHN` for test client filtering.  
- **2025-06-13**: Renames table alias from `IA` to `YIA`.  
- **2025-05-23**: Adds initial view definition.
