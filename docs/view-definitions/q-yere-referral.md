---
front-matter-title: Q_YERE_REFERRAL
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-referral.sql
last_updated: 2025-10-02
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

# Q_YERE_REFERRAL

## Purpose

Extracts and consolidates YERE referral data for reporting, eligibility tracking, and program evaluation. Includes client metadata, referral sources, CMHC/ADA status, and housing context.

## Description

- Pulls structured data from the `PWYEREREFERRAL` form.
- Enriches coded fields with descriptive metadata from multiple lookup tables.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of referral pathways, agency involvement, and client eligibility.

### Logic Summary

- **Source Table:**
  - `PWYEREREFERRAL` (aliased as `YREF`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN PROGRAM_REFERRAL_SOURCES` for hospital referral descriptions
  - `LEFT JOIN CIMOR_STATUS` for CMHC and ADA status descriptions
  - `LEFT JOIN CMHC_AGENCY` and `ADA_SU_AGENCY` for agency descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Referral metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `CALLERS_FIRST_LAST_NAME`, `REFERRED_FROM`
  - Referral sources: hospital, CMHC, ADA, and other agency flags
  - Eligibility and program participation: CMHC/ADA/DD status, ineligibility reason
  - Notes and context: suicide attempt flag, housing status, primary reason

## Maintenance Notes

- If new referral codes or agency types are introduced, ensure lookup tables are updated and joins remain valid.
- Monitor for changes in form structure, especially around eligibility flags and referral source logic.
- Consider surfacing diagnostic flags for missing referral descriptions or ambiguous agency matches.

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
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-02**: Switches to `Q_CLIENT_BHN` for client details and test client exclusion.  
- **2025-06-13**: Renames table alias from `REF` to `YREF`.  
- **2025-05-23**: Adds initial view definition to support YERE referral reporting and agency involvement tracking.

</details>
</details>
