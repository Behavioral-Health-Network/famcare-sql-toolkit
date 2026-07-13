---
front-matter-title: Duplicate YERE Cargivr Needs Records Per TIEDENROLLMENT Exception Report
category: Exception Reports
source_file: code/exception-reports/duplicate-yere-cargivr-needs-records-per-tiedenrollment.sql
last_updated: 2026-07-07
status: inactive
lifecycle: production
program-scope: single
programs:
  - yere
tags:
  - exception-logic
  - caregiver-needs
change_control: cross-repo-coordination
schema_version: 1.0
---

# Duplicate YERE Caregiver Needs Records Per TIEDENROLLMENT Exception Report

## Purpose

Identify YERE enrollments where more than one **Caregiver Needs** form has been submitted for the same `TIEDENROLLMENT`.  
Each enrollment should have **exactly one** Caregiver Needs form. Multiple submissions indicate a documentation error that can distort reporting, summations, and program performance metrics.

This exception report supports YERE program data quality review and remediation.

## Description

This query examines the relationship between:

- YERE enrollments (`Q_YERE_PATHCLIENT_ENROLLMENTS`)
- client demographic records (`Q_CLIENT_BHN`)
- caregiver needs forms (`Q_YERE_CAREGIVER_NEEDS`)

The logic:

- Joins caregiver needs forms to enrollments using both `CLIENT_NUMBER` and `PARENTDOCSERNO` to ensure the form belongs to the correct episode of care.
- Groups by `CLIENT_NUMBER` and `TIEDENROLLMENT` to isolate each enrollment.
- Counts the number of caregiver needs forms associated with each enrollment.
- Returns only those enrollments where the count exceeds one.

This identifies cases where staff submitted multiple caregiver needs forms for the same enrollment, which violates the expected workflow and may require correction in FAMCare.

## Output Columns

| Field Name               | Description |
|--------------------------|-------------|
| CLIENT_NUMBER            | Unique BHN client identifier. |
| TIEDENROLLMENT           | Unique identifier for the YERE enrollment episode. |
| COUNT_NEEDS_DOCSERNO     | Number of caregiver needs forms linked to the enrollment; values greater than 1 indicate duplicates. |

## Maintenance Notes

- This report depends on the stability of `Q_YERE_PATHCLIENT_ENROLLMENTS` and `Q_YERE_CAREGIVER_NEEDS`. Any changes to Pathway Event logic, form structure, or parent/child relationships may require updates.
- Duplicate caregiver needs forms may result from staff resubmissions, incorrect form selection, or workflow inconsistencies. Program staff should review and resolve duplicates directly in FAMCare.
- If YERE introduces new caregiver needs workflows or modifies form behavior, the join logic and grouping keys may need revision.
- The query intentionally does not filter on completion dates; it flags all duplicate submissions regardless of status.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-01-20**: Adds initial SQL query. Adds initial Markdown documentation file.
- **2026-07-07**: FAMCare no longer has this form in production as there should be no more new versions of these forms. 

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

</details>
</details>
<!---CHANGELOG-END--->
