# Q_EPICC_PATHCLIENT_ENROLLMENTS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-epicc-pathclient-enrollments.sql`  
**Last Updated:** **2025-05-07**  
**Author:** BHN Data Team  

## Purpose

Encapsulate reusable logic for reporting or downstream joins.

## Description

- Consolidates client enrollment and event-level form data for the EPICC Pathway.
- Anchored in `PROVIDERPLACEMENT` (PP) as the enrollment source.
- Resolves attribution to `PATHWAYCLIENT` (PC) using dual logic:
  - **DOCSERNO Join**: Preferred linkage when enrollment DOCSERNO matches pathway DOCSERNO.
  - **Enrollment/Start Date Join**: Fallback logic for mismatches (e.g., imports).
- Joins to `PATHWAYEVENTCLIENT` (PEC) and `PATHWAYEVENT` (PE) for event-level metadata.
- Left joins to filtered views of EPICC-specific forms to avoid row inflation.
- Uses `COALESCE` and `[ENROLL_PATH_JOIN_SOURCE]` to trace attribution logic.
- Includes form-level metadata:
  - `PATHWAY_DATE`, `PE_DATE_ACCOMPLISHED`, `DAYS_UNTIL_FORM_DUE`
  - `TREATMENT_PATH`, `PROGRAM_PARTICIPATION`, `PRO_OR_CORE`
- Filters to `DOCREVNO = ' 0 '` across all relevant tables to suppress legacy versions.
- Filters to Pathway ID `55320240807113504583` (EPICC).

### Logic Summary

- **Source Tables:**
  - `PROVIDERPLACEMENT`, `PATHWAYCLIENT`, `PATHWAYEVENTCLIENT`, `PATHWAYEVENT`, `PATHWAY`
  - EPICC form views: `Q_EPICC_REFERRAL`, `Q_EPICC_IC`, `Q_EPICC_TWO_WEEK`, `Q_EPICC_THIRTY_DAY`, `Q_EPICC_THREE_MONTH`, `Q_EPICC_SIX_MONTH`

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client validation and test client exclusion
  - `LEFT JOIN PATHWAYCLIENT` (dual logic)
  - `INNER JOIN PATHWAYEVENT`, `PATHWAY`
  - `LEFT JOIN Q_PROVIDER`, `Q_HRFORM`, `CLOSINGREASONS`
  - `LEFT JOIN` to EPICC form views using `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME`

- **Output Fields:**
  - Client identifiers and names
  - Enrollment and pathway dates
  - Attribution source (`ENROLL_PATH_JOIN_SOURCE`)
  - Event metadata and form DOCSERNOs
  - Treatment path and program participation descriptions
  - Program worker and agency details

## Maintenance Notes

- If new EPICC event types or forms are introduced, extend the CASE logic and join structure accordingly.
- Ensure form views remain filtered to `DOCREVNO = ' 0 '` and include `EVENT_NAME` for alignment.
- Monitor for changes in event naming conventions that could affect CASE logic or join keys.
- Consider indexing `PATHWAYEVENTCLIENT` and form views on `CLIENT_NUMBER`, `PATHWAY_DATE`, and `EVENT_NAME` for performance.

## Changelog

- **2025-07-13**: Replaced direct `INNER JOIN` to `PATHWAYCLIENT` with dual `LEFT JOIN` strategy using DOCSERNO and enrollment/start date alignment.
- **2025-07-13**: Added column `[ENROLL_PATH_JOIN_SOURCE]` to trace how each enrollment was linked to a pathway.
- **2025-05-07**: Original view definition authored.
