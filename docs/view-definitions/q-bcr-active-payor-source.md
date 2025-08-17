# Q_BCR_ACTIVE_PAYOR_SOURCE

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-active-payor-source.sql`  
**Last Updated:** 2025-08-09  
**Author:** Bradley Wing  
**Lifecycle:** `Production` 

---

## Purpose

Returns all payor source records for BCR clients, including historical entries. Supports longitudinal tracking of insurance coverage and provider engagement across reporting intervals.

## Description

- Consolidates active payor source data into a single row per client, providing a snapshot of the most recent and relevant payor source information.
- Built on top of `PWPAYORSOURCE`, filtered to include only active records (`PAYOR_SOURCE_END_DATE IS NULL`, `DOCREVNO = ' 0 '`).
- Filters records to include only those with valid `PARENTDOCSERNO` values from `Q_BCR_PATHWAY_FORM_DOCSERNOS`.
- Pivots payor source types into individual columns for reporting:
  - `PAYOR_SOURCE_MEDICAID`
  - `PAYOR_SOURCE_PRIVATE_INSURANCE`
  - `PAYOR_SOURCE_UNINSURED`
  - ...and others.
- Retains the latest `PARENTDOCSERNO` per client to ensure uniqueness.
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

- **2025-08-10**: Removes ShowMe Healthy Kids. It's not relevant for BCR. Changes PAY alias to BPAY.
- **2025-08-09**: Initial Markdown documentation authored.
- **2025-05-07**: Initial view definition authored.
