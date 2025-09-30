---
front-matter-title: Client Dismissed But Client Status Still Active
category: Exception Reports
source_file: code/exception-reports/client-dismissed-but-client-status-still-active.sql
last_updated: 2025-07-21
author: Bradley Wing
status: active
lifecycle: production
program-scope: multi
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
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Client Dismissed But Client Status Still Active

## Purpose

Identify clients who have a recorded enrollment dismissal but whose client status remains marked as "Active," and who do not have any open enrollments. This report helps Data Team staff ensure that client statuses are updated appropriately following dismissal, supporting accurate case management and reporting.

## Logic Summary

- Filters for clients whose `CLIENTSTATUS = 'Active'`.
- Uses `NOT EXISTS` to verify that no open enrollments remain (`ENDINGDATE IS NULL`).
- Confirms dismissal activity via `ENDINGDATE IS NOT NULL` in a joined provider placement.
- Joins `Q_CLIENT_BHN` to `Q_PROVIDERPLACEMENT` on `CLIENT_NUMBER`.

## Usage Notes

- Intended for internal review by Data Team staff.
- Supports status auditing and helps close workflow gaps between enrollment updates.
- Should be reviewed periodically alongside other enrollment exception reports.

## Changelog

- **2025-09-18**: Adds exception-logic tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-07-21**: Adds initial Markdown documentation.
- **2025-05-02**: Adds initial SQL query.  

## Related Assets

- Views: `Q_CLIENT_BHN`, `Q_PROVIDERPLACEMENT`  
- Security Groups: GVT, System Administrator  
- Exception Conditions:
  - `CLIENT_STATUS = 'Active'`
  - No open enrollments exist
  - At least one dismissed enrollment present
