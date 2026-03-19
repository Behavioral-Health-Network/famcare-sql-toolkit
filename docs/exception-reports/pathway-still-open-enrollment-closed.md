---
front-matter-title: Pathway Still Open Enrollment Closed Exception Report
category: Exception Reports
source_file: code/exception-reports/pathway-still-open-enrollment-closed.sql
last_updated: 2025-08-09
status: active
lifecycle: production
program_scope: all
programs:
tags:
  - exception-logic
dependencies:
  - value1
  - value2
change_control: value
schema_version: 1.0
---

# Pathway Still Open Enrollment Closed Exception Report

## Purpose

Flags cases where a client's Pathway remains open while their program enrollment has already ended. This report supports timely Pathway closure and ensures alignment between enrollment status and case management records.

## Logic Summary

- **Pathway Status Check**
  - Includes clients with open Pathways (`PATHWAYCLIENT.ENDDATE IS NULL`).
- **Enrollment Status Check**
  - Requires closed enrollments (`Q_PROVIDERPLACEMENT_BHN.ENROLLMENT_ENDING_DATE IS NOT NULL`).
- **Client Filtering**
  - Excludes test clients via join to `Q_CLIENT_BHN`.
- **Join Alignment**
  - Matches Provider Placement to Pathway via `DOCSERNO` and `STARTDATE`.
- **Staff Attribution**
  - Includes worker and supervisor via `Q_HRFORM`.
- **Optional Filtering**
  - Supports program-level filtering via `PROVIDERCODE` (commented out in current query).

## Usage Notes

- Intended for internal review and staff remediation.
- Useful for identifying stale Pathways that may require manual closure.
- Review regularly to ensure joins reflect current data structures and business rules.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-09-18**: Adds `exception-logic` tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-08**: Adds initial Markdown documentation.  
- **2025-08-09**: Fixes join between `PROVIDERPLACEMENT` and Pathway tables to ensure accurate matching. Corrects logic to flag open Pathways with closed enrollments (previously reversed). Adds `ENROLLMENT_ENDING_DATE` to `SELECT` and `CLIENT_LAST` to `ORDER BY`.
- **2025-05-03**: Adds initial SQL query.
<!---CHANGELOG-END--->
