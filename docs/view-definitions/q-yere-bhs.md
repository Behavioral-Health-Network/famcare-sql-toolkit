# Q_YERE_BHS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-yere-bhs.sql`  
**Last Updated:** **2025-07-15**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Extracts and consolidates YERE behavioral health service data to enagble reporting on intake and admission status for clients on given enrollments.

## Description

- Extracts Behavioral Health Services form data used to track intake and admission to behavioral health agencies, primarily CMHCs and CBHOs.
- Supports analysis of service connection, agency attribution, and admission outcomes.
- Includes metadata for:
  - Intake attendance and agency details
  - Admission status and reasons for non-admission
  - Service path and program type
  - Time intervals between key milestones (e.g., intake to admission, admission to first service)
- Joins to:
  - `Q_CLIENT_BHN` for client validation and test client exclusion
  - `CMHC_AGENCY` and `ADA_SU_AGENCY` for intake agency descriptions

### Logic Summary

- **Source Table:**
  - `PWYEREBEHAVIORALHEALTHSERVICESTP`

- **Joins:**
  - `LEFT JOIN Q_CLIENT_BHN` for client metadata
  - `LEFT JOIN CMHC_AGENCY` for mental health intake agency descriptions
  - `LEFT JOIN ADA_SU_AGENCY` for substance use intake agency descriptions

- **Output Fields:**
  - `CLIENT_NUMBER`, `PATHWAY_DATE`, `DOCSERNO`, `EVENT_NAME`
  - Intake flags and agency codes/descriptions
  - Admission status and reasons
  - Time intervals for intake and service connection

## Maintenance Notes

- If new intake types or agency codes are introduced, ensure lookup tables (`CMHC_AGENCY`, `ADA_SU_AGENCY`) are updated and joined appropriately.
- Monitor for changes in field naming or form structure that could affect output consistency.
- Confirm that `DOCREVNO = ' 0 '` remains the correct filter for current records.

## Changelog

- **2025-07-15**: Initial view definition authored.
