# Q_BCR_PATHWAY_FORM_DOCSERNOS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-pathway-form-docsernos.sql`  
**Last Updated:** **2025-05-01**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Unions all Pathway form `DOCSERNO` values to allow for joining to summations to identify intervals at which records have been added based on the Pathway Event of the parent forms.

## Description

- Consolidates DOCSERNO values from multiple BCR Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWBCRREFERRAL` (BCR Referral)
  - `PWBCRINITIALCONTACT` (BCR Initial Contact)
  - `PWBCRREFERRALSPLACED` (BCR Referrals Placed)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`).
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - `PWBCRREFERRAL`, `PWBCRINITIALCONTACT`, `PWBCRREFERRALSPLACED`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `FORM_TYPE`

## Maintenance Notes

- If new BCR form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Monitor for changes in source table structures that could affect field availability or naming.

## Changelog

- **2025-05-01**: Initial view definition authored.
