---
front-matter-title: BCR All Payor Source View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-all-payor-source.sql
last_updated: 2026-03-16
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
  - insurance-data
dependencies:
  - name: pwpayorsource
    type: html
    repo: famcare-html-form-code
  - name: pwpayorsource
    type: table
    repo: none
  - name: pwbcrinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwbcrinitialcontact
    type: table
    repo: none
  - name: q-client_bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: pwbcrinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: q-bcr-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# BCR All Payor Source View Definition

## Purpose

Returns all payor source records for BCR clients, including historical entries. Supports longitudinal tracking of insurance coverage and provider engagement across reporting intervals.

## Description

- Built on `PWPAYORSOURCE`, joined with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Resolves imported records using `PWBCRINITIALCONTACT` to infer missing `PARENTDOCSERNO`.
- Joins with `Q_BCR_PATHWAY_FORM_DOCSERNOS` to identify valid reporting intervals and form types.
- Includes both active and historical payor source records for comprehensive analysis.

### Logic Summary

- **Parent Form Resolution**
  - Uses `COALESCE(BPAY.PARENTDOCSERNO, BIC.DOCSERNO)` to ensure all records have a valid parent reference.
  - Filters to only include records with valid parent form linkage via `Q_BCR_PATHWAY_FORM_DOCSERNOS`.

- **Client Join**
  - Uses `Q_CLIENT_BHN` for name fields and test client exclusion (`LASTNAME NOT IN (...)`).

- **Import Handling**
  - Resolves missing `PARENTDOCSERNO` for imported records using `PWBCRINITIALCONTACT`.

## Output Fields

| Field Name                             | Description |
|----------------------------------------|-------------|
| `CLIENTNUMBER`, `FIRST_NAME`, `LAST_NAME` | Client identifiers |
| `DOCSERNO`, `PARENTDOCSERNO`, `FORM_TYPE` | Form and reporting interval linkage |
| `PAYOR_SOURCE`, `MANAGED_MEDICAID_PROVIDER`, `PRIVATE_INSURANCE_PROVIDER` | Insurance source and provider details |
| `SHOW_ME_HEALTHY_KIDS`                 | Program participation indicator |
| `PAYOR_SOURCE_START_DATE`, `PAYOR_SOURCE_END_DATE` | Coverage period |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability |

## Maintenance Notes

- **Import Logic**: Ensure `PWBCRINITIALCONTACT` remains aligned with import resolution logic.
- **Test Client Filtering**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`); update if naming conventions change.
- **Form Linkage**: Confirm that `Q_BCR_PATHWAY_FORM_DOCSERNOS` continues to reflect valid reporting intervals.
- **Provider Fields**: Validate that provider fields are consistently populated and aligned with form expectations.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-16**: Renames `PARENTDOCSERNO` to `PARENT_DOCSERNO` to align with `Q_BCR_ACTIVE_PAYOR_SOURCE`. Renames `MANAGED_MEDICAID_PROVIDER`to `MANAGED_MEDICAID_PROVIDER_CODE` to align with the convention for queries of `code` columns from Master Tables.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-11-19**: Fixes `COALESCE(BIC.DOCSERNO, BPAY.PARENTDOCSERNO) AS [PARENTDOCSERNO]` by changing `BIC.PARENTDOCSERNO` to `BIC.DOCSERNO`.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Removes 'ShowMe Healthy Kids'. It's not relevant for BCR. Changes `PAY` alias to `BPAY`.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-06-11**: Adds initial view definition to support full payor source history for BCR clients.

</details>
</details>
<!---CHANGELOG-END--->
