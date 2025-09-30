---
front-matter-title: BCR Multiple Referrals Per Enrollment
category: Exception Reports
source_file: code/exception-reports/bcr-multiple-referrals-per-enrollmentr.sql
last_updated: 2025-08-12
author: Bradley Wing
status: active
lifecycle: production
program-scope: single
programs:
  - bcr
tags:
  - exception-logic
  - tag2
dependencies:
  - value1
  - value2
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# BCR Multiple Referrals Per Enrollment

## Purpose

Identifies clients who have more than one BCR referral recorded within a single program enrollment. Supports exception reporting by flagging potential duplicate or erroneous referral entries.

## Description

- Built on `PWBCRREFERRAL`, joined to `PROVIDERPLACEMENT` and `Q_CLIENT_BHN`.
- Filters to current records (`DOCREVNO = ' 0 '`).
- Groups by client and enrollment to count referral entries.
- Flags cases where more than one referral is linked to the same enrollment period.
- Excludes test clients via `Q_CLIENT_BHN`.

## Maintenance Notes

- Ensure joins to `PROVIDERPLACEMENT` and `PWBCRREFERRAL` reflect current data structures.
- Confirm that `PATHWAY_DATE` remains the correct linkage key for referral tracking.
- Review logic periodically to align with evolving program workflows and form usage.

## Changelog

- **2025-09-18**: Adds exception-logic tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-12**: Adds initial Markdown documentation.  
- **2025-04-07**: Adds initial SQL query.
