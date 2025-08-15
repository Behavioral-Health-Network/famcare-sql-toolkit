# Q_EPICC_SIX_MONTH

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-epicc-six-month.sql`  
**Last Updated:** **2025-08-09**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Extracts and consolidates EPICC 6-month follow-up data for longitudinal engagement tracking, MAT prescribing analysis, and program participation review. Includes client metadata, treatment path, appointment attendance, and transfer outcomes.

## Description

- Pulls structured data from the `PWEPICC6MONTHFOLLOWUP` form.
- Enriches coded fields with descriptive metadata from lookup tables.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of client retention, MAT prescribing, and regional transfer success.

### Logic Summary

- **Source Table:**
  - `PWEPICC6MONTHFOLLOWUP` (aliased as `ESIXM`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN EPICC_PROGRAM_PARTICIPATION` for program participation descriptions
  - `LEFT JOIN EPICC_TYPES_MAT` for MAT type descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Engagement: appointment attendance, communication dates, intake status
  - MAT prescribing: physician appointment, MAT type and description
  - Program participation: code and description
  - Transfer and region: transfer flags, contact success
  - Client status and pregnancy flags

## Maintenance Notes

- Ensure alignment with 30-day and 3-month views for field naming and join logic.
- Monitor for changes in form structure, especially around MAT and transfer fields.
- Consider surfacing diagnostic flags for missing MAT descriptions or ambiguous program codes.

## Changelog

- **2025-08-09**: Documentation authored and aligned with 30-day and 3-month scaffolds.  
- **2025-07-07**: Updated to use `Q_CLIENT_BHN` for test client exclusion and standardized field naming.  
- **2025-05-05**: Initial creation to support EPICC 6-month follow-up reporting and longitudinal engagement tracking.
