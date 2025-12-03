---
front-matter-title: Q_BCR_ACTIVE_PAYOR_SOURCE
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-bcr-active-payor-source.sql
last_updated: 2025-11-19
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
  - active-record-view
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
  - name: q-bcr-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
  - name: managed-medicaid-provider
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

# Q_BCR_ACTIVE_PAYOR_SOURCE

## Purpose

Returns all payor source records for BCR clients, including historical entries. Supports longitudinal tracking of insurance coverage and provider engagement across reporting intervals.

## Description

- Consolidates active payor source data into a single row per client, providing a snapshot of the most recent and relevant payor source information.
- Built on top of `PWPAYORSOURCE`, filtered to include only active records (`PAYOR_SOURCE_END_DATE IS NULL`, `DOCREVNO = ' 0 '`).
- Filters records to include only those with valid `PARENTDOCSERNO` values from `Q_BCR_PATHWAY_FORM_DOCSERNOS` after coalescing `BPAY.PARENTDOCSERNO` AND `BIC.DOCSERNO` to account for the fact that imported records will lack `PARENTDOCSERNO`.
- Pivots payor source types into individual columns for reporting:
  - `PAYOR_SOURCE_MEDICAID`
  - `PAYOR_SOURCE_PRIVATE_INSURANCE`
  - `PAYOR_SOURCE_UNINSURED`
  - ...and others.
- Retains the latest `PARENTDOCSERNO` per client to ensure uniqueness. Because `DOCSERNO` values increase monotonically over time, using `MAX(PARENTDOCSERNO)` ensures that the latest parent form is selected when aggregating payor source records. In BCR, all payor source summations are launched from the Initial Contact form. This means every payor source record for a client will share the same `PARENTDOCSERNO`. Even if a secondary payor is added later, the parent remains unchanged.
- Joins with `MANAGED_MEDICAID_PROVIDER` to include descriptive provider information.

### Logic Summary

- **[ACTIVE_PAYOR_SOURCE]**
  - Filters `PWPAYORSOURCE` for active records.
  - Selects relevant fields for aggregation and pivoting.

- **[AGGREGATED_PAYOR_SOURCE]**
  - Groups by `CLIENTNUMBER` and `PAYOR_SOURCE`.
  - Retains max values for provider fields and `PARENTDOCSERNO`.

- **[PIVOTED_PAYOR_SOURCES]**
  - Pivots payor source types into individual columns.
  - Includes provider fields for Medicaid and private insurance.

- **[LATEST_PARENTDOCSERNO]**
  - Identifies the latest `PARENTDOCSERNO` per client to ensure uniqueness.

- **[FINAL_OUTPUT]**
  - Combines pivoted data with latest `PARENTDOCSERNO`.
  - Joins to `MANAGED_MEDICAID_PROVIDER` for descriptive labels.

## Maintenance Notes

- Changes to `PWPAYORSOURCE`, `Q_BCR_PATHWAY_FORM_DOCSERNOS`, or `MANAGED_MEDICAID_PROVIDER` will affect this view.
- If new payor source types are introduced, update the `PIVOT` clause in `[PIVOTED_PAYOR_SOURCES]`.
- Aggregation and grouping logic may need to be revisited if additional fields are added or if uniqueness issues arise.

## Changelog

- **2025-11-19**: Adds left join to `PWBCRINITIALCONTACT AS [BIC]` when `BPAY.PATHWAY_DATE = BIC.PATHWAY_DATE` and `BPAY.USERID LIKE 'import%'` in the `[ACTIVE_PAYOR_SOURCE]` CTE. Updates `BPAY.PARENTDOCSERNO` to `COALESCE(BIC.DOCSERNO, BPAY.PARENTDOCSERNO) AS [PARENTDOCSERNO]` so that imported records, which will not have a `PARENTDOCSERNO` will inherit the `DOCSERNO` from the BCR Initial Contact form. Comments out `AND BPAY.PAYOR_SOURCE_END_DATE IS NULL` in the `WHERE` clause of the `[ACTIVE_PAYOR_SOURCE]`. Updates the frontmatter YAML to include the dependency on the `PWBCRINITIALCONTACT` form for `DOCSERNO` when `BPAY.PARENTDOCSERNO IS NULL`.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Removes ShowMe Healthy Kids. It's not relevant for BCR. Changes PAY alias to BPAY.
- **2025-08-09**: Adds initial Markdown documentation.
- **2025-05-07**: Adds initial view definition.
