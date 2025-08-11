# Q_COMPLEX_CARE_PATHWAY_FORM_DOCSERNOS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-complex-care-pathway-form-docsernos.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Consolidates DOCSERNO values from all Complex Care Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWCOMPLEXCAREROSTER` (Roster)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients.
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All Complex Care form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `FORM_TYPE`

## Maintenance Notes

- If new Complex Care form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Consider indexing or materializing if used in high-volume reporting.

## Changelog

- **2025-08-11**: Initial Markdown documentation authored.  
- **2025-08-11**: Initial view definition authored.
