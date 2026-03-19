---
front-matter-title: Duplicate YERE Client Needs Records Per TIEDENROLLMENT Exception Report
category: Exception Reports
source_file: code/exception-reports/duplicate-yere-client-needs-records-per-tiedenrollment.sql
last_updated: 2025-01-20
status: active
lifecycle: production
program-scope: single
programs:
  - yere
tags:
  - exception-logic
  - client-needs
change_control: cross-repo-coordination
schema_version: 1.0
---

# Duplicate YERE Client Needs Records Per TIEDENROLLMENT Exception Report

## Purpose

Identify YERE enrollments where more than one **Client Needs** form has been submitted for the same `TIEDENROLLMENT`.  
Each enrollment should have **exactly one** Client Needs form. Multiple submissions indicate a documentation error that can distort reporting, summations, and program performance metrics.

This exception report supports YERE program data quality review and remediation.

## Description

This query evaluates the relationship between:

- YERE enrollments (`Q_YERE_PATHCLIENT_ENROLLMENTS`)
- client demographic records (`Q_CLIENT_BHN`)
- youth client needs forms (`Q_YERE_CLIENT_NEEDS`)

The logic:

- Joins client needs forms to enrollments using both `CLIENT_NUMBER` and `PARENTDOCSERNO` to ensure the form belongs to the correct episode of care.
- Groups by `CLIENT_NUMBER` and `TIEDENROLLMENT` to isolate each enrollment.
- Counts the number of client needs forms associated with each enrollment.
- Returns only those enrollments where the count exceeds one.

This identifies cases where staff submitted multiple youth client needs forms for the same enrollment, which violates the expected workflow and may require correction in FAMCare.

## Output Columns

| Field Name                 | Description |
|----------------------------|-------------|
| `CLIENT_NUMBER`            | Unique BHN client identifier. |
| `TIEDENROLLMENT`           | Unique identifier for the YERE enrollment episode. |
| `COUNT_NEEDS_DOCSERNO`     | Number of client needs forms linked to the enrollment; values greater than 1 indicate duplicates. |

## Maintenance Notes

- This report depends on the stability of `Q_YERE_PATHCLIENT_ENROLLMENTS` and `Q_YERE_CLIENT_NEEDS`. Any changes to Pathway Event logic, form structure, or parent/child relationships may require updates.
- Duplicate client needs forms may result from staff resubmissions, incorrect form selection, or workflow inconsistencies. Program staff should review and resolve duplicates directly in FAMCare.
- If YERE introduces new youth needs workflows or modifies form behavior, the join logic and grouping keys may need revision.
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

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

</details>
</details>
<!---CHANGELOG-END--->
