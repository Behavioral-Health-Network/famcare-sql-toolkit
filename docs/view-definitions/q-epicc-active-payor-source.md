---
front-matter-title: Q_EPICC_ACTIVE_PAYOR_SOURCE
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-active-payor-source.sql
last_updated: 2025-11-20
author: Bradley Wing
status: active
lifecycle: production
program_scope: single
programs:
  - epicc
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
  - name: pwepiccinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwepiccinitialcontact
    type: table
    repo: none
  - name: q-epicc-pathway-form-docsernos
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

# Q_EPICC_ACTIVE_PAYOR_SOURCE

## Purpose

Provides a one-row-per-client snapshot of active payor source data for EPICC clients. Supports payor source tracking, managed care analysis, and insurance coverage diagnostics.

## Description

- Built on `PWPAYORSOURCE`, filtered to include only active records (`PAYOR_SOURCE_END_DATE IS NULL`, `DOCREVNO = ' 0 '`).
- Aggregates and pivots payor source types into binary flags for simplified reporting.
- Resolves imported records using `PWEPICCINITIALCONTACT` to infer missing `PARENTDOCSERNO`.
- Retains the latest `PARENTDOCSERNO` per client to anchor reporting interval.
- Joins with `MANAGED_MEDICAID_PROVIDER` for descriptive metadata.

### Logic Summary

- **ACTIVE_PAYOR_SOURCE CTE**
  - Filters for active records and selects relevant fields.

- **AGGREGATED_PAYOR_SOURCE CTE**
  - Groups by `CLIENT_NUMBER` and `PAYOR_SOURCE`.
  - Resolves imported records using `PWEPICCINITIALCONTACT` to infer missing `PARENTDOCSERNO`.
  - Retains max `PARENTDOCSERNO`, provider fields, and flags for pivoting.
  - Filters to valid EPICC records via `Q_EPICC_PATHWAY_FORM_DOCSERNOS`.

- **PIVOTED_PAYOR_SOURCES CTE**
  - Pivots payor source codes into binary columns.
  - Includes provider fields and ensures one row per client.

- **LATEST_PARENTDOCSERNO CTE**
  - Identifies the latest `PARENTDOCSERNO` per client for reporting alignment.

- **FINAL_OUTPUT CTE**
  - Combines pivoted data with latest parent form linkage.
  - Joins to `MANAGED_MEDICAID_PROVIDER` for description enrichment.

## Output Fields

| Field Name                             | Description |
|----------------------------------------|-------------|
| `CLIENT_NUMBER`                        | Unique client identifier |
| `PARENT_DOCSERNO`                      | Latest reporting interval form |
| `PAYOR_SOURCE_*`                       | Binary flags for each payor source type |
| `MANAGED_MEDICAID_PROVIDER_CODE`       | Code for managed Medicaid provider |
| `MANAGED_MEDICAID_PROVIDER_DESCRIPTION`| Description from lookup table |
| `PRIVATE_INSURANCE_PROVIDER`          | Free-text field for private insurance |

## Payor Source Codes

| Code | Description |
|------|-------------|
| `001` | Dual Eligible (Medicare & Medicaid) |
| `002` | Medicaid |
| `003` | Medicaid Application In Progress |
| `004` | Medicaid CHP |
| `005` | Managed Medicaid |
| `006` | Medicare |
| `007` | Private Insurance |
| `008` | VA Benefits |
| `009` | Uninsured |
| `010` | Unknown / Refused |

## Maintenance Notes

- **Payor Source Expansion**: Update the `PIVOT` clause if new payor source codes are introduced.
- **Provider Metadata**: Ensure `MANAGED_MEDICAID_PROVIDER` remains aligned with codes used in `PWPAYORSOURCE`.
- **Form Linkage Integrity**: Confirm `Q_EPICC_PATHWAY_FORM_DOCSERNOS` includes all relevant DOCSERNOs for active clients.
- **Aggregation Caveats**: `MAX(PARENTDOCSERNO)` is used for aggregation; uniqueness is enforced later via `LATEST_PARENTDOCSERNO`.

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

- **2025-11-20**: Adds `COALESCE(EIC.DOCSERNO, EPAY.PARENTDOCSERNO) AS [PARENTDOCSERNO]` to replace just using `EPAY.PARENTDOCSERNO` in the `SELECT`.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Removes ShowMe Healthy Kids. It isn't relevant for EPICC. Updates PAY to EPAY.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-05-01**: Adds initial view definition to support active payor source reporting for EPICC clients.

</details>
</detials>
