---
front-matter-title: ex Care All Payor Source View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-all-payor-source.sql
last_updated: 2026-03-16
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
  - payor-source-data
dependencies:
  - name: pwpayorsource
    type: html
    repo: famcare-html-form-code
  - name: pwpayorsource
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
schema_version: 1.0
---

# Complex Care All Payor Source View Definition

## Purpose

Provides the full historical record of payor source entries for Complex Care clients. Includes all baseline and subsequent payor source changes, with descriptive metadata and pivoted flags for simplified reporting.

## Description

- Built on `PWPAYORSOURCE`, joined to `Q_CLIENT_BHN` for client metadata.
- Scoped to Complex Care clients via linkage to `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS`.
- Retains all records (`DOCREVNO = '0'`) rather than filtering to active only.
- Outputs both descriptive values and binary flags for each payor source type.
- Provides traceability through `DOCSERNO`, `PARENT_DOCSERNO`, and visit metadata.

### Logic Summary

- **Source Table:** `PWPAYORSOURCE` (payor source form data).
- **Client Join:** `Q_CLIENT_BHN` for client identifiers and names.
- **Program Scope:** `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` ensures only Complex Care records are included.
- **Filters:** `DOCREVNO = '0'` to exclude revised/voided records.
- **Output:**
  - Raw payor source codes and descriptions.
  - Start/end dates for each payor source interval.
  - Pivoted flags for each payor source category.

## Output Fields

| Field Name                          | Description |
|-------------------------------------|-------------|
| `ID`                                | Internal record identifier |
| `DOCSERNO`, `DOCREVNO`              | Document identifiers and revision number |
| `VISIT_DATE`, `VISITTM`, `USERID`   | Metadata for audit and traceability |
| `PARENT_DOCSERNO`                   | Parent form reference |
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers and names |
| `PATHWAY_DATE`                      | Date of pathway form |
| `PAYOR_SOURCE_CODE` / `DESCRIPTION` | Payor source value |
| `MANAGED_MEDICAID_PROVIDER`         | Managed Medicaid provider code |
| `PRIVATE_INSURANCE_PROVIDER`        | Free‑text entry for private insurance |
| `PAYOR_SOURCE_START_DATE` / `END_DATE` | Date range of payor source |
| `PAYOR_SOURCE_*` (pivoted flags)    | Binary flags for each payor source category |

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

- **Historical Scope:** This view retains all records, not just active ones.  
- **New Payor Types:** Update CASE logic if new codes are introduced.  
- **Provider Tables:** Ensure `MANAGED_MEDICAID_PROVIDER` remains aligned with form codes.  
- **Program Scope:** Confirm `Q_COMPLEX_CARE_MERCY_BEACN_BENCHMARKS` continues to reflect valid Complex Care clients.  

<!---DEPENDENCIES-START--->
<!---DEPENDENCIES-END--->

<!---CHANGELOG-START--->
## Changelog

<details markdown="1">
  <summary><strong>View Changelog Details</strong></summary>

<details markdown="1">
  <summary><strong>2026</strong></summary>

### 2026

- **2026-03-16**: Renames `MANAGED_MEDICAID_PROVIDER`to `MANAGED_MEDICAID_PROVIDER_CODE` to align with the convention for queries of `code` columns from Master Tables.

</details>

<details markdown="1">
  <summary><strong>2025</strong></summary>

### 2025

- **2025-11-14**: Adds initial view definition to support full payor source history reporting for Complex Care clients. Adds initial Markdown documentation.

</details>
</details>
<!---CHANGELOG-END--->
