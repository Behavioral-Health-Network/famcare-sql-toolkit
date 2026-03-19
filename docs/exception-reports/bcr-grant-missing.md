---
front-matter-title: BCR Grant Missing Exception Report
category: Exception Reports
source_file: code/exception-reports/bcr-grant-missing.sql
last_updated: 2025-08-14
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
schema_version: 1.0
---

# BCR Grant Missing Exception Report

## Purpose

Identifies clients whose BCR Initial Contact forms are missing required grant information. This report supports program compliance and funding requirements by ensuring all eligible clients have complete grant documentation.

## Logic Summary

- Flags records where `BIC.BCR_GRANT IS NULL`, indicating missing grant assignment.
- Joins `PWBCRINITIALCONTACT` to `BCR_GRANT` for descriptive grant names.
- Includes ZIP Code from both the client record and Initial Contact form to assist in determining appropriate grant assignment.
- Filters to active records (`DOCREVNO = ' 0 '`) in both both `PWBCRINITIALCONTACT` and `PROVIDERPLACEMENT` forms.

## Usage Notes

- Intended for internal review by program managers and staff.
- Supports remediation of incomplete grant documentation for BCR clients.
- ZIP Code fields can be used to infer likely grant assignment when missing.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

- **2025-09-18**: Adds `exception-logic` tag and front-matter-title.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-14**: Adds initial Markdown documentation.
- **2025-04-07**: Adds initial SQL query.
<!---CHANGELOG-END--->
