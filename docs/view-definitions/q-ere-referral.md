---
front-matter-title: Q_ERE_REFERRAL
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-referral.sql
last_updated: 2025-09-30
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - tag1
  - tag2
dependencies:
  - name: pwerereferral
    type: html
    repo: famcare-html-form-code
  - name: pwerereferral
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

# Q_ERE_REFERRAL

## Purpose

Extracts and consolidates ERE referral data for reporting, eligibility tracking, and program evaluation. Includes client metadata, referral sources, employment status, and ineligibility flags.

## Description

- Pulls structured data from the `PWEREREFERRAL` form.
- Joins with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Enriches coded fields with descriptive metadata from referral source, employment status, and ineligible status tables.

### Logic Summary

- **Source Table:**
  - `PWEREREFERRAL` (aliased as `EREREF`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN PROGRAM_REFERRAL_SOURCES` for referring agency descriptions
  - `LEFT JOIN ERE_EMPLOY_STATUS` for employment status descriptions
  - `LEFT JOIN ERE_INELIGIBLE_STATUS` for ineligible reason descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Referral metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `CALLER_NAME`, `REFERRAL_METHOD`
  - Referral sources: agency code and description, patient location, IP hospital
  - Eligibility: flags for EPICC referral, client eligibility, ineligible reason and description
  - Employment and military status
  - Engagement: `CLIENT_ENGAGE`

## Maintenance Notes

- Monitor for changes in referral source codes and ensure lookup tables remain aligned.
- Consider surfacing diagnostic flags for ambiguous eligibility or missing referral reasons.
- Align naming conventions with other ERE views for consistency across reporting layers.

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

- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation to support standardized view tracking.  
- **2025-07-16**: Adds initial view definition to support ERE referral reporting and eligibility tracking.

</details>
</details>
