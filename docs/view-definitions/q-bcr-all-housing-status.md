# Q_BCR_ALL_HOUSING_STATUS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-all-housing-status.sql`  
**Last Updated:** **2025-05-19**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Returns a complete history of housing status records for BCR clients. Each row represents a single housing status entry, linked to its reporting interval via `PARENTDOCSERNO`.


## Description

- Returns all housing status records for each client, providing a complete history of updates.
- Each row represents a single housing status record, linked to its reporting interval via `PARENTDOCSERNO`.
- Uses `COALESCE` to resolve missing `PARENTDOCSERNO` values for imported records, substituting with the `DOCSERNO` from the Initial Contact form (`PWBCRINITIALCONTACT`).
- Joins to `Q_CLIENT_BHN` to exclude test clients based on last name variants.
- Joins to `Q_BCR_PATHWAY_FORM_DOCSERNOS` to retrieve form type and validate parent form linkage.
- Transforms housing status types into pivoted columns for reporting:
  - `HOUSING_STATUS_STABLY_HOUSED`
  - `HOUSING_STATUS_UNHOUSED`
  - `HOUSING_STATUS_PRECARIOUSLY_HOUSED`
  - `HOUSING_STATUS_INSTITUTIONALLY_HOUSED`
  - `HOUSING_STATUS_UNKNOWN`

### Logic Summary

- **Primary Source:** `PWHOUSINGSTATUS`
  - Filters to active records (`DOCREVNO = ' 0 '`).
  - Includes housing status metadata and pathway linkage.

- **Joins:**
  - `Q_CLIENT_BHN` for client details and test client exclusion.
  - `PWBCRINITIALCONTACT` for fallback parent form linkage.
  - `Q_BCR_PATHWAY_FORM_DOCSERNOS` for form type and validation.

- **Parent Form Resolution:**
  - Uses `COALESCE(HOUSE.PARENTDOCSERNO, BIC.DOCSERNO)` to ensure all records have a valid parent form reference.

- **Output Fields:**
  - Housing status flags, start/end dates, pathway metadata, and form type.

## Maintenance Notes

- If new housing status types are introduced, update the `CASE` statements in the SELECT clause.
- Monitor naming conventions for test clients and update exclusion logic as needed.
- Changes to `PWHOUSINGSTATUS`, `PWBCRINITIALCONTACT`, `Q_BCR_PATHWAY_FORM_DOCSERNOS`, or `Q_CLIENT_BHN` may affect this view.

## Changelog

- **2025-05-19**: Initial view definition authored.
