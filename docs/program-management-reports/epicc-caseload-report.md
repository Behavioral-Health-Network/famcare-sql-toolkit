---
front-matter-title: EPICC Caseload Report
category: Program Management Reports
source_file: code/program-management-reports/epicc-caseload-report.sql
last_updated: 2025-06-10
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
tags: [value1, value2]
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

# EPICC Caseload Report

## Purpose

Summarizes EPICC program client caseloads, including enrollment details, worker assignment, agency, milestone completion status, program participation, and treatment path indicators. Supports program managers in tracking milestone compliance, reviewing treatment progression, and monitoring worker caseloads.

## Logic Summary

- Filters for active EPICC enrollments (`ENROLLMENT_ENDING_DATE IS NULL`) and milestone events (`PWY_EVENT LIKE 'EPICC%'`).
- Aggregates milestone due dates, completion dates, and overdue status for:
  - Initial Contact
  - 2 Week
  - 30-Day
  - 3-Month
  - 6-Month
- Includes assigned program worker, agency, and enrollment dates.
- Tracks treatment path and program participation at each milestone.
- Joins to client table for demographic and assignment accuracy.
- Filters by enrollment date range using FAMCare Quick Report parameters (commented for SSMS compatibility).

## Output Fields

| Field Name                          | Description                                                  |
|------------------------------------|--------------------------------------------------------------|
| `CLIENT_NUMBER`                    | Unique client identifier                                     |
| `CLIENT LAST`, `CLIENT FIRST`      | Client name                                                  |
| `WORKER`                           | Assigned program worker (first + last name)                  |
| `AGENCY`                           | Agency associated with the enrollment                        |
| `ENROLLMENT_DATE`                  | Enrollment start date                                        |
| `PRO_OR_CORE`                      | PRO or CORE designation from Initial Contact                 |
| `IC_TREATMENT_PATH`                | Treatment path at Initial Contact                            |
| `IC_DATE_ACCOMPLISHED`             | Initial Contact completion date                              |
| `IC_PROGRAM_PARTICIPATION`        | Program participation at Initial Contact                     |
| `2_WEEK_TREATMENT_PATH`            | Treatment path at 2 Week milestone                           |
| `DAYS_UNTIL_2_WEEK_DUE`           | Days until 2 Week milestone due                              |
| `2_WEEK_OVERDUE_DAYS`             | Days overdue for 2 Week milestone                            |
| `2_WEEK_DATE_ACCOMPLISHED`        | 2 Week milestone completion date                             |
| `2_WEEK_PROGRAM_PARTICIPATION`    | Program participation at 2 Week milestone                    |
| `30_DAY_TREATMENT_PATH`           | Treatment path at 30-Day milestone                           |
| `DAYS_UNTIL_30_DAY_DUE`           | Days until 30-Day milestone due                              |
| `30_DAY_OVERDUE_DAYS`             | Days overdue for 30-Day milestone                            |
| `30_DAY_DATE_ACCOMPLISHED`        | 30-Day milestone completion date                             |
| `30_DAY_PROGRAM_PARTICIPATION`    | Program participation at 30-Day milestone                    |
| `3_MONTH_TREATMENT_PATH`          | Treatment path at 3-Month milestone                          |
| `DAYS_UNTIL_3_MONTH_DUE`          | Days until 3-Month milestone due                             |
| `3_MONTH_OVERDUE_DAYS`            | Days overdue for 3-Month milestone                           |
| `3_MONTH_DATE_ACCOMPLISHED`       | 3-Month milestone completion date                            |
| `3_MONTH_PROGRAM_PARTICIPATION`   | Program participation at 3-Month milestone                   |
| `DAYS_UNTIL_6_MONTH_DUE`          | Days until 6-Month milestone due                             |
| `6_MONTH_OVERDUE_DAYS`            | Days overdue for 6-Month milestone                           |
| `6_MONTH_DATE_ACCOMPLISHED`       | 6-Month milestone completion date                            |
| `6_MONTH_PROGRAM_PARTICIPATION`   | Program participation at 6-Month milestone                   |

## Parameterization Notes

This report uses FAMCare Quick Report parameters for date filtering:  

- `^^START RANGE|DATEPICKER^^` is a vendor-specific placeholder for user-selected start date.  
- These parameters are commented out for SSMS compatibility but active in the FAMCare reporting interface.

## Usage Notes

- Designed for program managers to monitor milestone compliance and treatment progression.
- Overdue calculations help prioritize follow-up and form completion.
- Program participation and treatment path fields support service planning and client engagement review.
- Worker and agency context supports caseload management and supervision.

## Maintenance Guidelines

- Update milestone event names or logic if program workflows change.
- Confirm client table joins remain valid for demographic accuracy.
- Validate treatment path and participation  

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-08**: Adds initial Markdown documentation.
- **2025-06-10** – Adds initial SQL query.  
  - Adds milestone tracking logic and overdue calculations.  
  - Documents parameter usage and HR joins.
