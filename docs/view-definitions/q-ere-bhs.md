# Q_ERE_BHS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-ere-bhs.sql`  
**Last Updated:** **2025-07-22**  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Extracts Behavioral Health Service form data used to track admission to behavioral health agencies for ERE clients.
- Focuses on documenting whether clients were admitted to services and which agencies facilitated those admissions.
- Includes metadata for:
  - Mental health and substance use admission flags
  - Agency codes and descriptions
  - Admission dates for both domains
- Joins to:
  - `Q_CLIENT_BHN` for client validation and test client exclusion
  - `CMHC_AGENCY` and `ADA_SU_AGENCY` for agency descriptions

### Logic Summary

- **Source Table:**
  - `PWEREBEHAVIORALHEALTHSERVICE`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata
  - `LEFT JOIN CMHC_AGENCY` for mental health agency descriptions
  - `LEFT JOIN ADA_SU_AGENCY` for substance use agency descriptions

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `EVENT_NAME`
  - Admission flags and agency codes/descriptions
  - Admission dates for mental health and substance use services

## Maintenance Notes

- If new agency codes are introduced, ensure lookup tables (`CMHC_AGENCY`, `ADA_SU_AGENCY`) are updated and joined appropriately.
- Monitor for changes in field naming or form structure that could affect output consistency.
- Confirm that `DOCREVNO = ' 0 '` remains the correct filter for current records.

## Changelog

- **2025-07-22**: Initial view definition authored to support admission tracking for ERE behavioral health services.
