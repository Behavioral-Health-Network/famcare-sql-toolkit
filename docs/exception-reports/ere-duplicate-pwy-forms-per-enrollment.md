---
front-matter-title: ERE Duplicate Pathway Forms Per Enrollment Exception Report
category: Exception Reports
source_file: code/exception-reports/ere-duplicate-pathway-forms-per-enrollment.sql
last_updated: 2025-12-18
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - exception-logic
change_control: value
schema_version: 1.0
---

# ERE Duplicate Pathway Forms Per Enrollment Exception Report

## Purpose

Identify duplicate ERE Pathway forms (Referral, IHNA, Follow-Up, etc.) submitted for the same enrollment. This query flags potential duplicates requiring manual review to determine which version should be retained. Non-authoritative versions should be deleted with caution.

## Logic Summary

- Select completed enrollments (`TIEDENROLLMENT IS NOT NULL`) from `Q_ERE_PATHCLIENT_ENROLLMENTS`.
- Group by core enrollment fields and form document serial number.
- Count distinct `PWY_FORMS_DOCSERNO` values within each group.
- Return only groups with count greater than 1, indicating duplicate form submissions.

## Usage Notes

- Intended for internal review by program or Data Team staff.
- Confirm authoritative version for each duplicated entry before cleanup.
- Optionally reference audit log or historical submission timestamps to guide decision-making.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-12-18**: Updates query to substitute `TIEDENROLLMENT` in place of `PEC_PATHCLIENT_DOCSERNO` and `DATE_ACCOMPLISHED` because `TIEDENROLLMENT` assures cardinality is one-to-one, while `DATE_ACCOMPLISHED` may be `NULL` even when a form exists and has been joined to the enrollment.
- **2025-07-13**: Adds initial SQL query. Adds initial Markdown documentation.
<!---CHANGELOG-END--->
