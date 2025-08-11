# Q_ERE_PATHWAY_FORM_DOCSERNOS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-ere-pathway-form-docsernos.sql`  
**Last Updated:** **2025-08-08**  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Consolidates DOCSERNO values from all ERE Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWEREREFERRAL` (Referral)
  - `PWEREIHNA` (IHNA)
  - `PWERETHREEMONTHFOLLOWUP` (3-Month Follow-Up)
  - `PWERESIXMONTHFOLLOWUP` (6-Month Follow-Up)
  - `PWEREBEHAVIORALHEALTHSERVICE` (BHS)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients.
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All ERE form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `FORM_TYPE`

## Maintenance Notes

- If new ERE form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Confirm that `DOCREVNO = ' 0 '` remains the correct filter for current records.
- Consider adding ordering logic if used in audit workflows or form sequencing.

## Changelog

- **2025-08-08**: Initial Markdown documentation authored.
- **2025-07-23**: Initial view definition authored.
