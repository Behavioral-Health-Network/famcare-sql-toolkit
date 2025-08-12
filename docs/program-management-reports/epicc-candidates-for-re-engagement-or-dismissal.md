# EPICC Candidates for Re-Engagement or Dismissal

**Category:** Program Management  
**Source File:** `code/program-management-reports/epicc-candidates-reengagement-dismissal.sql`  
**Last Updated:** 2025-08-12  
**Author:** BHN Data Team  

## Purpose

Summarize EPICC clients who are candidates for re-engagement or dismissal based on milestone participation and treatment path status.  
Supports program management and follow-up efforts by identifying clients who may require outreach or review.

## Key Metrics

- Aggregates treatment path participation across Initial Contact, 2-Week, and 30-Day milestones.
- Selects most recent treatment path using conditional logic across reporting intervals.
- Includes staff assignment and enrollment start date for follow-up context.
- Surfaces milestone-specific program participation and client status fields.
- Uses `HAVING` clause to flexibly include clients with partial milestone completion.

## Filters

- Includes only active enrollments (`ENDINGDATE IS NULL`) for EPICC Pathway ID `55320240807113504583`.
- Excludes test clients based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) by virtue of Q_CLIENT_BHN.
- Filters to clients with Initial Contact participation and either 'Enrolled' or 'Unable' status.

## Changelog

- **2025-08-12**: Initial Markdown documentation authored.
- **2025-05-13**: Initial SQL query authored.
