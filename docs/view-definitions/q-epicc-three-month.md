# Q_EPICC_THREE_MONTH

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-epicc-three-month.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Extracts and consolidates EPICC 3-month follow-up data for longitudinal tracking, MAT engagement, and program participation analysis.  
Includes client metadata, treatment path, appointment attendance, and transfer outcomes.

## Description

- Pulls structured data from the `PWEPICC3MONTHFOLLOWUP` form.
- Enriches coded fields with descriptive metadata from lookup tables.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of client retention, MAT prescribing, and regional transfer success.

### Logic Summary

- **Source Table:**
  - `PWEPICC3MONTHFOLLOWUP` (aliased as `ETHREEM`)

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
  - Transfer and region: transfer flags, contact success, reengagement specialist date
  - Client status and pregnancy flags

## Maintenance Notes

- Ensure alignment with the 30-day view for field naming and join logic.
- Monitor for changes in form structure, especially around MAT and transfer fields.
- Consider surfacing diagnostic flags for missing MAT descriptions or ambiguous program codes.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.
- **2025-07-07**: Updated to use `Q_CLIENT_BHN` for test client exclusion and standardized field naming.  
- **2025-06-16**: Corrected join logic for `WHAT_MAT_PHYSICIAN_APPT_THREE_MONTH` to reference correct code field.  
- **2025-05-05**: Initial creation to support EPICC 3-month follow-up reporting and longitudinal engagement tracking.
