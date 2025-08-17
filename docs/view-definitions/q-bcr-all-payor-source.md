# BCR_ALL_PAYOR_SOURCE

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-all-payor-source.sql`  
**Last Updated:** **2025-08-09**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Returns all payor source records for BCR clients, including historical entries. Supports longitudinal tracking of insurance coverage and provider engagement across reporting intervals.

## Description

- Built on `PWPAYORSOURCE`, joined with `Q_CLIENT` for client metadata and test client exclusion.
- Resolves imported records using `PWBCRINITIALCONTACT` to infer missing `PARENTDOCSERNO`.
- Joins with `Q_BCR_PATHWAY_FORM_DOCSERNOS` to identify valid reporting intervals and form types.
- Includes both active and historical payor source records for comprehensive analysis.

### Logic Summary

- **Parent Form Resolution**
  - Uses `COALESCE(PARENTDOCSERNO, BIC.DOCSERNO)` to ensure all records have a valid parent reference.
  - Filters to only include records with valid parent form linkage via `Q_BCR_PATHWAY_FORM_DOCSERNOS`.

- **Client Join**
  - Uses `Q_CLIENT` for name fields and test client exclusion (`LASTNAME NOT IN (...)`).

- **Import Handling**
  - Resolves missing `PARENTDOCSERNO` for imported records using `PWBCRINITIALCONTACT`.

## Output Fields

| Field Name                             | Description |
|----------------------------------------|-------------|
| `CLIENTNUMBER`, `FIRST_NAME`, `LAST_NAME` | Client identifiers |
| `DOCSERNO`, `PARENTDOCSERNO`, `FORM_TYPE` | Form and reporting interval linkage |
| `PAYOR_SOURCE`, `MANAGED_MEDICAID_PROVIDER`, `PRIVATE_INSURANCE_PROVIDER` | Insurance source and provider details |
| `SHOW_ME_HEALTHY_KIDS`                 | Program participation indicator |
| `PAYOR_SOURCE_START_DATE`, `PAYOR_SOURCE_END_DATE` | Coverage period |
| `VISITDT`, `VISITTM`, `USERID`         | Metadata for audit and traceability |

## Maintenance Notes

- **Import Logic**: Ensure `PWBCRINITIALCONTACT` remains aligned with import resolution logic.
- **Test Client Filtering**: Based on last name variants (`GVTTest`, `GVTest`, `GVTTEST`); update if naming conventions change.
- **Form Linkage**: Confirm that `Q_BCR_PATHWAY_FORM_DOCSERNOS` continues to reflect valid reporting intervals.
- **Provider Fields**: Validate that provider fields are consistently populated and aligned with form expectations.

## Changelog

- **2025-08-10**: Removes ShowMe Healthy Kids. It's not relevant for BCR. Changes PAY alias to BPAY.
- **2025-08-09**: Initial Markdown documentation authored.  
- **2025-06-11**: View created to support full payor source history for BCR clients.
