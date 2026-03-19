---
front-matter-title: EPICC Active Housing Status View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-epicc-active-housing-status.sql
last_updated: 2025-11-13
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
  - housing-status-data
change_control:
  - cross-repo-coordination
schema_version: 1.0
---

# EPICC Active Housing Status View Definition

## Purpose

Provides a one-row-per-client snapshot of the most recent active housing status for EPICC clients, supporting FY25 reporting and housing insecurity analysis.

## Description

- Built on `Q_EPICC_ALL_HOUSING_STATUS`, which contains full housing history including imported records.
- Filters to retain only the most recent, active housing status per client.
- Excludes historical records and test clients.
- Outputs pivoted housing status flags for simplified reporting.

### Logic Summary

- **CTE: `LATESTHOUSINGSTART`**
  - Identifies the most recent `HOUSING_START_DATE` per client.

- **CTE: `LATESTHOUSINGSTATUS`**
  - Filters to records matching the latest start date.
  - Ensures valid `PARENT_DOCSERNO` via `Q_EPICC_PATHWAY_FORM_DOCSERNOS`.

- **CTE: `FINALSELECTION`**
  - Resolves ties using `HOUSING_END_DATE` and `DOCSERNO`.
  - Substitutes null end dates with `'9999-12-31'` to prioritize ongoing statuses.

- **Final SELECT**
  - Joins with `Q_CLIENT_BHN` to exclude test clients.
  - Filters to `DOCREVNO = ' 0 '` to isolate current records.
  - Outputs:
    - Visit metadata
    - Housing status flags (pivoted)
    - Housing insecurity indicators (`IF_UNHOUSED_EXP`, `WORRIED_LOSING_HOUSING`, `HOMELESS_HOUSING_INSECURE_ETO`)

## Output Fields

| Field Name                              | Description                                      |
|----------------------------------------|--------------------------------------------------|
| `CLIENT_NUMBER`                        | Unique client ID                                 |
| `HOUSING_START_DATE` / `HOUSING_END_DATE` | Date range of housing status                    |
| `CLIENT_HOUSING_STATUS` (pivoted)      | Flags for each housing status type              |
| `HOUSING_STATUS_INCARCERATED`, `UNHOUSED_SHELTER` | Additional housing context |
| `IF_UNHOUSED_EXP`                      | Client reports prior experience of being unhoused |
| `WORRIED_LOSING_HOUSING`               | Client expresses concern about housing stability |
| `HOMELESS_HOUSING_INSECURE_ETO`        | Housing insecurity flag for ETO reporting        |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability              |

## Maintenance Notes

- **Alias Correction**: `HOUSE` → `EHOUSE` applied on 2025-08-09 for consistency.
- **Client Join Update**: Switched to `Q_CLIENT_BHN` on 2025-07-01 to align with standardized client metadata and test client exclusion.
- **Test Client Exclusion**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) in `Q_CLIENT_BHN`.
- **Housing Status Expansion**: Update CASE logic if new status types are introduced.
- **Dependency Awareness**: Changes to `Q_EPICC_ALL_HOUSING_STATUS`, `Q_EPICC_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` may affect logic integrity.

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

- **2025-11-13**: Adds `HOUSING_STATUS_INCARCERATED` and `UNHOUSED_SHELTER` fields.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-09**: Adds initial Markdown documentation; Corrects alias `HOUSE` to `EHOUSE`.  
- **2025-07-01**: Updates `Q_Client` join to use `Q_CLIENT_BHN` for test client exclusion.  
- **2025-05-05**: Adds initial view definition to support EPICC housing status reporting.

</details>
</details>
<!---CHANGELOG-END--->
