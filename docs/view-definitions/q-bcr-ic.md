---
front-matter-title: Q_BCR_IC
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-ic.sql
last_updated: 2025-12-18
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - pathway-event
  - sql-view
dependencies:
  - name: pwbcrinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwbcrinitialcontact
    type: table
    repo: none
  - name: q-client-bhn
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

# Q_BCR_IC

## Purpose

Consolidates BCR Initial Contact form data for reporting and analysis. Captures client demographics, program participation, psychosocial assessments, and justice involvement.

## Description

- Extracts structured data from the `PWBCRINITIALCONTACT` form.
- Enriches coded fields with descriptive metadata from multiple lookup tables.
- Supports eligibility tracking, grant attribution, and behavioral health screening metrics.

### Logic Summary

- **Source Table:**
  - `PWBCRINITIALCONTACT` (aliased as `BIC`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client names and test client exclusion
  - `LEFT JOIN BCR_PROG_PARTICIPATION` for program participation descriptions
  - `LEFT JOIN BCR_CHURCHES` for church affiliation descriptions
  - `LEFT JOIN EMPLOYMENTSTATUS` for employment status descriptions
  - `LEFT JOIN EDUCATIONLEVEL` for education level descriptions
  - `LEFT JOIN BCR_GRANT` for grant attribution descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Contact metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `ZIP_OF_INITIAL_CONTACT`
  - Client info: `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST`
  - Assessment flags: `PHQ9_COMPLETED`, `CAGE_AID_ADMINISTERED`, `DASS_ADMINISTERED`
  - Justice involvement: recent/past arrests, probation, parole history
  - Eligibility: `REASON_IF_INELIGIBLE_IC`, `BCR_GRANT`, `BCR_PROG_PARTICIPATION`

## Maintenance Notes

- If new codes are added to lookup tables, ensure joins remain valid and descriptions are surfaced.
- Monitor for changes in form structure, especially around assessment scoring and eligibility logic.
- Consider surfacing null flags or diagnostic hooks for missing assessments or grant mismatches.

## Deprecated Fields (Retained for Legacy Reporting)

The following fields were removed from `PWBCRINITIALCONTACT` form as of 2025-11-19 but remain in the view definition to support legacy reporting:

- `PREGNANT_IC`
- `PREG_CHILD_LAST_90_IC`

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

- **2025-12-18**: Changes `LEFT JOIN Q_CLIENT_BHN AS [C] ON BIC.CLIENTNUMBER = C.CLIENT_NUMBER` to `INNER JOIN Q_CLIENT_BHN AS [C] ON BIC.CLIENTNUMBER = C.CLIENT_NUMBER` to ensure test clients are removed.
- **2025-11-19**: Deprecates fields `PREGNANT_IC` and `PREG_CHILD_LAST_90_IC`. Adds fields `PLANNED_EVENT`, `EVENT_TYPE`, `EVENT_TYPE_OTHER`, `PRIOR_MH_BH_SERVICES`, and `RESIDE_STL_CITY`.
- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-05-16**: Adds initial view definition to support BCR Initial Contact reporting and eligibility tracking.  

</details>
</details>
