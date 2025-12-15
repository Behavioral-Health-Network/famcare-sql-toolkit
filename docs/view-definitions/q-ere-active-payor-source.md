---
front-matter-title: Q_ERE_ACTIVE_PAYOR_SOURCE
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-active-payor-source.sql
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
  - active-record-view
  - insurance-data
dependencies:
  - value1
  - value2
change_control:
  - cross-repo-coordination
reviewed_by:
  - name: Bradley Wing
    date: 2025-08-18
last_reviewed: 2025-08-18
schema_version: 1.0
---

# Q_ERE_ACTIVE_PAYOR_SOURCE

## Purpose

Provides a snapshot of each client’s active payor source(s), pivoted into individual columns for simplified reporting. Ensures only current, relevant payor source data is retained, with descriptive linkage to managed Medicaid providers.

## Description

- Built on `PWPAYORSOURCE`, filtered to include only active records (`PAYOR_SOURCE_END_DATE IS NULL`, `DOCREVNO = ' 0 '`).
- Aggregates and pivots payor source types into binary flags per client.
- Retains the most recent `PARENTDOCSERNO` for each client to support reporting interval alignment.
- Joins with `MANAGED_MEDICAID_PROVIDER` for descriptive metadata.

### Logic Summary

- **ACTIVE_PAYOR_SOURCE CTE**
  - Filters for active records only.
  - Selects relevant fields for aggregation and pivoting.

- **AGGREGATED_PAYOR_SOURCE CTE**
  - Groups by `CLIENT_NUMBER` and `PAYOR_SOURCE`.
  - Retains max `PARENTDOCSERNO`, provider fields, and adds a flag for pivoting.

- **PIVOTED_PAYOR_SOURCES CTE**
  - Pivots payor source codes into binary columns.
  - Includes provider fields for managed Medicaid and private insurance.

- **LATEST_PARENTDOCSERNO CTE**
  - Identifies the latest `PARENTDOCSERNO` per client for uniqueness.

- **FINAL_OUTPUT CTE**
  - Combines pivoted data with latest parent form reference.
  - Joins with `MANAGED_MEDICAID_PROVIDER` for description enrichment.

## Output Fields

| Field Name                             | Description |
|----------------------------------------|-------------|
| `CLIENT_NUMBER`                        | Unique client identifier |
| `PARENT_DOCSERNO`                      | Latest parent form reference |
| `PAYOR_SOURCE_*`                       | Binary flags for each payor source type |
| `MANAGED_MEDICAID_PROVIDER`           | Provider code |
| `MANAGED_MEDICAID_PROVIDER_DESCRIPTION` | Human-readable description |
| `PRIVATE_INSURANCE_PROVIDER`          | Free-text entry from form |

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

- **New Payor Types**: Update the `PIVOT` clause in `PIVOTED_PAYOR_SOURCES` if new codes are introduced.
- **Provider Tables**: Ensure `MANAGED_MEDICAID_PROVIDER` remains up to date and aligned with form codes.
- **Form Linkage**: Confirm that `Q_ERE_PATHWAY_FORM_DOCSERNOS` continues to reflect valid reporting intervals.
- **Uniqueness Assurance**: `LATEST_PARENTDOCSERNO` resolves potential duplication; test regularly for edge cases.

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

- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-08-06**: Adds initial view definition to support reporting on currently active or last open payor source.

</details>
</detials>
