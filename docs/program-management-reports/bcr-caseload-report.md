# BCR Caseload Report

**Category:** Program Management  
**Source File:** `code/program-management-reports/bcr-caseload-report.sql`  
**Last Updated:** 2025-08-11  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Summarizes BCR program client caseloads, including enrollment, worker assignment, agency, milestone completion status (Initial Contact, Referrals Placed), payor source status, housing status, and program participation and grant funding source from the Initial Contact form.

## Key Metrics

- Aggregates milestone completion dates, days until due, and overdue status for Initial Contact and Referrals Placed.
- Tracks assigned program worker, enrollment date, and agency for each client.
- Surfaces program participation and grant source from Initial Contact.
- Flags uninsured and unhoused status using active payor and housing tables.
- Ensures demographic accuracy via joins to client table.

## Filters

- Filters to active enrollments (`ENROLLMENT_ENDING_DATE IS NULL`).
- Optional date range filtering for FAMCare integration (commented logic for `START RANGE|DATEPICKER`).

## Changelog

- **2025-08-11**: Updates to add grant description in the `GRANT_FROM_IC` column.
- **2025-08-11**: Initial Markdown documentation authored.
- **2025-07-08**: Initial SQL query authored.
