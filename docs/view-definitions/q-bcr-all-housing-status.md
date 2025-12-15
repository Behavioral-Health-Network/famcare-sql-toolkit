---
front-matter-title: Q_BCR_ALL_HOUSING_STATUS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-all-housing-status.sql
last_updated: 2025-11-13
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - bcr
tags:
  - view-layer
  - summation-view
  - slowly-changing-dimension
  - historical-record-view
  - housing-status-data
dependencies:
  - name: pwhousingstatus
    type: html
    repo: famcare-html-form-code
  - name: pwhousingstatus
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: q-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
  - name: pwbcrinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwbcrinitialcontact
    type: table
    repo: none
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_BCR_ALL_HOUSING_STATUS

## Purpose

Returns a complete history of housing status records for BCR clients. Each row represents a single housing status entry, linked to its reporting interval via `PARENTDOCSERNO`.

## Description

- Returns all housing status records for each client, providing a complete history of updates.
- Each row represents a single housing status record, linked to its reporting interval via `PARENTDOCSERNO`.
- Uses `COALESCE` to resolve missing `PARENTDOCSERNO` values for imported records, substituting with the `DOCSERNO` from the Initial Contact form (`PWBCRINITIALCONTACT`).
- Joins to `Q_CLIENT_BHN` to exclude test clients based on last name variants.
- Joins to `Q_BCR_PATHWAY_FORM_DOCSERNOS` to retrieve form type and validate parent form linkage.
- Transforms housing status types into pivoted columns for reporting:
  - `HOUSING_STATUS_STABLY_HOUSED`
  - `HOUSING_STATUS_UNHOUSED`
  - `HOUSING_STATUS_PRECARIOUSLY_HOUSED`
  - `HOUSING_STATUS_INSTITUTIONALLY_HOUSED`
  - `HOUSING_STATUS_UNKNOWN`

### Logic Summary

- **Primary Source:** `PWHOUSINGSTATUS`
  - Filters to active records (`DOCREVNO = ' 0 '`).
  - Includes housing status metadata and pathway linkage.

- **Joins:**
  - `Q_CLIENT_BHN` for client details and test client exclusion.
  - `PWBCRINITIALCONTACT` for fallback parent form linkage.
  - `Q_BCR_PATHWAY_FORM_DOCSERNOS` for form type and validation.

- **Parent Form Resolution:**
  - Uses `COALESCE(BHOUSE.PARENTDOCSERNO, BIC.DOCSERNO)` to ensure all records have a valid parent form reference.

## Output Fields

| Field Name                              | Description                                      |
|----------------------------------------|--------------------------------------------------|
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers and names                  |
| `PARENT_DOCSERNO`, `FORM_TYPE`         | Reporting interval linkage                      |
| `HOUSING_START_DATE`, `HOUSING_END_DATE` | Date range of housing status                   |
| `CLIENT_HOUSING_STATUS` (pivoted)      | Flags for each housing status type              |
| `HOUSING_STATUS_INCARCERATED` and `UNHOUSED_SHELTER`    | Additional housing indicators for institutionally housed and unhoused   |
| `IF_UNHOUSED_EXP`, `WORRIED_LOSING_HOUSING`, `HOMELESS_HOUSING_INSECURE_ETO` | Housing insecurity indicators |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability             |

## Maintenance Notes

- If new housing status types are introduced, update the `CASE` statements in the SELECT clause.
- Monitor naming conventions for test clients and update exclusion logic as needed.
- Changes to `PWHOUSINGSTATUS`, `PWBCRINITIALCONTACT`, `Q_BCR_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` may affect this view.

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

- **2025-11-13**: Adds fields `HOUSING_STATUS_INCARCERATED` and `UNHOUSED_SHELTER`. These had been added to the form back on 2025-06-23. Renames the `HOUSE` alias to `BHOUSE`.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-05-19**: Adds initial view definition.

</details>
</details>
