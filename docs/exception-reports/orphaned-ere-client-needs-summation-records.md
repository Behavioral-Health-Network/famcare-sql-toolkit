---
front-matter-title: Orphaned ERE Client Needs Summation Records
category: exception-reports
category-label: Exception Reports
source_file: code/exception-reports/orphaned-ere-client-needs-summation-records.sql
last_updated: 2025-12-23
author: Bradley Wing
status: active
lifecycle: production
tags:
  - audit-trail
  - data-integrity
  - documentation
  - exception-report
program-scope: single
programs:
  - ere
dependencies:
  - name: pwereclientneeds
    type: html
    repo: FAMCare-HTML-Form-Code
  - name: pwereclientneeds
    type: table
    repo: none
  - name: q-ere-client-needs
    type: sql
    repo: FAMCare-SQL-Toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
  - date: 2025-12-22
last_reviewed: 2025-12-22
schema_version: 1.0
---

# Orphaned ERE Client Needs Summation Records Exception Report

## Purpose

Identifies ERE Client Needs summation records whose parent form were either deleted or never saved, resulting in those client needs records becoming orphaned with no way to join from `PWERECLIENTNEEDS.PARENTDOCSERNO` to `PARENTFOOD.DOCSERNO`. This exception report helps Data Team staff and program staff ensure that client needs summation records may be properly joined to support accurate case management and reporting.

## Logic Summary

- Outputs rows when `Q_ERE_CLIENT_NEEDS.FORM_TYPE IS NULL`. This indicates that a summation record exists but has no matching parent form in the full list of Pathway Event `DOCSERNO` values.

## Usage Notes

- Used by Data Team for exception remediation and summation form cleanup.
- May inform stakeholder review or internal audit processes.

## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-12-23**: Adds initial Markdown documentation file.
- **2025-12-22**: Adds initial SQL query.

</details>
</details>
