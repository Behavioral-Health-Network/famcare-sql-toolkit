---
front-matter-title: Complex Care Active Payor Source View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-active-payor-source.sql
last_updated: 2025-11-14
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - view-layer
  - summation-view
  - active-record-view
  - payor-source-data
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care Active Payor Source View Definition

## Purpose

Provides a one‑row‑per‑client snapshot of payor source at **baseline (enrollment)** and **current (latest active)**. Outputs both descriptive values and pivoted flags for simplified reporting, with linkage to managed Medicaid provider metadata.

## Description

- Built on `Q_COMPLEX_CARE_ALL_PAYOR_SOURCE`, which is already program‑scoped to Complex Care.
- Derives **baseline payor source** as the earliest record per client.
- Derives **current payor source** as the latest active record (`PAYOR_SOURCE_END_DATE IS NULL`).
- Emits binary flags for each payor source code at both baseline and current.
- Joins to `MANAGED_MEDICAID_PROVIDER` for descriptive enrichment.

### Logic Summary

- **ALL_PAYOR CTE**
  - Provides the program‑scoped source data.

- **BASELINE_PAYOR CTE**
  - Uses `ROW_NUMBER()` to select the earliest payor source per client.

- **LATEST_ACTIVE CTE**
  - Uses `ROW_NUMBER()` to select the latest active payor source per client.

- **Final SELECT**
  - Joins baseline and current records.
  - Outputs descriptive fields and pivoted flags.
  - Enriches managed Medicaid provider code with description.

## Output Fields

| Field Name                                | Description |
|-------------------------------------------|-------------|
| `CLIENT_NUMBER`                           | Unique client identifier |
| `DOCSERNO`, `PARENT_DOCSERNO`             | Document identifiers for traceability |
| `VISITDT`, `VISITTM`, `USERID`            | Metadata for audit and traceability |
| `BASELINE_PAYOR_SOURCE_START_DATE` / `BASELINE_PAYOR_SOURCE_END_DATE` | Date range of baseline payor source |
| `BASELINE_PAYOR_SOURCE_CODE` / `DESCRIPTION` | Baseline payor source value |
| `BASELINE_PAYOR_SOURCE_*` (pivoted flags) | Flags for baseline payor source categories |
| `CURRENT_PAYOR_SOURCE_START_DATE` / `CURRENT_PAYOR_SOURCE_END_DATE` | Date range of current payor source (end date is NULL by design) |
| `CURRENT_PAYOR_SOURCE_CODE` / `DESCRIPTION` | Current payor source value |
| `CURRENT_PAYOR_SOURCE_*` (pivoted flags) | Flags for current payor source categories |
| `MANAGED_MEDICAID_PROVIDER_CODE`          | Managed Medicaid provider code |
| `MANAGED_MEDICAID_PROVIDER_DESCRIPTION`   | Human‑readable description |
| `PRIVATE_INSURANCE_PROVIDER`              | Free‑text entry from form |

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

- **Baseline Logic**: Always selects the earliest payor source record per client.  
- **Current Logic**: Always selects the latest active record (`PAYOR_SOURCE_END_DATE IS NULL`).  
- **New Payor Types**: Update CASE logic if new codes are introduced.  
- **Provider Tables**: Ensure `MANAGED_MEDICAID_PROVIDER` remains up to date and aligned with form codes.  
- **Consistency**: Mirrors the baseline/current housing status view for reporting alignment.

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
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

- **2025-11-14**: Adds initial view definition to support full payor source history reporting for Complex Care clients. Adds initial Markdown documentation.

</details>
</details>
<!---CHANGELOG-END--->
