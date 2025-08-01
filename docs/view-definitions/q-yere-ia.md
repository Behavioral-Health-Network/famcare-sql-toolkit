# Q_YERE_IA

**Category:** View Definitions  
**Source File:** `code/q-yere-ia.sql`  
**Last Updated:** 2025-07-01  
**Author:** BHN Data Team  

## Purpose

Support reporting and analytics for YERE initial assessments by combining assessment records with client demographics and school discipline descriptors.

## Description

- Extracts initial assessment data from `PWYEREINITIALCONTACT` (`YIA`).
- Joins with `Q_CLIENT_BHN` (`C`) to enrich with client details and exclude test clients.
- Joins with `YERE_TYPE_OF_SCHOOL_DISCIPLINE` (`YTSD`) to translate coded discipline values into readable descriptions.
- Filters on `DOCREVNO = ' 0 '` to include only current or relevant records.
- Selects a comprehensive field set to support downstream reporting, dashboards, and extracts.

## Maintenance Notes

- Used by analysts and reporting tools to monitor assessment patterns, client engagement, and event tracking.
- Ensure updates to source tables or business rules are reflected in this view to maintain data integrity.

## Changelog

- 2025-07-01: Refactors join to use `Q_CLIENT_BHN` for test client filtering.  
- 2025-06-13: Renames table alias from `IA` to `YIA`.  
- 2025-05-23: Adds initial view definition.
