---
front-matter-title: Q_YERE_BHS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-bhs.sql
last_updated: 2025-10-02
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags: [value1, value2]
dependencies:
  - name: pwyerebehavioralhealthservicestp
    type: html
    repo: famcare-html-form-code
  - name: pwyerebehavioralhealthservicestp
    type: table
    repo: none
  - name: cmhc_agency
    type: table
    repo: none
  - name: ada_su_agency
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

# Q_YERE_BHS

## Purpose

Extracts and consolidates YERE behavioral health service data to enagble reporting on intake and admission status for clients on given enrollments.

## Description

- Extracts Behavioral Health Services form data used to track intake and admission to behavioral health agencies, primarily CMHCs and CBHOs.
- Supports analysis of service connection, agency attribution, and admission outcomes.
- Includes metadata for:
  - Intake attendance and agency details
  - Admission status and reasons for non-admission
  - Service path and program type
  - Time intervals between key milestones (e.g., intake to admission, admission to first service)
- Joins to:
  - `Q_CLIENT_BHN` for client validation and test client exclusion
  - `CMHC_AGENCY` and `ADA_SU_AGENCY` for intake agency descriptions

### Logic Summary

- **Source Table:**
  - `PWYEREBEHAVIORALHEALTHSERVICESTP`

- **Joins:**
  - `LEFT JOIN Q_CLIENT_BHN` for client metadata
  - `LEFT JOIN CMHC_AGENCY` for mental health intake agency descriptions
  - `LEFT JOIN ADA_SU_AGENCY` for substance use intake agency descriptions

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `EVENT_NAME`
  - Intake flags and agency codes/descriptions
  - Admission status and reasons
  - Time intervals for intake and service connection

## Maintenance Notes

- If new intake types or agency codes are introduced, ensure lookup tables (`CMHC_AGENCY`, `ADA_SU_AGENCY`) are updated and joined appropriately.
- Monitor for changes in field naming or form structure that could affect output consistency.
- Confirm that `DOCREVNO = ' 0 '` remains the correct filter for current records.

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
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-07-15**: Adds initial view definition.

</details>
</details>
