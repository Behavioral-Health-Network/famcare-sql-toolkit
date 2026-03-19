---
front-matter-title: Client With Missing Demographics Exception Report
category: Exception Reports
source_file: code/exception-reports/client-with-missing-demographics.sql
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

# Client With Missing Demographics Exception Report

## Purpose

Identify clients with missing demographic information. When a demographic field is NULL, the query returns '??????' to highlight exceptions for users.

## Logic Summary

- Flags missing demographics by checking for NULL codes in:  
  - RACE_CODE
  - GENDER_CODE
  - ETHNICITY_CODE
  - BIRTH_DATE
  - ZIP_CODE

- Uses CASE statements to return '??????' when an exception exists, otherwise NULL.  
- Selects client identifiers, demographic exception columns, and entry timestamp.

## Usage Notes

- Intended for Data Team review and follow-up to ensure complete client records.  
- Run periodically as part of data quality checks.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-09-18**: Adds `exception-logic` tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-07-21**: Adds initial Markdown documentation.
- **2025-04-03**: Adds initial SQL query.
<!---CHANGELOG-END--->
