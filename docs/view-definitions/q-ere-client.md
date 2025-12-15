---
front-matter-title: Q_ERE_CLIENT
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-client.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - client-view
  - tag2
dependencies:
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: q-providerplacement-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: providerplacement
    type: html
    repo: famcare-html-form-code
  - name: providerplacement
    type: table
    repo: none
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_ERE_CLIENT

## Purpose

Provides a filtered client reference view for individuals enrolled in the ERE program. Supports program-specific reporting, diagnostics, and cross-system linkage.

## Description

- Filters clients based on ERE program enrollment (`PROGRAM_CODE = '100033'`)
- Inherits all demographic and contact fields from `Q_CLIENT_BHN`
- Ensures test clients are excluded via upstream logic in `Q_CLIENT_BHN`
- Enables linkage to provider placement and county-level analysis

### Logic Summary

- **Source View:**
  - `Q_CLIENT_BHN` (aliased as `C`)

- **Join:**
  - `INNER JOIN Q_PROVIDERPLACEMENT_BHN` (aliased as `PP`) to filter by program code

- **Key Filters:**
  - `PROGRAM_CODE = '100033'` to isolate ERE clients

- **Output Fields:**
  - All fields inherited from `Q_CLIENT_BHN`, including:
    - Client metadata: `CLIENT_NUMBER`, `CLIENT_NAME`, `BIRTH_DATE`, `GENDER`, `RACE`, `ETHNICITY`
    - Contact info: address, phone numbers, email
    - Identifiers: MRNs, SSN
    - County info: code and description

## Maintenance Notes

- If ERE program code changes, update the filter to reflect new values.
- Confirm that `Q_CLIENT_BHN` remains aligned with upstream logic for race, suffix, and test client exclusion.
- Consider surfacing a diagnostic for ERE clients missing MRNs or with ambiguous placement records.

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

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-23**: Updates to use `Q_CLIENT_BHN` instead of `Q_CLIENT` for test client exclusion and standardized field naming.  
- **2025-07-02**: Adds initial view definition to support ERE-specific client reporting.

</details>
</detials>
