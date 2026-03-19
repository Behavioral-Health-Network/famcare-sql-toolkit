---
front-matter-title: YERE Needs Report
category: Program Management Reports
source_file: code/program-management-reports/yere-needs-report.sql
last_updated: 2026-03-03
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - program-management
  - client-needs
  - caregiver-needs
dependencies:
  - Q_YERE_NEEDS_REPORT
change_control: value
schema_version: 1.0
---

# YERE Needs Report

## Purpose

Provides program managers with enrollment-level summaries of caregiver and youth needs for the Youth ERE (YERE) program. Supports monitoring of needs identification, service connection, and worker caseload patterns.

## Description

- Queries `Q_YERE_NEEDS_REPORT`, which aggregates needs at the episode-of-care level.
- Allows filtering by:
  - Enrollment start date range
  - Enrollment end date range
  - Program worker
- Returns one row per enrollment with counts of:
  - Caregiver needs identified and connected
  - Youth needs identified and connected

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
| `CAREGIVER_NEEDS_IDENTIFIED`, `CAREGIVER_NEEDS_CONNECTED` | Caregiver needs summary |
| `YOUTH_NEEDS_IDENTIFIED`, `YOUTH_NEEDS_CONNECTED` | Youth needs summary |

## Usage Notes

- Designed for program management dashboards and caseload monitoring.
- Relies on the YERE business rule that staff maintain a single child needs form per enrollment.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-17**: Adds initial SQL query. Adds initial Markdown documentation file.

</details>
</details>
<!---CHANGELOG-END--->
