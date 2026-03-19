---
front-matter-title: YERE Active Payor Source View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-active-payor-source.sql
last_updated: 2026-03-16
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
  - active-record-view
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
  - name: managed-medicaid-provider
    type: table
    repo: none
change_control: value
schema_version: 1.0
---

# YERE Active Payor Source View Definition

## Purpose

Provides a snapshot of each YERE client’s active payor source(s), pivoted into a single row per client. Supports reporting, managed care analysis, and insurance coverage diagnostics.

## Description

- Built on `PWPAYORSOURCE`, filtered to include only active records (`PAYOR_SOURCE_END_DATE IS NULL`).
- Aggregates and pivots payor source types into binary flags for simplified reporting.
- Resolves imported records using `PWYEREINITIALCONTACT` to infer missing `PARENTDOCSERNO`.
- Retains the latest `PARENTDOCSERNO` per client to anchor reporting interval.
- Joins with `MANAGED_MEDICAID_PROVIDER` for descriptive metadata.

### Logic Summary

- **ACTIVE_PAYOR_SOURCE CTE**
  - Filters for active records (`DOCREVNO = ' 0 '` and no end date).
  - Selects relevant fields for aggregation and pivoting.

- **AGGREGATED_PAYOR_SOURCE CTE**
  - Groups by `CLIENTNUMBER` and `PAYOR_SOURCE`.
  - Retains max `PARENTDOCSERNO` and provider fields.
  - Filters to valid YERE records via `Q_YERE_PATHWAY_FORM_DOCSERNOS`.

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
| `MANAGED_MEDICAID_PROVIDER`           | Code for managed Medicaid provider |
| `MANAGED_MEDICAID_PROVIDER_DESCRIPTION` | Description from lookup table |
| `PRIVATE_INSURANCE_PROVIDER`          | Free-text field for private insurance |
| `SHOWME_HEALTHY_KIDS`                 | Indicator for SMHK program enrollment |

## Maintenance Notes

- **Payor Source Expansion**: Update the `PIVOT` clause if new payor source codes are introduced.
- **Provider Metadata**: Ensure `MANAGED_MEDICAID_PROVIDER` table remains aligned with codes used in `PWPAYORSOURCE`.
- **Form Linkage Integrity**: Confirm `Q_YERE_PATHWAY_FORM_DOCSERNOS` includes all relevant DOCSERNOs for active clients.
- **Aggregation Caveats**: `MAX(PARENTDOCSERNO)` is used for aggregation; uniqueness is enforced later via `LATEST_PARENTDOCSERNO`.

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

- **2025-12-12**: Adds collapsible `<details>` elements to the Changelog section.
- **2025-11-20**: Adds `COALESCE(YIA.DOCSERNO, YPAY.PARENTDOCSERNO) AS [PARENTDOCSERNO]` to replace just using `YPAY.PARENTDOCSERNO` in the `SELECT`. Updates dependencies in the frontmatter YAML to include join to `PWYEREINITIALCONTACT`.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-04-30**: Adds initial view definition to support active payor source reporting for YERE clients.

</details>
</details>
<!---CHANGELOG-END--->
