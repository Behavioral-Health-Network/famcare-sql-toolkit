# Q_ERE_SIX_MONTH

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-ere-six-month.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Supports ERE 6-month follow-up reporting by extracting client engagement, contact outcomes, and recent service utilization.  
Includes employment status metadata and filters out test clients and non-current records.

## Description

- Pulls structured data from the `PWERESIXMONTHFOLLOWUP` form.
- Joins with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Enriches employment status codes with descriptions via `EMPLOYMENTSTATUS`.

### Logic Summary

- **Source Table:**
  - `PWERESIXMONTHFOLLOWUP` (aliased as `ERESIXM`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN EMPLOYMENTSTATUS` for employment code descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`
  - Engagement: ERE service status, ineligibility reason, PPC contact result
  - Employment: status code and description
  - Service utilization: ER visits, hospitalizations, law enforcement contacts

## Maintenance Notes

- Monitor for changes in employment status codes and ensure descriptions remain aligned.
- Consider surfacing diagnostic flags for ambiguous PPC contact results or missing engagement status.
- Align naming conventions with other ERE follow-up views for consistency.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored to support standardized view tracking.  
- **2025-07-22**: View definition created to support ERE 6-month follow-up reporting.
