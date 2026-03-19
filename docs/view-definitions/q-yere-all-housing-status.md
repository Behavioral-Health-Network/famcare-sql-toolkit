---
front-matter-title: YERE All Housing Status View Definition
category: view-definitions
category_label: View Definitions
source_file: code/view-definitions/q-yere-all-housing-status.sql
last_updated: 2025-11-13
status: active
lifecycle: production
program_scope: single
programs:
  - yere
tags:
  - view-layer
  - summation-view
  - slowly-changing-dimension
  - historical-record-view
  - housing-status-data
dependencies:
  - name: pwhousingstatus
    type: html
    repo: famcare-html-form-code
  - name: pwhousingstatus
    type: table
    repo: none
  - name: q-client-bhn
    type: sql
    repo: famcare-sql-toolkit
  - name: q-pathway-form-docsernos
    type: sql
    repo: famcare-sql-toolkit
  - name: pwyereinitialcontact
    type: html
    repo: famcare-html-form-code
  - name: pwyereinitialcontact
    type: table
    repo: none
change_control: value
schema_version: 1.0
---

# YERE All Housing Status View Definition

## Purpose

Returns a complete history of housing status records for YERE clients. Supports longitudinal analysis, reporting interval alignment, and housing insecurity diagnostics.

## Description

- Built on `PWHOUSINGSTATUS`, joined with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Resolves imported records using `Q_YERE_IA` to infer missing `PARENTDOCSERNO`.
- Joins with `Q_YERE_PATHWAY_FORM_DOCSERNOS` to identify valid reporting intervals and form types.
- Includes both active and historical housing status records.

### Logic Summary

- **Parent Form Resolution**
  - Uses `COALESCE(PARENTDOCSERNO, YIA.DOCSERNO)` to ensure all records have a valid parent reference.
  - Filters to only include records with valid parent form linkage via `Q_YERE_PATHWAY_FORM_DOCSERNOS`.

- **Client Join**
  - Uses `Q_CLIENT_BHN` to exclude test clients based on last name variants.

- **Import Handling**
  - Resolves missing `PARENTDOCSERNO` for imported records using `Q_YERE_IA`.

- **Pivoted Status Flags**
  - Converts `CLIENT_HOUSING_STATUS` into five binary columns:
    - `HOUSING_STATUS_INSTITUTIONALLY_HOUSED`
    - `HOUSING_STATUS_PRECARIOUSLY_HOUSED`
    - `HOUSING_STATUS_STABLY_HOUSED`
    - `HOUSING_STATUS_UNHOUSED`
    - `HOUSING_STATUS_UNKNOWN`

## Output Fields

| Field Name                             | Description |
|----------------------------------------|-------------|
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers |
| `PARENT_DOCSERNO`, `FORM_TYPE`         | Reporting interval linkage |
| `HOUSING_START_DATE`, `HOUSING_END_DATE` | Date range of housing status |
| `CLIENT_HOUSING_STATUS` (pivoted)      | Flags for each housing status type |
| `HOUSING_STATUS_INCARCERATED` and `UNHOUSED_SHELTER`    | Additional housing indicators for institutionally housed and unhoused   |
| `IF_UNHOUSED_EXP`, `WORRIED_LOSING_HOUSING`, `HOMELESS_HOUSING_INSECURE_ETO` | Housing insecurity indicators |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability |

## Maintenance Notes

- **Import Logic**: Ensure `Q_YERE_IA` remains aligned with import resolution logic and pathway date matching.
- **Test Client Exclusion**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) in `Q_CLIENT_BHN`.
- **Housing Status Expansion**: Update CASE logic if new status types are introduced.
- **Dependency Awareness**: Changes to `PWHOUSINGSTATUS`, `PWYEREINITIALCONTACT`, `Q_YERE_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` may affect logic integrity.

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

- **2025-12-12**: Adds collapsible `<details>` elements to the Changelog section.
- **2025-11-13**: Adds fields `HOUSING_STATUS_INCARCERATED` and `UNHOUSED_SHELTER`. These had been added to the form back on 2025-06-23.
- **2025-08-18**: Adds Markdown frontmatter to replace the non-machine-readable tags.
- **2025-08-10**: Adds initial Markdown documentation.  
- **2025-06-11**: Adds initial view definition to support full housing status history for YERE clients.

</details>
</details>
<!---CHANGELOG-END--->
