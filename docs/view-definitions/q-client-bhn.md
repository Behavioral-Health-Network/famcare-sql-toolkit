# Q_CLIENT_BHN

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-client-bhn.sql`  
**Last Updated:** **2025-08-09**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

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

## Maintenance Notes

- If race codes or suffix logic change, ensure `dbo.RaceList` and `FAMILYSUFFIX` remain aligned.
- Confirm that `CLIENTPASSPORT` subquery logic reflects current ID types and naming conventions.
- Consider surfacing a diagnostic for clients with missing MRNs or ambiguous race codes.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.
- **2025-06-28**: Initial view definition authored to support BHN-wide client reference logic and test client exclusion.
