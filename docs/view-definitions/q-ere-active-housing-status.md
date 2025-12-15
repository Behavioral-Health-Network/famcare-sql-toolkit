---
front-matter-title: Q_ERE_ACTIVE_HOUSING_STATUS
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-ere-active-housing-status.sql
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
  - housing-status-data
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

# Q_ERE_ACTIVE_HOUSING_STATUS

## Purpose

Provides a one-row-per-client snapshot of the most recent active housing status for ERE clients, supporting FY25 reporting and housing insecurity analysis.

## Description

- Built on `Q_ERE_ALL_HOUSING_STATUS`, which contains full housing history including imported records.
- Filters to retain only the most recent, active housing status per client.
- Excludes historical records and test clients.
- Outputs pivoted housing status flags for simplified reporting.

### Logic Summary

- **CTE: `LATESTHOUSINGSTART`**
  - Identifies the most recent `HOUSING_START_DATE` per client.

- **CTE: `LATESTHOUSINGSTATUS`**
  - Filters to records matching the latest start date.
  - Ensures valid `PARENT_DOCSERNO` via `Q_ERE_PATHWAY_FORM_DOCSERNOS`.

- **CTE: `FINALSELECTION`**
  - Resolves ties using `HOUSING_END_DATE` and `DOCSERNO`.
  - Substitutes null end dates with `'9999-12-31'` to prioritize ongoing statuses.

- **Final SELECT**
  - Joins with `Q_CLIENT_BHN` to exclude test clients.
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

- **Alias Convention**: `EREHOUSE` used for clarity and consistency with other housing views.
- **Test Client Exclusion**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) in `Q_CLIENT_BHN`.
- **Housing Status Expansion**: Update CASE logic if new status types are introduced.
- **Dependency Awareness**: Changes to `Q_ERE_ALL_HOUSING_STATUS`, `Q_ERE_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` may affect logic integrity.

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
- **2025-08-09**: Adds initial Markdown documentation.  
- **2025-08-06**: Adds initial view definition to support ERE housing status reporting.

</details>
</detials>
