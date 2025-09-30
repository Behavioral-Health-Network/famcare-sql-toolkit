---
front-matter-title: Q_BCR_REFERRAL
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-referral.sql
last_updated: 2025-09-30
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - tag1
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
- Joins to `BCR_PROG_PARTICIPATION` to include descriptive labels for program participation codes.
- Returns a comprehensive dataset for reporting and analysis, including:
  - Referral source details
  - Client demographics
  - Program participation
  - Eligibility and housing status

### Logic Summary

- **Primary Source:** `PWBCRREFERRAL`
  - Filters to active records.
  - Includes referral metadata and client linkage.

- **Joins:**
  - `Q_CLIENT_BHN` for client first and last names.
  - `BCR_PROG_PARTICIPATION` for descriptive program participation labels.

- **Output Fields:**
  - Referral method, source type, and event linkage.
  - Client status indicators (e.g., pregnant, marital, housing).
  - Participation and eligibility details.

## Maintenance Notes

- If new referral source types or program codes are added, update the join logic and field mappings accordingly.
- Ensure that `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in `PWBCRREFERRAL` structure that could affect field availability or naming.

## Changelog

- **2025-09-30**: Adds `TIEDENROLLMENT` field to provide a DOCSERNO that may be used for joining to the PATHWAYCLIENT DOCSERNO directly.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-05-16**: Adds initial view definition.  
