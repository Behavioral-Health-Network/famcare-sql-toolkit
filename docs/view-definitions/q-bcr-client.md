# Q_BCR_CLIENT

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-client.sql`  
**Last Updated:** **2025-08-09**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Provides a filtered client reference view for individuals enrolled in the BCR program. Supports program-specific reporting, diagnostics, and cross-system linkage.

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

- **Output Fields:**
  - All fields inherited from `Q_CLIENT_BHN`, including:
    - Client metadata: `CLIENT_NUMBER`, `CLIENT_NAME`, `BIRTH_DATE`, `GENDER`, `RACE`, `ETHNICITY`
    - Contact info: address, phone numbers, email
    - Identifiers: MRNs, SSN
    - County info: code and description

## Maintenance Notes

- If BCR program code changes, update the filter to reflect new values.
- Confirm that `Q_CLIENT_BHN` remains aligned with upstream logic for race, suffix, and test client exclusion.
- Consider surfacing a diagnostic for BCR clients missing MRNs or with ambiguous placement records.

## Changelog

- **2025-07-23**: Updated to use `Q_CLIENT_BHN` instead of `Q_CLIENT` for test client exclusion and standardized field naming.  
- **2025-06-10**: Initial creation to support BCR-specific client reporting.
