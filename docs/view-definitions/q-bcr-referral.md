---
front-matter-title: Q_BCR_REFERRAL
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-referral.sql
last_updated: 2025-12-18
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - sql-view
  - pathway-event
  - tag2
dependencies:
  - name: pwbcrreferral
    type: html
    repo: famcare-html-form-code
  - name: pwbcrreferral
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

# Q_BCR_REFERRAL

## Purpose

Extracts and consolidates BCR Referral form data for reporting, eligibility tracking, and program evaluation.

## Description

- Extracts and consolidates BCR referral data from multiple sources.
- Built on top of `PWBCRREFERRAL`, filtered to include only active records (`DOCREVNO = ' 0 '`).
- Joins to `Q_CLIENT_BHN` to retrieve client names, excluding test clients.
- Returns a comprehensive dataset for reporting and analysis, including:
  - Referral source details
  - Client demographics
  - Housing status

### Logic Summary

- **Primary Source:** `PWBCRREFERRAL`
  - Filters to active records.
  - Includes referral metadata and client linkage.

- **Joins:**
  - `Q_CLIENT_BHN` for client first and last names.
  - `BCR_PROG_PARTICIPATION` for descriptive program participation labels (retained but deprecated).

- **Output Fields:**
  - Referral source type and name.
  - Client acquisition data ('How did caller or client hear about Bridges to Care & Recovery?')
  - Housing status.

## Deprecated Fields (Retained for Legacy Reporting)

The following fields were removed from `PWBCRREFERRAL` form as of 2025-11-19 but remain in the view definition to support legacy reporting:

- `METHOD_REFERRAL`  
- `REF_THROUGH_EVENT`  
- `BCR_REF_EVENT`  
- `OTHER_EVENT_EXP`  
- `PREV_MH_BH_SERVICES`  
- `PREGNANT_AT_REF`  
- `PREG_OR_CHILD_LAST_NINETY`  
- `MARITAL_STATUS_REF`  
- `RESIDE_IN_STL_CITY`  
- `BCR_PROG_PARTICIPATION AS [BCR_PROGRAM_PARTICIPATION_CODE]`  
- `PART.DESCRIPTION AS [BCR_PROGRAM_PARTICIPATION_DESCRIPTION]`  
- `BCR_REASON_INELIGIBLE_REF`  
- `OTHER_REASON_INELIGIBLE`  

> **Note:** The join `LEFT JOIN BCR_PROG_PARTICIPATION AS [PART] ON BREF.BCR_PROG_PARTICIPATION = PART.CODE` is also retained but deprecated.

## Maintenance Notes

- If new referral source types or program codes are added, update the join logic and field mappings accordingly.
- Ensure that `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in `PWBCRREFERRAL` structure that could affect field availability or naming.

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

- **2025-11-20**: Deprecates but retains fields `METHOD_REFERRAL`, `REF_THROUGH_EVENT`, `BCR_REF_EVENT`, `PREV_MH_BH_SERVICES`, `PREGNANT_AT_REF`, `PREG_OR_CHILD_LAST_NINETY`, `MARITAL_STATUS_REF`, `RESIDE_IN_STL_CITY`, `BCR_PROG_PARTICIPATION AS [BCR_PROGRAM_PARTICIPATION_CODE]`, `PART.DESCRIPTION AS [BCR_PROGRAM_PARTICIPATION_DESCRIPTION]`, `BCR_REASON_INELIGIBLE_REF`, `OTHER_REASON_INELIGIBLE`. Retains but deprecates `LEFT JOIN BCR_PROG_PARTICIPATION AS [PART] ON BREF.BCR_PROG_PARTICIPATION = PART.CODE`.
- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-05-16**: Adds initial view definition.  

</details>
</details>
