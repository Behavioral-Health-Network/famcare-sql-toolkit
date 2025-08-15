# ERE Caseload Report

**Category:** Program Management Reports  
**Source File:** `code/program-management-reports/ere-caseload-report.sql`  
**Last Updated:** 2025-07-31  
**Author:** Bradley Wing
**Lifecycle**: `Production`

---

## Purpose

Summarizes ERE program client caseloads, including enrollment details, worker assignment, agency, milestone completion status, and payor information.  
Supports program managers in tracking milestone compliance, identifying overdue forms, and reviewing worker caseloads.

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

| Field Name                          | Description                                                  |
|------------------------------------|--------------------------------------------------------------|
| `CLIENT_NUMBER`                    | Unique client identifier                                     |
| `CLIENT LAST`, `CLIENT FIRST`      | Client name                                                  |
| `WORKER`                           | Assigned program worker (first + last name)                  |
| `ENROLLMENT_DATE`, `DISMISSAL_DATE`| Enrollment start and end dates                               |
| `AGENCY_DESCRIPTION`              | Agency associated with the enrollment                        |
| `IHNA_DATE_ACCOMPLISHED`            | IHNA completion date                           |
| `DAYS_UNTIL_30_DAY_DUE`, `30_DAY_OVERDUE_DAYS` | Days until due and overdue for 30-Day milestone |
| `3_MONTH_DUE_DATE`, `3_MONTH_DATE_ACCOMPLISHED` | 3-Month milestone dates                          |
| `DAYS_UNTIL_3_MONTH_DUE`, `3_MONTH_OVERDUE_DAYS` | Days until due and overdue for 3-Month milestone |
| `6_MONTH_DUE_DATE`, `6_MONTH_DATE_ACCOMPLISHED` | 6-Month milestone dates                          |
| `DAYS_UNTIL_6_MONTH_DUE`, `6_MONTH_OVERDUE_DAYS` | Days until due and overdue for 6-Month milestone |
| `BHS_DATE_ACCOMPLISHED`           | Behavioral Health Service milestone completion date          |
| `MANAGED_MEDICAID_PROVIDER_DESCRIPTION` | Managed Medicaid payor info                          |

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

- **2025-08-14**: Adds initial Markdown documentation.
- **2025-08-06**: Adds initial SQL query.  
