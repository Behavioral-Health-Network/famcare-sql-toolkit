# Q_ERE_THREE_MONTH

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-ere-three-month.sql`  
**Last Updated:** **2025-08-09**  
**Author:** Bradley Wing  
**Lifecycle:** `Production`

---

## Purpose

Supports ERE 3-month follow-up reporting by extracting client engagement, contact outcomes, and recent service utilization. Includes employment status metadata and filters out test clients and non-current records.

## Description

- Pulls structured data from the `PWERETHREEMONTHFOLLOWUP` form.
- Joins with `Q_CLIENT_BHN` for client metadata and test client exclusion.
- Enriches employment status codes with descriptions via `EMPLOYMENTSTATUS`.

### Logic Summary

- **Source Table:**
  - `PWERETHREEMONTHFOLLOWUP` (aliased as `ERETHREEM`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion
  - `LEFT JOIN EMPLOYMENTSTATUS` for employment code descriptions

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENTDOCSERNO`
  - Engagement: ERE service status, ineligibility reason, PPC contact result
  - Employment: status code and description
  - Service utilization: ER visits, hospitalizations, law enforcement contacts

## Maintenance Notes

- Ensure field naming remains aligned with six-month view for audit and contributor clarity.
- Consider surfacing diagnostic flags for missing engagement status or ambiguous PPC contact results.
- Monitor for changes in employment status codes and update descriptions accordingly.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored to support standardized view tracking.  
- **2025-07-22**: View definition created to support ERE 3-month follow-up reporting.
