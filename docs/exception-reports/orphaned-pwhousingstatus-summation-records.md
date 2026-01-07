---
front-matter-title: Orphaned PWHOUSINGSTATUS Summation Records
category: exception-reports
category-label: Exception Reports
source_file: code/exception-reports/orphaned-pwhousingstatus-summation-records.sql
last_updated: 2025-12-23
author: Bradley Wing
status: active
lifecycle: production
tags:
  - audit-trail
  - data-integrity
  - documentation
  - exception-report
program-scope: multi
programs:
  - bcr
  - complex-care
  - epicc
  - ere
  - yere
dependencies:
  - name: pwhousingstatus
    type: html
    repo: FAMCare-HTML-Form-Code
  - name: pwhousingstatus
    type: table
    repo: none
  - name: q-all-pathway-form-docsernos
    type: sql
    repo: FAMCare-SQL-Toolkit
  - name: q-client-bhn
    type: sql
    repo: FAMCare-SQL-Toolkit
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
  - date: 2025-12-23
last_reviewed: 2025-12-23
schema_version: 1.0
---

# Orphaned PWHOUSINGSTATUS Summation Records Exception Report

## Purpose

Identifies housing status summation records whose parent form were either deleted or never saved, resulting in those housing records becoming orphaned with no way to join from `PWHOUSINGSTATUS.PARENTDOCSERNO` to `PARENTFOOD.DOCSERNO`. This exception report helps Data Team staff and program staff ensure that housing summation records may be properly joined to support accurate case management and reporting.

## Logic Summary

- Left joins `Q_ALL_PATHWAY_FORM_DOCSERNOS`.
- Inner joins `Q_CLIENT_BHN` to filter test client records from the base `PWHOUSINGSTATUS` summation form.
- Outputs rows when `Q_ALL_PATHWAY_FORM_DOCSERNOS.FORM_TYPE IS NULL` and when `HOUSE.PARENTDOCSERNO <> ''` and `HOUSE.PARENTDOCSERNO IS NOT NULL`. The former indicates that a summation record exists but has no matching parent form in the full list of Pathway Event `DOCSERNO` values. The latter excludes imported summation records, which never have a `PARENTDOCSERNO`. Those must be handled differently.- Includes program, client, worker, and supervisor details for review.

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

- **2025-12-23**: Adds initial SQL query. Adds initial Markdown documentation file.

</details>
</details>
