# Q_EPICC_PATHWAY_FORM_DOCSERNOS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-epicc-pathway-form-docsernos.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Consolidates DOCSERNO values from all EPICC Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWEPICCREFERRAL` (Referral)
  - `PWEPICCINITIALCONTACT` (Initial Contact)
  - `PWEPICC2WEEKFOLLOWUP` (2-Week Follow-Up)
  - `PWEPICC30DAYFOLLOWUP` (30-Day Follow-Up)
  - `PWEPICC3MONTHFOLLOWUP` (3-Month Follow-Up)
  - `PWEPICC6MONTHFOLLOWUP` (6-Month Follow-Up)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients.
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `TREATMENT_PATH` (nullable; populated only when present on form)
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All EPICC form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `TREATMENT_PATH`, `FORM_TYPE`

## Maintenance Notes

- If new EPICC form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in source table structures, especially `TREATMENT_PATH` field naming.
- Consider indexing or materializing if used in high-volume reporting.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.
- **2025-05-01**: Initial view definition authored.
