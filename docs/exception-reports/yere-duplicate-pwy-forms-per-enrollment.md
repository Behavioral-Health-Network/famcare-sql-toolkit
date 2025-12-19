---
front-matter-title: YERE Duplicate Pathway Forms Per Enrollment
category: Exception Reports
source_file: code/exception-reports/yere-duplicate-pathway-forms-per-enrollment.sql
last_updated: 2025-12-18
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - exception-logic
dependencies:
  - q-yere-pathclient-enrollments
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# YERE Duplicate Pathway Forms Per Enrollment

## Purpose

Identify duplicate YERE Pathway forms (Referral, Initial Assessment, Follow-Up, etc.) submitted for the same enrollment. This query flags potential duplicates requiring manual review to determine which version should be retained. Non-authoritative versions should be deleted with caution.

## Logic Summary

- Select completed enrollments (`TIEDENROLLMENT IS NOT NULL`) from `Q_YERE_PATHCLIENT_ENROLLMENTS`.
- Group by core enrollment fields and form document serial number.
- Count distinct `PWY_FORMS_DOCSERNO` values within each group.
- Return only groups with count greater than 1, indicating duplicate form submissions.

## Usage Notes

- Intended for internal review by program or Data Team staff.
- Confirm authoritative version for each duplicated entry before cleanup.
- Optionally reference audit log or historical submission timestamps to guide decision-making.

## Changelog

- **2025-12-18**: Updates query to substitute `TIEDENROLLMENT` in place of `PEC_PATHCLIENT_DOCSERNO` and `DATE_ACCOMPLISHED` because `TIEDENROLLMENT` assures cardinality is one-to-one, while `DATE_ACCOMPLISHED` may be `NULL` even when a form exists and has been joined to the enrollment.
- **2025-09-18**: Adds exception-logic tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-08**: Adds initial Markdown documentation.  
- **2025-07-13**: Adds initial SQL query.
