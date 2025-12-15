---
front-matter-title: Q_BCR_REF_PLACED
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-ref-placed.sql
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
  - name: pwbcrreferralsplaced
    type: html
    repo: famcare-html-form-code
  - name: pwbcrreferralsplaced
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

# Q_BCR_REF_PLACED

## Purpose

Extracts and consolidates BCR Referrals Placed form data for reporting, eligibility tracking, and program evaluation.

## Description

- Extracts and consolidates BCR referral placement data from multiple sources.
- Built on top of `PWBCRREFERRALSPLACED`, filtered to include only active records (`DOCREVNO = ' 0 '`).
- Joins to `Q_CLIENT_BHN` for client names, excluding test clients.
- Joins to `BCR_REF_PLACED_AGENCIES` multiple times to retrieve descriptive labels for referral subtypes across domains:
  - Behavioral Health
  - Housing
  - Maternal Health
  - Physical Health
  - Social Services
  - Spiritual Care
- Returns a comprehensive dataset for reporting and analysis, including:
  - Referral types and subtypes
  - Agency involvement
  - Placement dates
  - Client demographics and pathway metadata

### Logic Summary

- **Primary Source:** `PWBCRREFERRALSPLACED`
  - Filters to active records.
  - Includes referral metadata and client linkage.

- **Joins:**
  - `Q_CLIENT_BHN` for client names.
  - `BCR_REF_PLACED_AGENCIES` for descriptive labels across all referral domains.

- **Output Fields:**
  - Referral placement types and subtypes.
  - Agency codes and descriptions.
  - Placement dates per subtype.
  - Client pathway and event metadata.

## Maintenance Notes

- If new referral subtypes or agency codes are introduced, update the join logic and field mappings accordingly.
- Ensure that `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in `PWBCRREFERRALSPLACED` structure that could affect field availability or naming.

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
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-05-16**: Adds initial view definition.

</details>
</details>
