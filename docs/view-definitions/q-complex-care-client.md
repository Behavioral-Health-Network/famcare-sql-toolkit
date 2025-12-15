---
front-matter-title: Q_COMPLEX_CARE_CLIENT
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-client.sql
last_updated: 2025-10-17
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
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

# Q_COMPLEX_CARE_CLIENT

## Purpose

Extracts detailed client information for individuals enrolled in the **Complex Care** program. Supports program-specific reporting, roster validation, and client-level diagnostics.

## Description

- Pulls from `Q_CLIENT_BHN` for demographic and contact details.
- Filters to clients associated with `PROGRAM_CODE = '100034'` (Complex Care).
- Joins with `Q_PROVIDERPLACEMENT_BHN` for program linkage.
- Optionally joins with `Q_COMPLEX_CARE_ROSTER` for roster alignment (non-filtering).

### Logic Summary

- **Program Filter**
  - Restricts to `PROGRAM_CODE = '100034'` via `Q_PROVIDERPLACEMENT_BHN`.

- **Client Join**
  - Uses `CLIENT_NUMBER` to join `Q_CLIENT_BHN` and `Q_PROVIDERPLACEMENT_BHN`.

- **Roster Join**
  - Includes `Q_COMPLEX_CARE_ROSTER` via `LEFT JOIN` for future expansion or validation.

- **Test Client Filtering**
  - Not currently implemented; consider adding exclusion logic based on `CLIENT_LAST` if needed.

## Output Fields

Returns one row per client with full demographic and contact details. Key fields include:

| Field Name            | Description |
|-----------------------|-------------|
| `CLIENT_NUMBER`       | Unique client identifier |
| `CLIENT_NAME`, `CLIENT_FIRST`, `CLIENT_LAST` | Name components |
| `BIRTH_DATE`, `GENDER_DESCRIPTION`, `RACE_DESCRIPTION`, `ETHNICITY_DESCRIPTION` | Demographics |
| `MRN_MERCY`, `MRN_BJC`, `MRN_SSM` | Medical record numbers |
| `SSN`, `SSN_LAST_FOUR` | Social Security details |
| `STREET`, `CITY`, `STATE`, `ZIP_CODE`, `COUNTY_DESCRIPTION` | Address |
| `PRIMARY_PHONE`, `CELL_PHONE`, `WORK_PHONE`, `CLIENT_EMAIL` | Contact info |
| `FACM` | Unknown field—consider documenting purpose if used downstream |

## Usage Notes

- **Roster Join**: `Q_COMPLEX_CARE_ROSTER` is joined but not filtered; may be used for future validation or enrichment.
- **Test Clients**: No exclusion logic currently applied; consider adding if needed for reporting.
- **Field Volume**: Returns full client profile; downstream consumers should select only needed fields.

## Maintenance Notes

- **Program Code Dependency**: Hardcoded to `'100034'`; confirm this remains valid for Complex Care.
- **Join Integrity**: Ensure `CLIENT_NUMBER` remains stable across `Q_CLIENT_BHN`, `Q_PROVIDERPLACEMENT_BHN`, and `Q_COMPLEX_CARE_ROSTER`.
- **Roster Alignment**: If `Q_COMPLEX_CARE_ROSTER` becomes authoritative, consider filtering or flagging mismatches.

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

- **2025-10-17**: Adds column `ETO_CASE_NUM` from `LegacyID` column on `CLIENTPASSPORT` table.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-07-23**: Adds initial view definition to support Complex Care client reporting.

</details>
</details>
