# YERE Caseload Report

**Category:** Program Management Reports  
**Source File:** `code/yere-caseload-report.sql`  
**Last Updated:** 2025-07-31  
**Author:** BHN Data Team  

---

## Purpose

Summarizes YERE program client caseloads, including enrollment details, worker assignment, agency, milestone completion status, payor information, and suicide attempt history.  
Supports program managers in tracking milestone compliance, identifying overdue forms, and reviewing worker caseloads.

---

## Logic Summary

- Filters for active YERE enrollments (`ENROLLMENT_ENDING_DATE IS NULL`) and milestone events (`PWY_EVENT LIKE 'YERE%'`).
- Aggregates milestone due dates, completion dates, and overdue status for:
  - Initial Assessment
  - 30-Day
  - 3-Month
  - 6-Month
  - Behavioral Health Services
- Flags clients with suicide attempt history from referral data.
- Includes assigned program worker, agency, and enrollment dates.
- Joins to payor source data for Medicaid and ShowMe Healthy Kids indicators.
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
| `SUICIDE_ATTEMPT`                 | Flag for suicide attempt history                             |
| `IA_DATE_ACCOMPLISHED`            | Initial Assessment completion date                           |
| `30_DAY_DUE_DATE`, `30_DAY_DATE_ACCOMPLISHED` | 30-Day milestone due and completion dates         |
| `DAYS_UNTIL_30_DAY_DUE`, `30_DAY_OVERDUE_DAYS` | Days until due and overdue for 30-Day milestone |
| `3_MONTH_DUE_DATE`, `3_MONTH_DATE_ACCOMPLISHED` | 3-Month milestone dates                          |
| `DAYS_UNTIL_3_MONTH_DUE`, `3_MONTH_OVERDUE_DAYS` | Days until due and overdue for 3-Month milestone |
| `6_MONTH_DUE_DATE`, `6_MONTH_DATE_ACCOMPLISHED` | 6-Month milestone dates                          |
| `DAYS_UNTIL_6_MONTH_DUE`, `6_MONTH_OVERDUE_DAYS` | Days until due and overdue for 6-Month milestone |
| `BHS_DATE_ACCOMPLISHED`           | Behavioral Health Services milestone completion date         |
| `MANAGED_MEDICAID_PROVIDER_DESCRIPTION` | Managed Medicaid payor info                          |
| `SHOWME_HEALTHY_KIDS`             | ShowMe Healthy Kids payor indicator                          |

---

## Parameterization Notes

This report uses FAMCare Quick Report parameters for date filtering:  

- `^^START RANGE|DATEPICKER^^` is a vendor-specific placeholder for user-selected start date.  
- These parameters will not execute in SSMS but are valid in the FAMCare reporting interface.

---

## Usage Notes

- Designed for program managers to monitor milestone compliance and caseload distribution.
- Overdue calculations help prioritize follow-up and form completion.
- Suicide attempt flag supports risk assessment and service planning.
- Payor data supports review of managed medicaid provider details specific to youth.

---

## Maintenance Guidelines

- Update milestone event names or logic if program workflows change.
- Confirm HR joins remain valid for supervisor identification.
- Validate payor source joins against current Medicaid structures (e.g., ShowMe Healthy Kids).
- Ensure parameter syntax remains compatible with FAMCare conventions.
- Test regularly to confirm accuracy and relevance to program needs.

---

## Changelog

- **2025-07-31** – Initial version authored.  
  - Added milestone tracking logic and overdue calculations.  
  - Incorporated payor and suicide attempt indicators.  
  - Documented parameter usage and HR joins.
