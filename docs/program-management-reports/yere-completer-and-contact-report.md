---
front-matter-title: YERE Completer And Contact Report
category: Program Management Reports
source_file: code/program-management-reports/yere-completer-and-contact-report.sql
last_updated: 2026-09-30
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - program-management
  - yere-ia
  - yere-three-month
  - yere-six-month
dependencies:
  - Q_YERE_PATHCLIENT_ENROLLMENTS
  - Q_YERE_IA
  - Q_YERE_THREE_MONTH
  - Q_YERE_SIX_MONTH
change_control: value
schema_version: 1.0
---

# YERE Completer And Contact Report

## Purpose

Provides program managers with IA, 3-Month, and 6-Month history around `Who Completed The Form?` and `Method Of Contact` for the YERE program. Supports monitoring data quality of entry and investigation into quality sources for completing forms. 

## Description

- Queries `Q_YERE_PATHCLIENT_ENROLLMENTS` to pull client and program staff information.
- Joins in `Q_YERE_IA`, `Q_YERE_THREE_MONTH`, and `Q_YERE_SIX_MONTH` to provide form data.
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
| `IA_PATHWAY_DATE`, `IA_COMPLETION_HELPER`, `IA_OTHER_COMPLETION_HELPER`, `IA_METHOD_OF_CONTACT`, `IA_METHOD_OF_CONTACT_OTHER` | IA information |
| `THREEM_PATHWAY_DATE`, `THREEM_COMPLETION_HELPER`, `THREEM_OTHER_COMPLETION_HELPER`, `THREEM_METHOD_OF_CONTACT`, `THREEM_METHOD_OF_CONTACT_OTHER` | 3-Month information |
| `SIXM_PATHWAY_DATE`, `SIXM_COMPLETION_HELPER`, `SIXM_OTHER_COMPLETION_HELPER`, `SIXM_METHOD_OF_CONTACT`, `SIXM_METHOD_OF_CONTACT_OTHER` | 6-Month information |

## Usage Notes

- `TIEDENROLLMENT` ensures correct episode attribution across multiple parent forms.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<!---CHANGELOG-END--->
