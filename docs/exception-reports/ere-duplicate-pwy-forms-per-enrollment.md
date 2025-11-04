---
front-matter-title: ERE Duplicate Pathway Forms Per Enrollment
category: Exception Reports
source_file: code/exception-reports/ere-duplicate-pathway-forms-per-enrollment.sql
last_updated: 2025-11-03
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
tags:
  - exception-logic
  - tag2
dependencies:
  - value1
  - value2
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-11-03
last_reviewed: 2025-11-03
schema_version: 1.0
---

# ERE Duplicate Pathway Forms Per Enrollment

## Purpose

Identify duplicate Pathway forms ERE (Referral, IHNA, Follow-Up, etc.) submitted for the same enrollment. This query flags potential duplicates requiring manual review to determine which version should be retained. Non-authoritative versions should be deleted with caution.

## Logic Summary

- Select completed enrollments (`PE_DATE_ACCOMPLISHED IS NOT NULL`) from `Q_ERE_PATHCLIENT_ENROLLMENTS`.
- Group by core enrollment fields and form document serial number.
- Count distinct `PWY_FORMS_DOCSERNO` values within each group.
- Return only groups with count greater than 1, indicating duplicate form submissions.

## Usage Notes

- Intended for internal review by program or Data Team staff.
- Confirm authoritative version for each duplicated entry before cleanup.
- Optionally reference audit log or historical submission timestamps to guide decision-making.

## Changelog

- **2025-07-13**: Adds initial SQL query. Adds initial Markdown documentation.
