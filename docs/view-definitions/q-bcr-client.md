---
front-matter-title: Q_BCR_CLIENT
category: view-definitions
category_label: View Definitionssource_file: code/view-definitions/q-bcr-client.sql
last_updated: 2026-05-14
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - client-view
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_BCR_CLIENT

## Purpose

Provides a filtered client reference view for individuals enrolled in the BCR program. Supports program-specific reporting, diagnostics, and cross-system linkage. This view supports BCR‑specific reporting, operational diagnostics, and downstream lineage workflows by exposing a standardized, BHN‑aligned client record.

## Description

- Filters clients based on BCR program enrollment (`PROGRAM_CODE = '100005'`)
- Inherits all demographic and contact fields from `Q_CLIENT_BHN`
- Ensures test clients are excluded via upstream logic in `Q_CLIENT_BHN`
- Enables linkage to provider placement and county-level analysis

### Logic Summary

- **Source View:**
  - `Q_CLIENT_BHN` (aliased as `C`)

- **Join:**
  - `INNER JOIN Q_PROVIDERPLACEMENT_BHN` (aliased as `PP`) to filter by program code

- **Key Filters:**
  - `PROGRAM_CODE = '100005'` to isolate BCR clients

## Columns Returned

| Column | Description |
|--------|-------------|
| `ID` | Internal BHN client record identifier |
| `DOCSERNO` | Document serial number for the client record |
| `VISIT_DATE` | Date portion of the visit timestamp |
| `VISIT_TIME` | Time portion of the visit timestamp |
| `ENTRY_DATE` | Date the client record was entered |
| `USERID` | User who created or last updated the record |
| `CLIENT_STATUS` | Status flag for the client |
| `CLIENT_INDICATOR` | Additional client classification indicator |
| `CLIENT_NUMBER` | Canonical BHN client identifier |
| `CLIENT_NAME` | Full client name |
| `CLIENT_LAST` | Last name |
| `CLIENT_FIRST` | First name |
| `MI` | Middle initial |
| `SUFFIX` | Name suffix |
| `NICKNAME` | Preferred name |
| `BIRTH_DATE` | Date of birth |
| `GENDER_CODE` | Gender code |
| `GENDER_DESCRIPTION` | Gender description |
| `RACE_CODE` | Race code |
| `RACE_DESCRIPTION` | Race description |
| `ETHNICITY_CODE` | Ethnicity code |
| `ETHNICITY_DESCRIPTION` | Ethnicity description |
| `MRN_MERCY` | Mercy medical record number |
| `MRN_BJC` | BJC medical record number |
| `MRN_SSM` | SSM medical record number |
| `SSN` | Social Security Number (full) |
| `SSN_LAST_FOUR` | Last four digits of SSN |
| `ETO_CASE_NUM` | Legacy ETO case number |
| `STREET` | Street address line 1 |
| `STREET2` | Street address line 2 |
| `CITY` | City |
| `STATE` | State |
| `ZIP_CODE` | ZIP code |
| `COUNTY_CODE` | County code |
| `COUNTY_DESCRIPTION` | County description |
| `PRIMARY_PHONE` | Primary phone number |
| `CELL_PHONE` | Cell phone number |
| `WORK_PHONE` | Work phone number |
| `CLIENT_EMAIL` | Email address |
| `FACM` | FACM indicator (if applicable) |

## Maintenance Notes

- If BCR program code changes, update the filter to reflect new values.
- Confirm that `Q_CLIENT_BHN` remains aligned with upstream logic for race, suffix, and test client exclusion.
- Consider surfacing a diagnostic for BCR clients missing MRNs or with ambiguous placement records.

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
- **2025-07-28**: Adds initial Markdown documentation.
- **2025-07-23**: Updates to use `Q_CLIENT_BHN` instead of `Q_CLIENT` for test client exclusion and standardized field naming.  
- **2025-06-10**: Adds initial view definition to support BCR-specific client reporting.

</details>
</details>
