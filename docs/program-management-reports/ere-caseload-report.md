---
front-matter-title: ERE Caseload Report
category: Program Management Reports
source_file: code/program-management-reports/ere-caseload-report.sql
last_updated: 2025-09-16
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - tag1
  - tag2
dependencies:
  - value1
  - value2
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# ERE Caseload Report

## Purpose

Summarizes ERE program client caseloads, including enrollment details, worker assignment, agency, milestone completion status, and payor information. Supports program managers in tracking milestone compliance, identifying overdue forms, and reviewing worker caseloads.

---

## Logic Summary

- Filters for active ERE enrollments (`ENROLLMENT_ENDING_DATE IS NULL`) and milestone events (`PWY_EVENT LIKE 'ERE%'`).
- Aggregates milestone due dates, completion dates, and overdue status for:
  - IHNA
  - 3-Month
  - 6-Month
  - Behavioral Health Service
- Includes assigned program worker, agency, and enrollment dates.
- Joins to payor source data for Medicaid indicator.
- Uses nested subqueries to identify supervisor via HR form joins.
- Filters by enrollment date range using FAMCare Quick Report parameters.

---

## Output Fields

| Field Name                         | Description                                                  |
|------------------------------------|--------------------------------------------------------------|
| `CLIENT_NUMBER`                    | Unique client identifier                                       |
| `CLIENT LAST`, `CLIENT FIRST`      | Client name                                                    |
| `WORKER`                           | Assigned program worker (first + last name)                    |
| `ENROLLMENT_DATE`                  | Enrollment start date                                          |
| `AGENCY_DESCRIPTION`               | Agency associated with the enrollment                          |
| `HOSP_VISIT_NOTE_DATE_ACCOMPLISHED`| Hospital Visit Note completion date                            |
| `IHNA_DUE_DATE`                    | Date the IHNA will be due                                      |
| `IHNA_DATE_ACCOMPLISHED`           | IHNA completion date                                           |
| `DAYS_UNTIL_30_DAY_DUE`, `30_DAY_OVERDUE_DAYS` | Days until due and overdue for 30-Day milestone    |
| `3_MONTH_DUE_DATE`, `3_MONTH_DATE_ACCOMPLISHED` | 3-Month milestone dates                           |
| `DAYS_UNTIL_3_MONTH_DUE`, `3_MONTH_OVERDUE_DAYS` | Days until due and overdue for 3-Month milestone |
| `6_MONTH_DUE_DATE`, `6_MONTH_DATE_ACCOMPLISHED` | 6-Month milestone dates                           |
| `DAYS_UNTIL_6_MONTH_DUE`, `6_MONTH_OVERDUE_DAYS` | Days until due and overdue for 6-Month milestone |
| `BHS_DATE_ACCOMPLISHED`           | Behavioral Health Service milestone completion date             |
| `MANAGED_MEDICAID_PROVIDER_DESCRIPTION` | Managed Medicaid payor info                               |

---

## Parameterization Notes

This report uses FAMCare Quick Report parameters for date filtering:  

- `^^START RANGE|DATEPICKER^^` is a vendor-specific placeholder for user-selected start date.  
- These parameters will not execute in SSMS but are valid in the FAMCare reporting interface.

---

## Usage Notes

- Designed for program managers to monitor milestone compliance and caseload distribution.
- Overdue calculations help prioritize follow-up and form completion.
- Payor data supports review of managed medicaid provider details.

---

## Maintenance Guidelines

- Update milestone event names or logic if program workflows change.
- Confirm HR joins remain valid for supervisor identification.
- Validate payor source joins against current Medicaid structures.
- Ensure parameter syntax remains compatible with FAMCare conventions.
- Test regularly to confirm accuracy and relevance to program needs.

---

## Changelog

- **2025-09-16**: Adds `HOSP_VISIT_NOTE_DATE_ACCOMPLISHED` column.
- **2025-09-12**: Removes `DISMISSAL_DATE` column and adds `IHNA_DUE_DATE` column.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-14**: Adds initial Markdown documentation.
- **2025-08-06**: Adds initial SQL query.  
