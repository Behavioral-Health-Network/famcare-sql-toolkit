# Q_YERE_PATHWAY_FORM_DOCSERNOS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-yere-pathway-form-docsernos.sql`  
**Last Updated:** **2025-08-09**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Unions all Pathway form `DOCSERNO` values to allow for joining to summations to identify intervals at which records have been added based on the Pathway Event of the parent forms.

## Description

- Consolidates `DOCSERNO` values from all YERE Pathway forms into a unified dataset.
- Uses `UNION ALL` to aggregate records from:
  - `PWYEREREFERRAL` (Referral)
  - `PWYEREHOSPITALVISITNOTE` (Hospital Visit Note)
  - `PWYEREINITIALCONTACT` (Initial Contact)
  - `PWYERE30DAYFOLLOWUPTP` (30-Day Follow-Up)
  - `PWYERE3MONTHFOLLOWUPTP` (3-Month Follow-Up)
  - `PWYERE6MONTHFOLLOWUPTP` (6-Month Follow-Up)
  - `PWYEREBEHAVIORALHEALTHSERVICESTP` (YBHS)
- Joins to `Q_CLIENT_BHN` to validate client existence and exclude test clients.
- Orders results by `CLIENTNUMBER` and `DOCSERNO` to support consistency checks and audit review.
- Standardizes output fields:
  - `CLIENT_NUMBER`
  - `PATHWAY_DATE`
  - `DOCSERNO`
  - `FORM_TYPE`

### Logic Summary

- **Source Tables:**
  - All YERE form tables listed above

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `FORM_TYPE`

## Maintenance Notes

- If new YERE form types are introduced, extend the `UNION ALL` logic to include them.
- Ensure `Q_CLIENT_BHN` continues to exclude test clients to maintain data integrity.
- Confirm that `DOCREVNO = ' 0 '` remains the correct filter for current records.
- Consider indexing or materializing if used in high-volume reporting or audit workflows.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.
- **2025-05-01**: Initial view definition authored.
