---
front-matter-title: Q_EPICC_IC
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-ic.sql
last_updated: 2025-10-02
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
  - name: pwepiccinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwepiccinitialcontact
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

# Q_EPICC_IC

## Purpose

Extracts and consolidates EPICC Initial Contact form data for reporting, eligibility tracking, and program evaluation.

## Description

- Captures client-level data related to EPICC engagement, referral sources, MAT history, and overdose events.
- Enriches coded fields with descriptive metadata from multiple lookup tables.
- Supports analysis of referral pathways, MAT initiation points, and substance use patterns.

### Logic Summary

- **Source Table:**
  - `PWEPICCINITIALCONTACT` (aliased as `EIC`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client names and test client exclusion
  - `LEFT JOIN EPICC_PROGRAM_PARTICIPATION` for program participation descriptions
  - `LEFT JOIN COMMUNITY_REFERRAL_SOURCE` for referral source descriptions
  - `LEFT JOIN EPICC_TYPES_MAT` (aliased three times) for MAT type descriptions:
    - `CURRENT_SCRIPT_MAT_TYPE`
    - `WHAT_MAT_INITIATED_HOSPITAL`
    - `WHAT_MAT_SCRIPT_DISCHARGE`

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Contact metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Referral and outreach: multiple “HEARD_ABOUT_FROM_” flags, referral source codes and descriptions
  - MAT tracking: current, hospital-initiated, and discharge MAT types
  - Overdose history: event flags, location, count, and date
  - Substance use: opioid and non-opioid flags, treatment history
  - Eligibility and transfer: region, contact success, and reasons for ineligibility
  - Notes and assessments: `PRESENTING_NOTES_IC`, consent flags, screening outcomes

## Maintenance Notes

- If new MAT types or referral sources are introduced, ensure lookup tables are updated and joins remain valid.
- Monitor for changes in form structure, especially around overdose tracking and eligibility flags.
- Consider surfacing diagnostic flags for missing MAT descriptions or ambiguous referral pathways.

## Changelog

- **2025-10-02**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.
- **2025-05-05**: Adds initial view definition to support EPICC Initial Contact reporting and MAT tracking.
