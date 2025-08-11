# Q_ERE_REFERRAL

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-ere-referral.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Extracts and consolidates ERE referral data for reporting, eligibility tracking, and program evaluation.  
Includes client metadata, referral sources, employment status, and ineligibility flags.

## Description

- Pulls structured data from the `PWEREREFERRAL` form.
- Joins with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Enriches coded fields with descriptive metadata from referral source, employment status, and ineligible status tables.

### Logic Summary

- **Source Table:**
  - `PWEREREFERRAL` (aliased as `EREREF`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN PROGRAM_REFERRAL_SOURCES` for referring agency descriptions
  - `LEFT JOIN ERE_EMPLOY_STATUS` for employment status descriptions
  - `LEFT JOIN ERE_INELIGIBLE_STATUS` for ineligible reason descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Referral metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `CALLER_NAME`, `REFERRAL_METHOD`
  - Referral sources: agency code and description, patient location, IP hospital
  - Eligibility: flags for EPICC referral, client eligibility, ineligible reason and description
  - Employment and military status
  - Engagement: `CLIENT_ENGAGE`

## Maintenance Notes

- Monitor for changes in referral source codes and ensure lookup tables remain aligned.
- Consider surfacing diagnostic flags for ambiguous eligibility or missing referral reasons.
- Align naming conventions with other ERE views for consistency across reporting layers.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored to support standardized view tracking.  
- **2025-07-16**: View definition created to support ERE referral reporting and eligibility tracking.
