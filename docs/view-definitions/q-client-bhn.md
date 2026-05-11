---
front-matter-title: BHN Clients View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-client-bhn.sql
last_updated: 2026-03-19
status: active
lifecycle: production
program_scope: multi
programs:
  - bcr
  - complex-care
  - epicc
  - ere
  - yere
tags:
  - client-view
  - tag2
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# BHN Clients View Definition

## Purpose

Provides a clean, locally customized client reference view for use across BHN reporting and diagnostics. Excludes test clients and includes only fields relevant to local implementation.

## Description

- Adapts logic from the vendor’s `Q_CLIENT` view.
- Filters out test clients and inactive records.
- Renames fields to snake_case for compatibility with R and other downstream tools.
- Enriches coded fields with descriptive metadata for gender, race, ethnicity, and county.
- Includes client identifiers from `CLIENTPASSPORT` for cross-system linkage.

### Logic Summary

- **Source Table:**
  - `CLIENT` (aliased as `C`)

- **Joins:**
  - `LEFT JOIN FAMILYSUFFIX` for suffix descriptions
  - `LEFT JOIN GENDER` for gender descriptions
  - `LEFT JOIN ETHNICITY` for ethnicity descriptions
  - `LEFT JOIN COUNTIES` for county descriptions
  - `LEFT JOIN CLIENTPASSPORT` (subquery) for MRNs and SSNs

- **Key Filters:**
  - `CLIENTINDICATOR = 'ON'` to include only active clients
  - `DOCREVNO = ' 0 '` to isolate current records
  - `LASTNAME NOT IN ('GVTTest', 'GVTest', 'GVTTEST')` to exclude test clients

- **Special Logic:**
  - Uses `dbo.RaceList(C.RACE)` to convert race codes into comma-separated descriptions
  - Handles edge cases for race code `'6'` (Other) and missing/placeholder codes

- **Output Fields:**
  - Client metadata: `CLIENT_NUMBER`, `CLIENT_NAME`, `BIRTH_DATE`, `GENDER`, `RACE`, `ETHNICITY`
  - Contact info: address, phone numbers, email
  - Identifiers: MRNs (Mercy, BJC, SSM), SSN, SSN last four
  - County info: code and description
  - Geocoded metadata: `LONGITUDE` and `LATITUDE`

## Maintenance Notes

- If race codes or suffix logic change, ensure `dbo.RaceList` and `FAMILYSUFFIX` remain aligned.
- Confirm that `CLIENTPASSPORT` subquery logic reflects current ID types and naming conventions.
- Consider surfacing a diagnostic for clients with missing MRNs or ambiguous race codes.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-19**: Adds `LONGITUDE` and `LATITUDE`.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-10-17**: Adds column `ETO_CASE_NUM` from `LegacyID` column on `CLIENTPASSPORT` table.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-06-28**: Adds initial view definition to support BHN-wide client reference logic and test client exclusion.

</details>
</details>
<!---CHANGELOG-END--->
