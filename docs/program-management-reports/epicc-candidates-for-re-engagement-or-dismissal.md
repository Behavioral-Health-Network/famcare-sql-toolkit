# EPICC Candidates for Re-Engagement or Dismissal

**Category:** Program Management  
**Source File:** `code/program-management-reports/epicc-candidates-reengagement-dismissal.sql`  
**Last Updated:** 2025-08-13  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Identifies EPICC clients who are candidates for either dismissal or re-engagement based on milestone participation, client status, and treatment path progression. Supports program management decision-making by surfacing clients who may require outreach to re-engage or closure, in alignment with contractual obligations and workflow expectations.

## Key Metrics

- Aggregates program participation and client status across Referral, Initial Contact, 2-Week, 30-Day, 3-Month, and 6-Month milestones.
- Includes staff assignment and enrollment start date for follow-up context.
- Includes most recent treatment path for context.
- Surfaces milestone-specific program participation and client status fields to assist with identifying appropriate candidates for transfer to re-engagement and those whose enrollment should be dismissed.
- Uses `HAVING` clause to flexibly include clients with partial milestone completion.

## Filters

- Includes only active enrollments (`ENROLLMENT_ENDING_DATE IS NULL`) for EPICC Pathway ID `55320240807113504583`.
- Excludes test clients via `Q_CLIENT_BHN`.
- Uses `HAVING` clause to apply tiered milestone logic and re-engagement detection.

## Changelog

- **2025-08-12**: Merged dismissal and re-engagement logic back into unified report at the request of EPICC leadership staff; added re-engagement detection condition to the `HAVING` clause; updated joins to use `Q_PROVIDERPLACEMENT_BHN` with `LEFT JOIN` to accommodate imported rows. `ENROLLMENT_STARTING_DATE` and other columns were updated to reflect the naming in the view.
- **2025-08-06**: Fixes problematic joins to `PATHWAYCLIENT` and `PATHWAYEVENTCLIENT` by copying the join logic from `Q_EPICC_PATHCLIENT_ENROLLMENTS`. The original join to `PATHWAYCLIENT` was not capable of accurately distinguishing between imported enrollments and enrollments begun using the front-end `PROVIDERPLACEMENT` form, and at least one `PROGRAM_PARTICIPATION_IC` value from a different enrollment was being joined into another enrollment, resulting in a false positive showing; also adds `PP.ENDINGDATE IS NULL` to ensure that only clients with active enrollments may be considered for dismissal.
- **2025-08-01**: Added changelog and documentation Markdown.
- **2025-07-29**: SQL query refactored to exclude candidates for re-engagement in favor of focusing on candidates for dismissal-only and including all milestones through the six-month follow-up, again per specifications from the Data Team staff.
- **2025-05-13**: Initial SQL query authored intended to include candidates for re-engagement or dismissal but looking only through the thirty-day follow-up per specifications from the Data Team staff.
