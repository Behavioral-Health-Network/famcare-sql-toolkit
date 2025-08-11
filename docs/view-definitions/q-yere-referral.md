# Q_YERE_REFERRAL

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-yere-referral.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BWW (BHN Data Team)  

## Purpose

Extracts and consolidates YERE referral data for reporting, eligibility tracking, and program evaluation.  
Includes client metadata, referral sources, CMHC/ADA status, and housing context.

## Description

- Pulls structured data from the `PWYEREREFERRAL` form.
- Enriches coded fields with descriptive metadata from multiple lookup tables.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of referral pathways, agency involvement, and client eligibility.

### Logic Summary

- **Source Table:**
  - `PWYEREREFERRAL` (aliased as `YREF`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN PROGRAM_REFERRAL_SOURCES` for hospital referral descriptions
  - `LEFT JOIN CIMOR_STATUS` for CMHC and ADA status descriptions
  - `LEFT JOIN CMHC_AGENCY` and `ADA_SU_AGENCY` for agency descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Referral metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `CALLERS_FIRST_LAST_NAME`, `REFERRED_FROM`
  - Referral sources: hospital, CMHC, ADA, and other agency flags
  - Eligibility and program participation: CMHC/ADA/DD status, ineligibility reason
  - Notes and context: suicide attempt flag, housing status, primary reason

## Maintenance Notes

- If new referral codes or agency types are introduced, ensure lookup tables are updated and joins remain valid.
- Monitor for changes in form structure, especially around eligibility flags and referral source logic.
- Consider surfacing diagnostic flags for missing referral descriptions or ambiguous agency matches.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored.
- **2025-07-02**: Switched to `Q_CLIENT_BHN` for client details and test client exclusion.  
- **2025-06-13**: Renamed table alias from `REF` to `YREF`.  
- **2025-05-23**: Initial creation to support YERE referral reporting and agency involvement tracking.
