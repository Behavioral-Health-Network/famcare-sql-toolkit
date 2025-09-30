---
front-matter-title: Q_ERE_ALL_HOUSING_STATUS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-all-housing-status.sql
last_updated: 2025-08-09
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - ere
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
  - name: pwereihna
    type: html
    repo: famcare-html-form-code
  - name: pwereihna
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

# Q_ERE_ALL_HOUSING_STATUS

## Purpose

Provides a complete history of housing status records for ERE clients, including both active and historical entries. Supports longitudinal analysis, reporting interval alignment, and housing insecurity diagnostics.

## Description

- Built on `PWHOUSINGSTATUS`, joined with `Q_ERE_IHNA` to resolve imported records lacking `PARENTDOCSERNO`.
- Uses `COALESCE` to ensure all records have a valid parent form reference.
- Joins with `Q_ERE_PATHWAY_FORM_DOCSERNOS` to identify reporting intervals and form types.
- Excludes test clients via `Q_CLIENT_BHN`.
- Outputs pivoted housing status flags for simplified reporting.

### Logic Summary

- **Parent Form Resolution**
  - Uses `COALESCE(PARENTDOCSERNO, EREIHNA.DOCSERNO)` to ensure all records have a valid parent reference.
  - Filters to only include records with valid parent form linkage via `Q_ERE_PATHWAY_FORM_DOCSERNOS`.

- **Client Join**
  - Uses `Q_CLIENT_BHN` to exclude test clients based on last name variants.

- **Pivoted Status Flags**
  - Converts `CLIENT_HOUSING_STATUS` into five binary columns:
    - `HOUSING_STATUS_INSTITUTIONALLY_HOUSED`
    - `HOUSING_STATUS_PRECARIOUSLY_HOUSED`
    - `HOUSING_STATUS_STABLY_HOUSED`
    - `HOUSING_STATUS_UNHOUSED`
    - `HOUSING_STATUS_UNKNOWN`

## Output Fields

| Field Name                              | Description                                      |
|----------------------------------------|--------------------------------------------------|
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers and names                  |
| `PARENT_DOCSERNO`, `FORM_TYPE`         | Reporting interval linkage                      |
| `HOUSING_START_DATE`, `HOUSING_END_DATE` | Date range of housing status                   |
| `CLIENT_HOUSING_STATUS` (pivoted)      | Flags for each housing status type              |
| `IF_UNHOUSED_EXP`, `WORRIED_LOSING_HOUSING`, `HOMELESS_HOUSING_INSECURE_ETO` | Housing insecurity indicators |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability             |

## Maintenance Notes

- **Import Handling**: Ensure `Q_ERE_IHNA` remains aligned with import logic and pathway date matching.
- **Test Client Exclusion**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) in `Q_CLIENT_BHN`.
- **Housing Status Expansion**: Update CASE logic if new status types are introduced.
- **Dependency Awareness**: Changes to `PWHOUSINGSTATUS`, `PWEREIHNA`, `Q_ERE_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` may affect logic integrity.

## Changelog

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-08-06**: Adds initial view definition to support full housing status history and reporting interval alignment.
