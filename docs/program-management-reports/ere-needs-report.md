---
front-matter-title: ERE Needs Report
category: Program Management Reports
source_file: code/program-management-reports/ere-needs-report.sql
last_updated: 2026-03-03
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - program-management
  - client-needs
  - mental-health-history
  - substance-use-history
  - physical-health-history
dependencies:
  - Q_ERE_NEEDS_REPORT
change_control: value
schema_version: 1.0
---

# ERE Needs Report

## Purpose

Provides program managers with enrollment-level summaries of client needs and IHNA history for the ERE program. Supports monitoring of needs identification, service connection, and worker caseload patterns.

## Description

- Queries `Q_ERE_NEEDS_REPORT`, which aggregates IHNA history and client needs at the episode-of-care level.
- Allows filtering by:
  - Enrollment start date range
  - Enrollment end date range
  - Program worker
- Returns one row per enrollment with:
  - Counts of mental health, substance use, and physical health history conditions
  - Counts of needs identified and connected

## Filters

- `BEGINNING ENROLLMENT DATE`
- `ENDING ENROLLMENT DATE`
- `BEGINNING DISMISSAL DATE`
- `ENDING DISMISSAL DATE`
- `PROGRAM WORKER`

## Output Fields

| Field | Description |
|-------|-------------|
| `CLIENT_NUMBER`, `CLIENT_LAST`, `CLIENT_FIRST` | Client identity |
| `ENROLLMENT_STARTING_DATE`, `ENROLLMENT_ENDING_DATE` | Episode window |
| `PROGRAM_WORKER_*` | Worker attribution |
| `MH_HISTORY_COUNT`, `SU_HISTORY_COUNT`, `PHYSICAL_HISTORY_COUNT` | IHNA history summary |
| `NEEDS_IDENTIFIED`, `NEEDS_CONNECTED` | Client needs summary |

## Usage Notes

- `_REFERRED_ENGAGED` fields use `'ON'` to indicate connection; the view normalizes this.
- Staff maintain one child needs form per enrollment; the report reflects this business rule.
- `TIEDENROLLMENT` ensures correct episode attribution across multiple parent forms.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2026-03-02**: Adds initial SQL query. Adds initial Markdown documentation.
<!---CHANGELOG-END--->
