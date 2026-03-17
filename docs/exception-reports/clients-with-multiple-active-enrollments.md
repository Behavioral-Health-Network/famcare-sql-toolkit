---
front-matter-title: Clients With Multiple Active Enrollments Exception Report
category: Exception Reports
source_file: code/exception-reports/clients-with-multiple-active-enrollments.sql
last_updated: 2025-07-15
status: active
lifecycle: production
program_scope: multi
programs:
  - bcr
  - complex-care
  - epicc
  - ere
  - yere
tags:
  - exception-logic
  - tag2
dependencies:
  - value1
  - value2
change_control: value
schema_version: 1.0
---

# Clients With Multiple Active Enrollments Exception Report

## Purpose

Flag clients who have more than one active enrollment at the same time, regardless of program. Supports identification of potential data entry errors or overlapping program enrollments, both within and across programs.

## Logic Summary

- Joins `Q_CLIENT_BHN` to `Q_PROVIDERPLACEMENT_BHN` on `CLIENT_NUMBER`.
- Filters for enrollments with `ENROLLMENT_ENDING_DATE IS NULL` (still active).
- Groups by client and counts active enrollments.
- Returns clients with more than one simultaneous active enrollment irrespective of program.

## Usage Notes

- Used for internal data quality review by the Data Team.
- May indicate issues with program transitions, duplicative enrollments, or form workflow gaps.
- Review records flagged for operational accuracy before remediation.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-09-18**: Adds `exception-logic` tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-07-15**: Adds initial Markdown documentation.
- **2025-05-22**: Adds initial SQL query.
<!---CHANGELOG-END--->
