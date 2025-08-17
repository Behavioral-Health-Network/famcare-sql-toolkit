# Q_YERE_ACTIVE_PAYOR_SOURCE

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-yere-active-payor-source.sql`  
**Last Updated:** **2025-08-10**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Provides a snapshot of each YERE client’s active payor source(s), pivoted into a single row per client. Supports reporting, managed care analysis, and insurance coverage diagnostics.

## Description

- Built on `PWPAYORSOURCE`, filtered to include only active records (`PAYOR_SOURCE_END_DATE IS NULL`).
- Aggregates and pivots payor source types into binary flags for simplified reporting.
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

## Changelog

- **2025-08-10**: Initial Markdown documentation authored.  
- **2025-04-30**: View created to support active payor source reporting for YERE clients.
