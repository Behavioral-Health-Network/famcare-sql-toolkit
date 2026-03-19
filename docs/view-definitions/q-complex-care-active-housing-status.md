---
front-matter-title: Complex Care Active Housing Status View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-complex-care-active-housing-status.sql
last_updated: 2025-11-14
status: active
lifecycle: production
program_scope: single
programs:
  - complex-care
tags:
  - view-layer
  - summation-view
  - slowly-changing-dimension
  - active-record-view
  - housing-status-data
dependencies:
  - name: q-complex-care-all-housing-status
    type: sql
    repo: famcare-sql-toolkit
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# Complex Care Active Housing Status View Definition

## Purpose

Provides a one-row-per-client snapshot of the most recent active housing status for Complex Care clients, including baseline housing information for comparison.

## Description

- Built on `Q_COMPLEX_CARE_ALL_HOUSING_STATUS`, which contains full housing history.
- Filters to retain only the most recent, active housing status per client while also displaying baseline data.
- Excludes historical records and test clients.
- Outputs pivoted baseline and current housing status flags for simplified reporting, along with housing insecurity indicators.

### Logic Summary

- **CTE: `LATESTHOUSINGSTART`**
  - Identifies the most recent `HOUSING_START_DATE` per client.

- **CTE: `LATESTHOUSINGSTATUS`**
  - Filters to records matching the latest start date.
  - Ensures valid `PARENT_DOCSERNO` via `Q_COMPLEX_CARE_PATHWAY_FORM_DOCSERNOS`.
  - Includes housing context fields (`HOUSING_STATUS_INCARCERATED`, `UNHOUSED_SHELTER`, `IF_UNHOUSED_EXP`, `WORRIED_LOSING_HOUSING`, `HOMELESS_HOUSING_INSECURE_ETO`).

- **CTE: `BASELINEHOUSINGSTATUS`**
  - Captures the earliest housing status per client as baseline.
  - Provides baseline start/end dates and baseline housing status.

- **CTE: `FINALSELECTION`**
  - Resolves ties by selecting max `PARENT_DOCSERNO` and `DOCSERNO` per client.

- **Final SELECT**
  - Joins with `Q_CLIENT_BHN` to exclude test clients.
  - Filters to `DOCREVNO = ' 0 '` to isolate current records.
  - Outputs:
    - Entry metadata (`VISITDT`, `VISITTM`, `USERID`)
    - Baseline housing status and pivoted flags
    - Current housing status and pivoted flags
    - Housing insecurity indicators

## Output Fields

| Field Name                                      | Description                                      |
|-------------------------------------------------|--------------------------------------------------|
| `CLIENT_NUMBER`                                | Unique client ID                                 |
| `DOCSERNO`, `PARENT_DOCSERNO`                  | Document identifiers for traceability            |
| `VISITDT`, `VISITTM`, `USERID`                 | Metadata for audit and traceability              |
| `BASELINE_HOUSING_START_DATE` / `BASELINE_HOUSING_END_DATE` | Date range of baseline housing status |
| `BASELINE_CLIENT_HOUSING_STATUS`               | Baseline housing status value                    |
| `BASELINE_HOUSING_STATUS_*` (pivoted flags)    | Flags for baseline housing status categories     |
| `CURRENT_HOUSING_START_DATE` / `CURRENT_HOUSING_END_DATE` | Date range of current housing status |
| `CURRENT_CLIENT_HOUSING_STATUS`                | Current housing status value                     |
| `CURRENT_HOUSING_STATUS_*` (pivoted flags)     | Flags for current housing status categories      |
| `HOUSING_STATUS_INCARCERATED`                  | Current incarceration housing flag               |
| `UNHOUSED_SHELTER`                             | Current shelter flag                             |
| `IF_UNHOUSED_EXP`                              | Client reports prior experience of being unhoused |
| `WORRIED_LOSING_HOUSING`                       | Client expresses concern about housing stability |
| `HOMELESS_HOUSING_INSECURE_ETO`                | Housing insecurity flag for ETO reporting        |

## Maintenance Notes

- **Test Client Exclusion**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) in `Q_CLIENT_BHN`.
- **Housing Status Expansion**: Update CASE logic if new status types are introduced.
- **Dependency Awareness**: Changes to `Q_COMPLEX_CARE_ALL_HOUSING_STATUS`, `Q_COMPLEX_CARE_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` may affect logic integrity.
- **Baseline Logic**: Ensure baseline CTE continues to select earliest housing record per client.

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

- **2025-11-14**: Adds initial Markdown documentation.
- **2025-11-13**: Adds initial view definition to support Complex Care housing status reporting.

</details>
</details>
<!---CHANGELOG-END--->
