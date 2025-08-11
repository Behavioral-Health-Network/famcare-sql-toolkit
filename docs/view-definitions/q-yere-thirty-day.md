# Q_YERE_THIRTY_DAY

**Category:** View Definitions  
**Source File:** `code/view-definitions/q-yere-thirty-day.sql`  
**Last Updated:** **2025-08-09**  
**Author:** BHN Data Team  

## Purpose

Extracts and consolidates YERE 30-day follow-up data for engagement tracking, residency changes, and behavioral health intake monitoring.  
Includes client metadata, contact methods, school and residency changes, and collaboration indicators.

## Description

- Pulls structured data from the `PWYERE30DAYFOLLOWUPTP` form.
- Filters out test clients via `Q_CLIENT_BHN` and excludes non-current records.
- Supports analysis of youth engagement, service plan barriers, and staffing coordination.

### Logic Summary

- **Source Table:**
  - `PWYERE30DAYFOLLOWUPTP` (aliased as `YTHIRTYD`)

- **Joins:**
  - `INNER JOIN Q_CLIENT_BHN` for client metadata and test client exclusion

- **Key Filters:**
  - `DOCREVNO = ' 0 '` to isolate current records

- **Output Fields:**
  - Follow-up metadata: `VISITDT`, `USERID`, `PATHWAY_DATE`, `PARENT_DOCSERNO`
  - Engagement: active status, contact method, intake attendance
  - Residency: change flags, change types, barrier alignment
  - School and staffing: school changes, collaboration staffing, guardian meetings
  - Behavioral health: engagement indicators, notes

## Maintenance Notes

- Monitor for changes in form structure, especially around residency and staffing fields.
- Consider surfacing diagnostic flags for ambiguous contact methods or missing intake attendance.
- Ensure alignment with other YERE follow-up views for naming and logic consistency.

## Changelog

- **2025-08-09**: Initial Markdown documentation authored to support standardized view tracking.  
- **2025-07-07**: Updated to use `Q_CLIENT_BHN` for test client exclusion and standardized field naming.  
- **2025-05-23**: Initial view definition created to support YERE 30-day follow-up reporting.
