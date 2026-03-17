---
front-matter-title: Client Status Missing Exception Report
category: Exception Reports
source_file: code/exception-reports/client-status-missing.sql
last_updated: 2025-07-21
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

# Client Status Missing Exception Report

## Purpose

Identify clients who lack a current status in the client status field. Supports the Data Team in ensuring all active and enrolled clients have up-to-date status values for accurate tracking and reporting.

## Logic Summary

- Flags clients with a blank value in `CLIENT_STATUS`.
- Joins to `Q_CLIENT_BHN` to exclude test clients via view logic.
- Filters for records where `CLIENT_STATUS = ''`.

## Usage Notes

- Intended for internal review and remediation by GVT and System  
  Administrator groups.
- Regular review recommended to ensure alignment with current business rules.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-09-18**: Adds `exception-logic` tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-07-21**: Adds initial Markdown documentation.
- **2025-04-03**: Adds initial SQL query.
<!---CHANGELOG-END--->
