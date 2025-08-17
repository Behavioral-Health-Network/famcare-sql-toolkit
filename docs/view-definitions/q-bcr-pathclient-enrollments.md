# Q_BCR_PATHCLIENT_ENROLLMENTS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-pathclient-enrollments.sql`  
**Last Updated:** **2025-07-09**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Joins client enrollment, Pathway core forms, and the Pathway Event data collection forms to enable program management and to allow for reporting on program outcomes.

## Description

- Consolidates client enrollment and event-level form data for the BCR Pathway.
- Anchored in `PROVIDERPLACEMENT` (PP) as the enrollment source.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when enrollment DOCSERNO matches pathway DOCSERNO.
  - **Enrollment/Start Date Join**: Fallback logic for mismatches (e.g., imports).
- Joins to `PATHWAYEVENTCLIENT` (PEC) and `PATHWAYEVENT` (PE) for event-level metadata.
- Left joins to filtered views of BCR-specific forms to avoid row inflation.
- Includes form-level metadata:
  - `PATHWAY_DATE`, `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`
  - `PROGRAM_PARTICIPATION`
- Filters to `DOCREVNO = ' 0 '` across all relevant tables to suppress legacy versions.
- Filters to Pathway ID `55320240917145557321` (BCR).

### Logic Summary

- **Source Tables:**
  - `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - BCR form views: `Q_BCR_REFERRAL`, `Q_BCR_IC`, `Q_BCR_REF_PLACED`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `INNER JOIN PATHWAYCLIENT` using dual logic (DOCSERNO or start date alignment)
  - `INNER JOIN PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - `LEFT JOIN Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`
  - `LEFT JOIN` to BCR form views using `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME`

- **Output Fields:**
  - Client identifiers and names
  - Enrollment and pathway dates
  - Event metadata and form DOCSERNOs
  - Program participation descriptions
  - Program worker and agency details

## Maintenance Notes

- If new BCR event types or forms are introduced, extend the CASE logic and join structure accordingly.
- Ensure form views remain filtered to `DOCREVNO = ' 0 '` and include `EVENT_NAME` for alignment.
- Monitor for changes in event naming conventions that could affect CASE logic or join keys.
- Consider indexing `PATHWAYEVENTCLIENT` and form views on `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME` for performance.

## Changelog

- **2025-07-13**: Replaced direct `INNER JOIN` to `PATHWAYCLIENT` with dual `JOIN` strategy using DOCSERNO and enrollment/start date alignment.
- **2025-07-13**: Added logic to trace enrollment-to-pathway attribution, consistent with YERE and EPICC view architecture.
- **2025-07-09**: Initial view definition authored.
