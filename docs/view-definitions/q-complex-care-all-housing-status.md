---
front-matter-title: Q_COMPLEX_CARE_ALL_HOUSING_STATUS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-all-housing-status.sql
last_updated: 2025-11-13
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
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
  - name: pwmercybeacnbenchmarks
    type: html
    repo: famcare-html-form-code
  - name: pwmercybeacnbenchmarks
    type: table
    repo: none
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-11-12
last_reviewed: 2025-11-12
schema_version: 1.0
---

# Q_COMPLEX_CARE_ALL_HOUSING_STATUS

## Purpose

Returns a complete history of housing status records for Complex Care clients. Each row represents a single housing status entry, linked to its reporting interval via `PARENTDOCSERNO`.

## Description

- Includes all housing status records, not just the latest or active ones.
- Transforms housing status types into binary flags for simplified reporting.
- Filters out test clients via `Q_CLIENT_BHN`.

### Logic Summary

- **Source Table**: `PWHOUSINGSTATUS`
- **Client Filter**: `Q_CLIENT_BHN` excludes test clients (`GVTTest`, `GVTest`, `GVTTEST`)
- **Form Linkage**: Joins to `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` to identify parent document for reporting on client housing status
- **Pivoting**: Housing status types are converted to binary columns via `CASE` statements

## Output Fields

| Field Name                         | Description |
|------------------------------------|-------------|
| `ID`                               | Unique identifier for housing status record |
| `DOCSERNO`                         | Document metadata |
| `VISITDT`, `VISITTM`               | Visit date and time |
| `USERID`                           | User who entered the record |
| `PARENT_DOCSERNO`                  | Reporting interval form (via COALESCE) |
| `FORM_TYPE`                        | Type of parent form |
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers |
| `PATHWAY_DATE`                     | Pathway date for record alignment |
| `CLIENT_HOUSING_STATUS`           | Raw housing status value |
| `HOUSING_STATUS_INCARCERATED`, `UNHOUSED_SHELTER`, `IF_UNHOUSED_EXP`, `WORRIED_LOSING_HOUSING` | Additional housing context |
| `HOUSING_START_DATE`, `HOUSING_END_DATE` | Duration of housing status |
| `HOUSING_STATUS_*`                | Binary flags for each housing status type |

## Housing Status Flags

| Column Name                          | Trigger Condition |
|-------------------------------------|-------------------|
| `HOUSING_STATUS_INSTITUTIONALLY_HOUSED` | `'Institutionally Housed'` |
| `HOUSING_STATUS_PRECARIOUSLY_HOUSED`    | `'Precariously Housed'` |
| `HOUSING_STATUS_STABLY_HOUSED`          | `'Stably Housed'` |
| `HOUSING_STATUS_UNHOUSED`               | `'Unhoused'` |
| `HOUSING_STATUS_UNKNOWN`                | `'Unknown'` |

## Maintenance Notes

- **Status Expansion**: Update `CASE` logic if new housing status types are introduced.
- **Test Client Filter**: Adjust `Q_CLIENT_BHN` logic if naming conventions change.
- **Form Linkage Integrity**: Confirm `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` includes all valid DOCSERNOs.

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

- **2025-11-13**: Adds fields `HOUSING_STATUS_INCARCERATED` and `UNHOUSED_SHELTER`. These had been added to the form back on 2025-06-23.
- **2025-11-12**: Adds initial view definition to support full housing status history reporting for Complex Care clients. Adds initial Markdown documentation.

</details>
</details>
