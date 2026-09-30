---
front-matter-title: ERE Completer And Contact Report
category: Program Management Reports
source_file: code/program-management-reports/ere-completer-and-contact-report.sql
last_updated: 2026-09-30
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - program-management
  - ihna
  - mental-health-history
  - substance-use-history
  - physical-health-history
dependencies:
  - Q_ERE_PATHCLIENT_ENROLLMENTS
  - Q_ERE_IHNA
change_control: value
schema_version: 1.0
---

# ERE Completer And Contact Report

## Purpose

Provides program managers with IHNA history around `Who Completed The Form?` and `Method Of Contact` for the ERE program. Supports monitoring data quality of entry and investigation into quality sources for completing forms. 

## Description

- Queries `Q_ERE_PATHCLIENT_ENROLLMENTS` to pull client and program staff information.
- Joins in `Q_ERE_IHNA` to provide form data.
- Allows filtering by:
  - Enrollment start date range
  - Enrollment end date range
  - Dismissal start date range
  - Dismissal end date range
  - Program worker
- Returns one row per enrollment

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
| `IHNA_PATHWAY_DATE`, `IHNA_COMPLETION_HELPER`, `IHNA_OTHER_COMPLETION_HELPER`, `IHNA_METHOD_OF_CONTACT`, `IHNA_METHOD_OF_CONTACT_OTHER` | IHNA information |

## Usage Notes

- `TIEDENROLLMENT` ensures correct episode attribution across multiple parent forms.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<!---CHANGELOG-END--->
