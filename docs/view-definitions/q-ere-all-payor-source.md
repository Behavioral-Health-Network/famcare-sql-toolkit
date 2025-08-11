# Q_ERE_ALL_PAYOR_SOURCE

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-ere-all-payor-source.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Returns all payor source records for ERE clients, including historical entries.  
Supports longitudinal tracking of insurance coverage and provider engagement across reporting intervals.

## Description

- Built on `PWPAYORSOURCE`, joined with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Resolves imported records using `PWEREIHNA` to infer missing `PARENTDOCSERNO`.
- Joins with `Q_ERE_PATHWAY_FORM_DOCSERNOS` to identify valid reporting intervals and form types.
- Includes both active and historical payor source records for comprehensive analysis.

### Logic Summary

- **Parent Form Resolution**
  - Uses `COALESCE(PARENTDOCSERNO, EREIHNA.DOCSERNO)` to ensure all records have a valid parent reference.
  - Filters to only include records with valid parent form linkage via `Q_ERE_PATHWAY_FORM_DOCSERNOS`.

- **Client Join**
  - Uses `Q_CLIENT_BHN` for name fields and test client exclusion.

- **Import Handling**
  - Resolves missing `PARENTDOCSERNO` for imported records using `PWEREIHNA`.

## Output Fields

| Field Name                             | Description |
|----------------------------------------|-------------|
| `CLIENT_NUMBER`, `CLIENT_FIRST`, `CLIENT_LAST` | Client identifiers |
| `DOCSERNO`, `PARENTDOCSERNO`, `FORM_TYPE` | Form and reporting interval linkage |
| `PAYOR_SOURCE`, `MANAGED_MEDICAID_PROVIDER`, `PRIVATE_INSURANCE_PROVIDER` | Insurance source and provider details |
| `PAYOR_SOURCE_START_DATE`, `PAYOR_SOURCE_END_DATE` | Coverage period |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability |

## Maintenance Notes

- **Import Logic**: Ensure `PWEREIHNA` remains aligned with import resolution logic.
- **Test Client Filtering**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`); update if naming conventions change.
- **Form Linkage**: Confirm that `Q_ERE_PATHWAY_FORM_DOCSERNOS` continues to reflect valid reporting intervals.
- **Provider Fields**: Validate that provider fields are consistently populated and aligned with form expectations.

## Changelog

- **2025-08-10**: Initial Markdown documentation authored.  
- **2025-08-10**: View created to support full payor source history for ERE clients.
