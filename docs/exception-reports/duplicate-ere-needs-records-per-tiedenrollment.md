---
front-matter-title: Duplicate ERE Needs Records Per TIEDENROLLMENT Exception Report
category: Exception Reports
source_file: code/exception-reports/duplicate-ere-needs-records-per-tiedenrollment.sql
last_updated: 2026-03-19
status: active
lifecycle: production
program-scope: single
programs:
  - ere
tags:
  - exception-logic
  - client-needs
change_control: cross-repo-coordination
schema_version: 1.0
---

# Duplicate ERE Needs Records Per TIEDENROLLMENT Exception Report

## Purpose

Identify cases in the ERE program where more than one Needs form (Pathway Event form) has been submitted for the same enrollment (`TIEDENROLLMENT`).  
Each enrollment should have **exactly one** Needs form. Multiple forms indicate a documentation error that may affect reporting, summations, and downstream analytics.

This exception report supports program data quality review and remediation by flagging enrollments with duplicate Needs records.

## Description

This query scans the `Q_ERE_PATHCLIENT_ENROLLMENTS` view and groups records by:

- client  
- enrollment start date  
- Pathway Event  
- event start date  
- parent PathClient document  

It counts the number of associated Pathway Event forms (`PWY_FORMS_DOCSERNO`) for each grouping.  
Any grouping with a count greater than one is returned as an exception.

Key logic elements:

- Filters to rows where `PE_DATE_ACCOMPLISHED` is not null, ensuring only completed Needs forms are evaluated.
- Groups by enrollment‑level identifiers to isolate duplicates within the same episode.
- Uses `HAVING COUNT(PWY_FORMS_DOCSERNO) > 1` to return only true duplicates.
- Returns the count of duplicate forms to support staff remediation.

This report is intended for internal review by ERE program staff and the data team.

## Output Fields

| Field Name                 | Description |
|---------------------------|-------------|
| CLIENT_NUMBER             | Unique BHN client identifier. |
| PWY_START_DATE            | Start date of the Pathway associated with the enrollment. |
| PWY_EVENT                 | Pathway Event type (e.g., ERE Needs). |
| EVENT_START_DATE          | Start date of the specific Pathway Event instance. |
| PEC_PATHCLIENT_DOCSERNO   | Document serial number for the parent PathClient record associated with the enrollment. |
| COUNT PWY FORM            | Number of Pathway Event forms found for the enrollment; values greater than 1 indicate duplicates. |

## Maintenance Notes

- This report depends on the structure and stability of `Q_ERE_PATHCLIENT_ENROLLMENTS`. Any changes to Pathway Event logic, form naming, or enrollment structure may require updates.
- Duplicate Needs forms may arise from staff resubmissions, incorrect form selection, or workflow inconsistencies. Program staff should review and resolve duplicates in FAMCare.
- If ERE introduces new Needs‑related forms or modifies the workflow, the grouping logic may need to be expanded.
- The query intentionally excludes incomplete Needs forms by requiring `PE_DATE_ACCOMPLISHED IS NOT NULL`.

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
