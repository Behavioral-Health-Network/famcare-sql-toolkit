# Q_BCR_PRESENTING_CONCERNS

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-bcr-presenting-concerns.sql`  
**Last Updated:** **2025-08-09**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Extracts and consolidates BCR Presenting Concerns summation form data for reporting, eligibility tracking, and program evaluation.

## Description

- Extracts and consolidates presenting concerns data for BCR clients.
- Built on top of `PWBCRPRESENTINGCONCERNS`, filtered to include only active records (`DOCREVNO = ' 0 '`).
- Joins to `Q_BCR_CLIENT` to retrieve client information and exclude test clients.
- Uses conditional logic to resolve missing `PARENTDOCSERNO` values:
  - If `PARENTDOCSERNO` is null or blank, substitutes with `DOCSERNO` from the imported Initial Contact form (`Q_BCR_IC`).
  - This differs from `Q_BCR_ALL_HOUSING_STATUS`, which uses `COALESCE` for null-only substitution.

### Logic Summary

- **Primary Source:** `PWBCRPRESENTINGCONCERNS`
  - Filters to active records.
  - Includes presenting concern flags and metadata.

- **Joins:**
  - `Q_BCR_CLIENT` for client linkage and test client exclusion.
  - `Q_BCR_IC` for fallback logic to resolve missing `PARENTDOCSERNO`.

- **Output Fields:**
  - Concern flags across behavioral health, housing, maternal health, physical health, social services, spiritual care, and other domains.
  - Pathway metadata and resolved parent form linkage.

## Maintenance Notes

- If new concern types are introduced, update the SELECT clause and downstream reporting logic.
- Ensure that `Q_BCR_IC` continues to support fallback logic for imported records.
- Monitor for changes in `PWBCRPRESENTINGCONCERNS` structure that could affect field availability or naming.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.
- **2025-06-27**: Initial view definition authored.
