---
front-matter-title: Q_YERE_ALL_PAYOR_SOURCE
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-all-payor-source.sql
last_updated: 2025-11-20
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - view-layer
  - summation-view
  - slowly-changing-dimension
  - historical-record-view
  - insurance-data
dependencies:
  - name: pwpayorsource
    type: html
    repo: famcare-html-form-code
  - name: pwpayorsource
    type: table
    repo: none
  - name: pwyereinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwyereinitialcontact
    type: table
    repo: none
  - name: q-yere-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control: value
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_YERE_ALL_PAYOR_SOURCE

## Purpose

Returns all payor source records for YERE clients, including historical entries. Supports longitudinal tracking of insurance coverage and provider engagement across reporting intervals.

## Description

- Built on `PWPAYORSOURCE`, joined with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Resolves imported records using `PWYEREINITIALCONTACT` to infer missing `PARENTDOCSERNO`.
- Joins with `Q_YERE_PATHWAY_FORM_DOCSERNOS` to identify valid reporting intervals and form types.
- Includes both active and historical payor source records for comprehensive analysis.

### Logic Summary

- **Parent Form Resolution**
  - Uses `COALESCE(PARENTDOCSERNO, YIA.DOCSERNO)` to ensure all records have a valid parent reference.
  - Filters to only include records with valid parent form linkage via `Q_YERE_PATHWAY_FORM_DOCSERNOS`.

- **Client Join**
  - Uses `Q_CLIENT_BHN` for name fields and test client exclusion.

- **Import Handling**
  - Resolves missing `PARENTDOCSERNO` for imported records using `PWYEREINITIALCONTACT`.

## Output Fields

| Field Name                             | Description |
|----------------------------------------|-------------|
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers |
| `DOCSERNO`, `PARENTDOCSERNO`, `FORM_TYPE` | Form and reporting interval linkage |
| `PAYOR_SOURCE`, `MANAGED_MEDICAID_PROVIDER`, `PRIVATE_INSURANCE_PROVIDER` | Insurance source and provider details |
| `PAYOR_SOURCE_START_DATE`, `PAYOR_SOURCE_END_DATE` | Coverage period |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability |

## Maintenance Notes

- **Import Logic**: Ensure `PWYEREINITIALCONTACT` remains aligned with import resolution logic.
- **Test Client Filtering**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`); update if naming conventions change.
- **Form Linkage**: Confirm that `Q_YERE_PATHWAY_FORM_DOCSERNOS` continues to reflect valid reporting intervals.
- **Provider Fields**: Validate that provider fields are consistently populated and aligned with form expectations.

## Changelog

- **2025-11-20**: Updates `COALESCE(YIA.PARENTDOCSERNO, YPAY.PARENTDOCSERNO) AS [PARENTDOCSERNO]` to `COALESCE(YIA.DOCSERNO, YPAY.PARENTDOCSERNO) AS [PARENTDOCSERNO]` in the `SELECT`.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-08-10**: Adds initial view definition to support full payor source history for EPICC clients.
