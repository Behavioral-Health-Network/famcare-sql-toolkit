# Q_YERE_ALL_HOUSING_STATUS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-yere-all-housing-status.sql`  
**Last Updated:** **2025-08-10**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

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
| `IF_UNHOUSED_EXP`, `WORRIED_LOSING_HOUSING`, `HOMELESS_HOUSING_INSECURE_ETO` | Housing insecurity indicators |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability |

## Maintenance Notes

- **Import Logic**: Ensure `Q_YERE_IA` remains aligned with import resolution logic and pathway date matching.
- **Test Client Exclusion**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`) in `Q_CLIENT_BHN`.
- **Housing Status Expansion**: Update CASE logic if new status types are introduced.
- **Dependency Awareness**: Changes to `PWHOUSINGSTATUS`, `PWYEREINITIALCONTACT`, `Q_YERE_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` may affect logic integrity.

## Changelog

- **2025-08-10**: Initial Markdown documentation authored.  
- **2025-06-11**: View definition created to support full housing status history for YERE clients.
