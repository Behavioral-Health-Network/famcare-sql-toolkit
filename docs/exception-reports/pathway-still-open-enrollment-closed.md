# Pathway Still Open Enrollment Closed

**Category:** Exception Reports  
**Source File:** `code/exception-reports/pathway-still-open-enrollment-closed.sql`  
**Last Updated:** 2025-08-09  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Flags cases where a client's Pathway remains open while their program enrollment has already ended. This report supports timely Pathway closure and ensures alignment between enrollment status and case management records.

## Logic Summary

- **Pathway Status Check**
  - Includes clients with open Pathways (`PATHWAYCLIENT.ENDDATE IS NULL`).
- **Enrollment Status Check**
  - Requires closed enrollments (`Q_PROVIDERPLACEMENT_BHN.ENROLLMENT_ENDING_DATE IS NOT NULL`).
- **Client Filtering**
  - Excludes test clients via join to `Q_CLIENT_BHN`.
- **Join Alignment**
  - Matches Provider Placement to Pathway via `DOCSERNO` and `STARTDATE`.
- **Staff Attribution**
  - Includes worker and supervisor via `Q_HRFORM`.
- **Optional Filtering**
  - Supports program-level filtering via `PROVIDERCODE` (commented out in current query).

## Usage Notes

- Intended for internal review and staff remediation.
- Useful for identifying stale Pathways that may require manual closure.
- Review regularly to ensure joins reflect current data structures and business rules.

## Changelog

- **2025-08-09**: Added `ENROLLMENT_ENDING_DATE` to SELECT and `CLIENT_LAST` to ORDER BY.
- **2025-08-09**: Corrected logic to flag open Pathways with closed enrollments (previously reversed).
- **2025-08-09**: Fixed join between Provider Placement and Pathway tables to ensure accurate matching.
- **2025-05-03**: Initial SQL query authored.
